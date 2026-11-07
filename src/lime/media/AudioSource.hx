package lime.media;

#if lime_miniaudio
import lime.media.miniaudio.MAAudioRingBuffer;
#end
import lime.app.Event;
import lime.math.Vector4;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;

/**
	The `AudioSource` class provides a way to control audio playback in a Lime application.
	It allows for playing, pausing, and stopping audio, as well as controlling various
	audio properties such as gain, pitch, and looping.

	Depending on the platform, the audio backend may vary, but the API remains consistent.

	@see lime.media.AudioBuffer
**/
class AudioSource
{
	/**
		An event that is dispatched when the audio playback is complete.
	**/
	public var onComplete = new Event<Void->Void>();

	/**
		The `AudioBuffer` associated with this `AudioSource`.
	**/
	public var buffer:AudioBuffer;

	/**
		The length of the audio, in milliseconds.
	**/
	public var length(get, set):Float;

	/**
		The current playback position of the audio, in milliseconds.
	**/
	public var currentTime(get, set):Float;

	/**
		The gain (volume) of the audio. A value of `1` represents the default volume.
	**/
	public var gain(get, set):Float;

	/**
		The pitch of the audio. A value of `1` represents the default pitch.
	**/
	public var pitch(get, set):Float;

	/**
		The pan of the audio. A value of `0` represents the default pan.
	**/
	public var pan(get, set):Float;

	/**
		The number of times the audio will loop. A value of `0` means the audio will not loop.
	**/
	public var loops(get, set):Int;

	/**
		Whether the audio source is currently playing or not.
	**/
	public var playing(get, never):Bool;

	/**
		Point (in milliseconds, after `offset`) where looping restarts (Codename Engine API).
	**/
	public var loopTime(get, set):Float;

	/**
		Start of the audio inside its buffer, in milliseconds. `currentTime` and `length`
		are relative to it (Codename Engine API).
	**/
	public var offset(default, set):Float = 0;

	/**
		Output latency of the audio device in milliseconds (Codename Engine API).
	**/
	public var latency(get, never):Float;

	/**
		Current peak of each output channel (Codename Engine API).
	**/
	public var peaks(get, never):Array<Float>;

	/**
		Position of the source (Codename Engine API). Stored only: Shadow's sources are not
		spatialized.
	**/
	public var position(get, set):Vector4;

	@:noCompletion private var __backend:AudioSourceBackend;
	@:noCompletion private var __effects:Array<AudioEffect> = [];
	@:noCompletion private var __length:Null<Float> = null;
	@:noCompletion private var __position:Vector4;
	@:noCompletion private var __peaks:Array<Float> = [0, 0];

	/**
		Creates a new `AudioSource` instance.

		@param buffer The `AudioBuffer` to associate with this `AudioSource`.
	**/
	public function new(buffer:AudioBuffer = null, offset:Float = 0, ?length:Null<Int>, loops:Int = 0)
	{
		__backend = new AudioSourceBackend(this);

		this.buffer = buffer;
		this.offset = offset;
		if (length != null && length != 0)
			__length = length;

		if (buffer != null && buffer.isValid())
		{
			__backend.init();
		}

		if (loops != 0)
			this.loops = loops;
	}

	/**
		Adds an effect at the end of this source's effect chain (Codename Engine API).
		@return Whether it was added (false if it already was).
	**/
	public function addEffect(effect:AudioEffect):Bool
	{
		if (effect == null || __effects.contains(effect))
			return false;

		__effects.push(effect);
		if (effect.__appliedSources != null && !effect.__appliedSources.contains(this))
			effect.__appliedSources.push(this);

		__backend.updateEffects();
		return true;
	}

	/**
		Removes an effect from this source (Codename Engine API).
	**/
	public function removeEffect(effect:AudioEffect):Void
	{
		if (effect == null || !__effects.remove(effect))
			return;

		__backend.updateEffects();

		if (effect.__appliedSources != null)
		{
			effect.__appliedSources.remove(this);
			if (effect.autoDispose && effect.__appliedSources.length == 0)
				effect.dispose();
		}
	}

	/**
		Removes every effect from this source (Codename Engine API).
	**/
	public function clearEffects():Void
	{
		for (effect in __effects.copy())
			removeEffect(effect);
	}

	/**
		Effect at `index` in this source's chain, or null (Codename Engine API).
	**/
	public function getEffectAt(index:Int):AudioEffect
	{
		return index >= 0 && index < __effects.length ? __effects[index] : null;
	}

