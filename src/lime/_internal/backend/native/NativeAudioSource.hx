package lime._internal.backend.native;

#if cpp
import cpp.Pointer;
#end

import haxe.Int64;
import haxe.MainLoop;

import lime.media.AudioEffect;
import lime.media.AudioManager;
import lime.media.AudioSource;
import lime.media.miniaudio.MAAudioBuffer;
import lime.media.miniaudio.MAAudioBufferConfig;
import lime.media.miniaudio.MAAudioRingBuffer;
import lime.media.miniaudio.MANode;
import lime.media.miniaudio.MASound;
import lime.media.miniaudio.MASoundConfig;
import lime.media.miniaudio.nodes.MAPeakMeterNode;

@:access(lime.media.AudioBuffer)
@:access(lime.media.AudioEffect)
@:access(lime.media.AudioSource)
class NativeAudioSource
{
	// Sources with a sound, polled on the main thread for sounds that reached their end.
	private static var activeSources:Array<NativeAudioSource> = [];
	private static var atEndPoller:Null<haxe.MainLoop.MainEvent>;

	private var preRingBuffers:Array<MAAudioRingBuffer> = [];
	private var postRingBuffers:Array<MAAudioRingBuffer> = [];
	private var buffer:MAAudioBuffer;
	private var handle:MASound;
	private var meter:MAPeakMeterNode;
	private var loops:Int = 0;
	private var loopTime:Float = 0;
	private var parent:AudioSource;
	// effects currently wired between the sound and the meter, in order
	private var chainedEffects:Array<AudioEffect> = [];

	public function new(parent:AudioSource):Void
	{
		this.parent = parent;
	}

	public function dispose():Void
	{
		activeSources.remove(this);

		if (handle != null)
		{
			handle.stop();
			handle.uninit();
			handle = null;
		}

		// effect nodes go after the sound feeding them; init() makes new ones
		if (parent.__effects != null)
			for (effect in parent.__effects)
				effect.__releaseNode(parent);
		chainedEffects = [];

		// after the sound, which is attached to it
		if (meter != null)
		{
			meter.uninit();
			meter = null;
		}

		if (buffer != null)
		{
			buffer.uninit();
			buffer = null;
		}

		preRingBuffers = [];

		postRingBuffers = [];
	}

	public function init():Void
	{
		if (handle == null)
		{
			if (parent.buffer.__srcMADecoder != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pInitialAttachment = initMeter();
				config.pDataSource = parent.buffer.__srcMADecoder;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.__srcMAAudioBuffer != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pInitialAttachment = initMeter();
				config.pDataSource = parent.buffer.__srcMAAudioBuffer;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.__srcMAAudioRingBuffer != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pInitialAttachment = initMeter();
				config.pDataSource = parent.buffer.__srcMAAudioRingBuffer;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.data != null && parent.buffer.data.length > 0)
			{
				if (buffer == null)
				{
					buffer = MAAudioBuffer.init(MAAudioBufferConfig.init(parent.buffer.format, parent.buffer.channels, parent.buffer.sampleRate,
						parent.buffer.frames, #if cpp Pointer.ofArray(parent.buffer.data.buffer.getData()) #else null #end));
				}

				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pInitialAttachment = initMeter();
				config.pDataSource = buffer;

				handle = MASound.init(AudioManager.engine, config);
			}

			if (handle != null)
			{
				for (rb in preRingBuffers)
					handle.add_ring_buffer(rb, false);

				for (rb in postRingBuffers)
					handle.add_ring_buffer(rb, true);

				updateEffects();

				if (parent.offset > 0)
					setCurrentTime(parent.offset);

				if (!activeSources.contains(this))
					activeSources.push(this);

				if (atEndPoller == null)
					atEndPoller = MainLoop.add(pollAtEnd);
			}
		}
	}

	private function initMeter():MAPeakMeterNode
	{
		if (meter == null)
			meter = MAPeakMeterNode.init(AudioManager.engine);

		return meter;
	}

	public function play():Void
	{
		if (handle != null)
		{
			handle.start();
		}
	}

	public function pause():Void
	{
		if (handle != null)
		{
			handle.stop();
		}
	}

	public function stop():Void
	{
		if (handle != null)
		{
			handle.stop();

			if (parent.offset > 0)
				setCurrentTime(parent.offset);
			else
				handle.seek_to_pcm_frame(0);
		}
	}

	public function addPreRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (preRingBuffers.contains(rb))
			return;

		preRingBuffers.push(rb);

		if (handle != null)
			handle.add_ring_buffer(rb, false);
	}

	public function removePreRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (!preRingBuffers.contains(rb))
			return;

		preRingBuffers.remove(rb);

		if (handle != null)
			handle.remove_ring_buffer(rb, false);
	}

	public function addPostRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (postRingBuffers.contains(rb))
			return;

		postRingBuffers.push(rb);