	/**
		Index of `effect` in this source's chain, or -1 (Codename Engine API).
	**/
	public function getEffectIndex(effect:AudioEffect):Int
	{
		return __effects.indexOf(effect);
	}

	/**
		Writes `size` samples from the current play position into `array` (from `offset`),
		between -1 and 1. `channel` -1 averages every channel (Codename Engine API).
		Reads decoded buffers; streamed buffers return 0 samples.
		@return The number of samples written.
	**/
	public function getFloatTimeDomainData(array:Float32Array, size:Int, channel:Int = -1, offset:Int = 0):Int
	{
		final count = __readTimeDomainData(size, channel);
		for (i in 0...count)
			array[offset + i] = __timeDomainScratch[i];
		return count;
	}

	/**
		Same as `getFloatTimeDomainData`, as bytes centered on 128 (Codename Engine API).
	**/
	public function getByteTimeDomainData(array:UInt8Array, size:Int, channel:Int = -1, offset:Int = 0):Int
	{
		final count = __readTimeDomainData(size, channel);
		for (i in 0...count)
		{
			var value = Std.int((__timeDomainScratch[i] + 1) * 128);
			array[offset + i] = value < 0 ? 0 : (value > 255 ? 255 : value);
		}
		return count;
	}

	/**
		Recreates the playback resources from `buffer`, like after an `unload()` (Codename Engine API).
	**/
	public function load():Void
	{
		__backend.stop();
		__backend.dispose();
		if (buffer != null)
			__backend.init();
	}

	/**
		Releases the playback resources, keeping the buffer so `load()` can recreate them
		(Codename Engine API).
	**/
	public function unload():Void
	{
		__backend.stop();
		__backend.dispose();
	}

	/**
		Seeks to `time` and leaves the source paused, ready to play (Codename Engine API).
	**/
	public function prepare(time:Float):Void
	{
		if (buffer != null)
			init();
		__backend.pause();
		currentTime = time;
	}

	/**
		Pauses every given source (Codename Engine API).
	**/
	public static function pauseSources(sources:Array<AudioSource>):Void
	{
		for (source in sources)
			if (source != null)
				source.pause();
	}

	/**
		Plays every given source back to back (Codename Engine API).
	**/
	public static function playSources(sources:Array<AudioSource>):Void
	{
		for (source in sources)
			if (source != null)
				source.play();
	}

	/**
		Stops every given source (Codename Engine API).
	**/
	public static function stopSources(sources:Array<AudioSource>):Void
	{
		for (source in sources)
			if (source != null)
				source.stop();
	}

	/**
		Releases any resources used by this `AudioSource`.
	**/
	public function dispose():Void
	{
		__backend.dispose();
	}

	/**
		Initializes the resources used by this `AudioSource`.
	**/
	public function init():Void
	{
		__backend.init();
	}

	/**
		Starts or resumes audio playback.
	**/
	public function play():Void
	{
		__backend.play();
	}

	/**
		Pauses audio playback.
	**/
	public function pause():Void
	{
		__backend.pause();
	}

	/**
		Stops audio playback and resets the playback position to the beginning.
	**/
	public function stop():Void
	{
		__backend.stop();
	}

	/**
		Returns the current peak level (0 to 1 for unclipped audio) this source outputs on `channel`,
		after its gain, pan and pitch. It covers the last block the audio device mixed, about 10ms.

		@param channel The channel to measure, 0 for left and 1 for right. Mono output returns the same value for both.
	**/
	public function getPeak(channel:Int):Float
	{
		return __backend.getPeak(channel);
	}

	#if lime_miniaudio
	public function addPreRingBuffer(rb:MAAudioRingBuffer):Void
	{
		__backend.addPreRingBuffer(rb);
	}

	public function removePreRingBuffer(rb:MAAudioRingBuffer):Void
	{
		__backend.removePreRingBuffer(rb);
	}

	public function addPostRingBuffer(rb:MAAudioRingBuffer):Void
	{
		__backend.addPostRingBuffer(rb);
	}

	public function removePostRingBuffer(rb:MAAudioRingBuffer):Void
	{
		__backend.removePostRingBuffer(rb);
	}
	#end

	// Get & Set Methods
	@:noCompletion private function get_length():Float
	{
		if (__length != null)
			return __length;
		return __backend.getLength() - offset;
	}

	@:noCompletion private function set_length(value:Float):Float
	{
		__length = value;
		return value;
	}

	@:noCompletion private function get_currentTime():Float
	{
		return __backend.getCurrentTime() - offset;
	}

	@:noCompletion private function set_currentTime(value:Float):Float
	{
		__backend.setCurrentTime(value + offset);
		return value;
	}