		if (handle != null)
			handle.add_ring_buffer(rb, true);
	}

	public function removePostRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (!postRingBuffers.contains(rb))
			return;

		postRingBuffers.remove(rb);

		if (handle != null)
			handle.remove_ring_buffer(rb, true);
	}

	/**
		Wires the source's active effects between the sound and its meter, in order.
	**/
	public function updateEffects():Void
	{
		if (handle == null || meter == null || AudioManager.engine == null)
			return;

		final channels = AudioManager.engine.get_channels();
		final sampleRate = AudioManager.engine.get_sample_rate();

		final effects = parent.__effects != null ? parent.__effects : [];
		final chain:Array<AudioEffect> = [];
		var previous:MANode = cast handle;

		for (effect in effects)
		{
			if (effect.bypass)
				continue;

			final node = effect.__getNode(parent, channels, sampleRate);
			if (node == null)
				continue;

			previous.attach_output_bus(0, node, 0);
			previous = node;
			chain.push(effect);
		}

		previous.attach_output_bus(0, meter, 0);

		// unwire bypassed effects and release removed ones
		for (effect in chainedEffects)
		{
			if (!effects.contains(effect))
				effect.__releaseNode(parent);
			else if (!chain.contains(effect))
			{
				final node = effect.__nodes.get(parent);
				if (node != null)
					node.detach_all_output_buses();
			}
		}

		chainedEffects = chain;
	}

	/**
		Routes the sound straight to its meter again, leaving every effect node unwired.
	**/
	public function detachEffects():Void
	{
		if (handle == null || meter == null)
			return;

		(cast handle : MANode).attach_output_bus(0, meter, 0);

		for (effect in chainedEffects)
		{
			final node = effect.__nodes.get(parent);
			if (node != null)
				node.detach_all_output_buses();
		}

		chainedEffects = [];
	}

	/**
		Releases the sound of every source before the audio engine is recreated (on another
		device), returning what `resumeAll` needs to rebuild them.
	**/
	@:allow(lime.media.AudioManager)
	private static function suspendAll():Array<SuspendedSource>
	{
		final states:Array<SuspendedSource> = [];

		for (source in activeSources.copy())
		{
			if (source.handle == null)
				continue;

			states.push({
				source: source,
				time: source.getCurrentTime(),
				playing: source.handle.is_playing(),
				gain: source.getGain(),
				pitch: source.getPitch(),
				pan: source.getPan(),
				preRingBuffers: source.preRingBuffers.copy(),
				postRingBuffers: source.postRingBuffers.copy()
			});

			source.dispose();
		}

		return states;
	}

	/**
		Rebuilds the sources released by `suspendAll` on the current audio engine.
	**/
	@:allow(lime.media.AudioManager)
	private static function resumeAll(states:Array<SuspendedSource>):Void
	{
		for (state in states)
		{
			final source = state.source;
			source.preRingBuffers = state.preRingBuffers;
			source.postRingBuffers = state.postRingBuffers;
			source.init();

			if (source.handle == null)
				continue;

			source.setGain(state.gain);
			source.setPitch(state.pitch);
			source.setPan(state.pan);
			source.setCurrentTime(state.time);

			if (state.playing)
				source.play();
		}
	}

	// Event Handlers

	private static function pollAtEnd():Void
	{
		for (source in activeSources.copy())
		{
			if (source.handle == null)
				continue;

			if (source.handle.take_at_end() > 0)
			{
				source.sound_atEnd();
			}
			else if (source.parent.__length != null && source.handle.is_playing()
				&& source.getCurrentTime() >= source.parent.offset + source.parent.__length)
			{
				// an explicit length ends the sound early
				source.handle.stop();
				source.sound_atEnd();
			}
		}
	}

	private function sound_atEnd():Void
	{
		if (loops > 0)
		{
			loops--;
			stop();
			if (loopTime > 0)
				setCurrentTime(parent.offset + loopTime);
			play();
			return;
		}

		parent.onComplete.dispatch();
	}

	// Get & Set Methods
	public function getPeak(channel:Int):Float
	{
		return meter != null ? meter.get_peak(channel) : 0;
	}

	public function getLength():Float
	{
		return handle != null ? handle.get_length_in_seconds() * 1000.0 : 0;
	}

	public function getCurrentTime():Float
	{
		return handle != null ? cast handle.get_cursor_in_seconds() * 1000.0 : 0;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (handle != null)
		{
			handle.seek_to_second(value / 1000.0);
		}

		return value;
	}

	public function getGain():Float
	{
		return handle != null ? handle.get_volume() : 1;
	}

	public function setGain(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_volume(value);
		}

		return value;
	}

	public function getPitch():Float
	{
		return handle != null ? handle.get_pitch() : 1;
	}

	public function setPitch(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_pitch(value);
		}

		return value;
	}

	public function getPan():Float
	{
		return handle != null ? handle.get_pan() : 0;
	}

	public function setPan(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_pan(value);
		}

		return value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function getLoopTime():Float
	{
		return loopTime;
	}

	public function setLoopTime(value:Float):Float
	{
		return loopTime = value;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPlaying():Bool
	{
		return handle != null ? handle.is_playing() : false;
	}
}

private typedef SuspendedSource =
{
	source:NativeAudioSource,
	time:Float,
	playing:Bool,
	gain:Float,
	pitch:Float,
	pan:Float,
	preRingBuffers:Array<MAAudioRingBuffer>,
	postRingBuffers:Array<MAAudioRingBuffer>
}