	@:noCompletion private function set_offset(value:Float):Float
	{
		if (value < 0)
			value = 0;

		if (offset != value)
		{
			// keep the position relative to the new start
			final relative = __backend.getCurrentTime() - offset;
			offset = value;
			__backend.setCurrentTime(relative + value);
		}

		return value;
	}

	@:noCompletion private function get_loopTime():Float
	{
		return __backend.getLoopTime();
	}

	@:noCompletion private function set_loopTime(value:Float):Float
	{
		return __backend.setLoopTime(value);
	}

	@:noCompletion private function get_latency():Float
	{
		#if lime_miniaudio
		return AudioManager.engine != null ? AudioManager.engine.get_latency() : 0;
		#else
		return 0;
		#end
	}

	@:noCompletion private function get_peaks():Array<Float>
	{
		__peaks[0] = getPeak(0);
		__peaks[1] = getPeak(1);
		return __peaks;
	}

	@:noCompletion private function get_position():Vector4
	{
		if (__position == null)
			__position = new Vector4();
		return __position;
	}

	@:noCompletion private function set_position(value:Vector4):Vector4
	{
		return __position = value;
	}

	@:noCompletion private var __timeDomainScratch:Array<Float> = [];

	/**
		Reads up to `size` samples at the play position from a decoded buffer into the scratch array.
	**/
	@:noCompletion private function __readTimeDomainData(size:Int, channel:Int):Int
	{
		if (buffer == null || buffer.data == null || size <= 0 || buffer.channels <= 0 || buffer.sampleRate <= 0)
			return 0;

		final channels = buffer.channels;
		#if lime_miniaudio
		final bytesPerSample = switch (buffer.format)
		{
			case U8: 1;
			case S16: 2;
			case S24: 3;
			default: 4;
		}
		#else
		final bytesPerSample = 4;
		#end

		final data:ArrayBufferView = buffer.data;
		final totalFrames = Std.int(data.byteLength / (bytesPerSample * channels));
		var frame = Std.int((__backend.getCurrentTime() / 1000) * buffer.sampleRate);
		if (frame < 0)
			frame = 0;

		var count = 0;
		while (count < size && frame < totalFrames)
		{
			var sum = 0.0;
			var used = 0;
			for (c in 0...channels)
			{
				if (channel >= 0 && c != channel)
					continue;
				sum += __readSample(data, (frame * channels + c) * bytesPerSample, bytesPerSample);
				used++;
			}
			__timeDomainScratch[count++] = used > 0 ? sum / used : 0;
			frame++;
		}
		return count;
	}

	@:noCompletion private function __readSample(data:ArrayBufferView, byteOffset:Int, bytesPerSample:Int):Float
	{
		final bytes = data.buffer;
		final at = data.byteOffset + byteOffset;
		return switch (bytesPerSample)
		{
			case 1: (bytes.get(at) - 128) / 128;
			case 2: lime.utils.ArrayBufferView.ArrayBufferIO.getInt16(bytes, at) / 32768;
			case 3: ((bytes.get(at) | (bytes.get(at + 1) << 8) | (bytes.get(at + 2) << 16)) << 8 >> 8) / 8388608;
			default:
				#if lime_miniaudio
				buffer.format == lime.media.miniaudio.MAFormat.S32 ? lime.utils.ArrayBufferView.ArrayBufferIO.getInt32(bytes, at) / 2147483648 : lime.utils.ArrayBufferView.ArrayBufferIO.getFloat32(bytes, at);
				#else
				lime.utils.ArrayBufferView.ArrayBufferIO.getFloat32(bytes, at);
				#end
		}
	}

	@:noCompletion private function get_gain():Float
	{
		return __backend.getGain();
	}

	@:noCompletion private function set_gain(value:Float):Float
	{
		return __backend.setGain(value);
	}

	@:noCompletion private function get_pitch():Float
	{
		return __backend.getPitch();
	}

	@:noCompletion private function set_pitch(value:Float):Float
	{
		return __backend.setPitch(value);
	}

	@:noCompletion private function get_pan():Float
	{
		return __backend.getPan();
	}

	@:noCompletion private function set_pan(value:Float):Float
	{
		return __backend.setPan(value);
	}

	@:noCompletion private function get_loops():Int
	{
		return __backend.getLoops();
	}

	@:noCompletion private function set_loops(value:Int):Int
	{
		return __backend.setLoops(value);
	}

	@:noCompletion private function get_playing():Bool
	{
		return __backend.getPlaying();
	}
}

@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.native.NativeAudioSource;
