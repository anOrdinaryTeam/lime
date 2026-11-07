package lime.media;

import lime.app.Event;
import lime.system.System;
import lime.utils.Log;
#if lime_miniaudio
import lime.media.miniaudio.MAEngine;
import lime.media.miniaudio.MAEngineConfig;
#if lime_miniaudio_debug_output
import lime.media.miniaudio.MAHelpers;
import lime.media.miniaudio.MALog;
import lime.media.miniaudio.MALogLevel;
#end
#end

@:allow(lime._internal.backend.native.NativeApplication)
class AudioManager
{
	#if (lime_miniaudio && lime_miniaudio_debug_output)
	@:noCompletion
	private static function onLog(level:MALogLevel, pMessage:String):Void
	{
		Log.println('${MAHelpers.log_level_to_string(level)}: ${pMessage}');
	}
	#end

	@:noCompletion
	private static var resumeOnFocus:Bool = false;

	@:noCompletion
	private static var active:Bool = true;

	#if lime_miniaudio
	#if lime_miniaudio_debug_output
	public static var log:MALog;
	#end
	public static var engine:MAEngine;
	#end

	/**
		Dispatched when the default playback device changes, with its name (Codename Engine API).
		While on the default device, playback follows it by itself.
	**/
	public static var onDefaultPlaybackDeviceChanged = new Event<String->Void>();

	/**
		Dispatched when a playback device is added, with its name (Codename Engine API). Devices are
		checked every 2 seconds, only while something listens.
	**/
	public static var onPlaybackDeviceAdded = new Event<String->Void>();

	/**
		Dispatched when a playback device is removed, with its name (Codename Engine API). Devices are
		checked every 2 seconds, only while something listens.
	**/
	public static var onPlaybackDeviceRemoved = new Event<String->Void>();

	/**
		Dispatched when the default capture device changes, with its name (Codename Engine API).
		Checked every 2 seconds, only while something listens.
	**/
	public static var onDefaultCaptureDeviceChanged = new Event<String->Void>();

	/**
		Dispatched when a capture device is added, with its name (Codename Engine API). Devices are
		checked every 2 seconds, only while something listens.
	**/
	public static var onCaptureDeviceAdded = new Event<String->Void>();

	/**
		Dispatched when a capture device is removed, with its name (Codename Engine API). Devices are
		checked every 2 seconds, only while something listens.
	**/
	public static var onCaptureDeviceRemoved = new Event<String->Void>();

	/**
		Whether playback follows the system's default device (Codename Engine API). On the
		default device miniaudio follows it by itself; when a device chosen with `refresh`
		is removed, playback goes back to the default device if this is true.
	**/
	public static var automaticDefaultPlaybackDevice:Bool = true;

	/**
		Mutes all playback (Codename Engine API).
	**/
	public static var muted(get, set):Bool;

	/**
		Linear master gain (volume) of all playback, 1 by default (Codename Engine API).
	**/
	public static var gain(get, set):Float;

	@:noCompletion private static var __muted:Bool = false;
	@:noCompletion private static var __gain:Float = 1;
	@:noCompletion private static var __playbackDeviceName:String = null;
	@:noCompletion private static var __devicePoller:haxe.MainLoop.MainEvent;
	@:noCompletion private static var __nextDeviceScan:Float = 0;
	@:noCompletion private static var __playbackDevices:Array<String>;
	@:noCompletion private static var __captureDevices:Array<String>;
	@:noCompletion private static var __defaultCaptureDevice:String;

	public static function init():Void
	{
		#if lime_miniaudio
		if (engine == null)
		{
			#if lime_miniaudio_debug_output
			if (log == null)
			{
				log = MALog.init();

				if (log != null)
				{
					log.register_callback(onLog);
				}
				else
				{
					Log.error("Unable to create MiniAudio engine log config for Native!");
				}
			}
			#end

			final config:MAEngineConfig = MAEngineConfig.init();
			config.playbackDeviceName = __playbackDeviceName;

			#if lime_miniaudio_debug_output
			config.pLog = log;
			#end

			#if ios
			// Since we are doing our own modification to the `AVAudioSession` shared instance,
			// we should automatically start the `ma_engine` instance, only after it's initialized,
			// so the options take proper effect.
			config.noAutoStart = true;
			#end

			engine = MAEngine.init(config);

			if (engine == null)
			{
				Log.error("Unable to create MiniAudio engine for Native!");
				return;
			}

			#if ios
			// Now we are starting the engine as usual after the `AVAudioSession` options have been set.
			engine.start();
			#end

			if (__muted || __gain != 1)
				__applyVolume();

			if (__devicePoller == null)
				__devicePoller = haxe.MainLoop.add(__pollDevices);
		}
		#end
	}

	/**
		Reopens audio output on `deviceName`, or on the default device when it is null
		(Codename Engine API). Every playing sound moves to it, keeping its position.

		@return Whether output is now on the requested device.
	**/
	public static function refresh(?deviceName:String):Bool
	{
		#if lime_miniaudio
		if (engine == null)
			return false;

		final sources = lime._internal.backend.native.NativeAudioSource.suspendAll();

		engine.stop();
		engine.uninit();
		engine = null;

		__playbackDeviceName = deviceName;
		init();

		if (engine == null && deviceName != null)
		{
			// the device could not be opened: fall back to the default one
			__playbackDeviceName = null;
			init();
		}

		if (engine != null && !active)
			engine.stop();

		lime._internal.backend.native.NativeAudioSource.resumeAll(sources);

		return engine != null && (deviceName == null || __playbackDeviceName == deviceName && getCurrentPlaybackDeviceName() == deviceName);
		#else
		return false;
		#end
	}

	/**
		Name of the default capture device, or null if unknown (Codename Engine API).
	**/
	public static function getCaptureDefaultDeviceName():String
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_default_device_name(true);
		#end

		return null;
	}

	/**
		Names of the capture devices (Codename Engine API).
	**/
	public static function getCaptureDeviceNames():Array<String>
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_device_names(true);
		#end

		return [];
	}

	/**
		Name of the playback device in use, or null if unknown (Codename Engine API).
	**/
	public static function getCurrentPlaybackDeviceName():String
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_device_name();
		#end

		return null;
	}

	/**
		Name of the default playback device, or null if unknown (Codename Engine API).
	**/
	public static function getPlaybackDefaultDeviceName():String
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_default_device_name(false);
		#end

		return null;
	}

	/**
		Names of the playback devices (Codename Engine API).
	**/
	public static function getPlaybackDeviceNames():Array<String>
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_device_names(false);
		#end

		return [];
	}

	/**
		The audio engine's clock in milliseconds, or the system timer without one (Codename Engine API).
	**/
	public static function getTimer():Float
	{
		#if lime_miniaudio
		if (engine != null)
		{
			final time = engine.get_time_in_milliseconds();
			final low:Float = time.low < 0 ? time.low + 4294967296.0 : time.low;
			return time.high * 4294967296.0 + low;
		}
		#end

		return System.getTimer();
	}

	/**
		Output latency of the audio device in milliseconds (Codename Engine API).
	**/
	public static function getLatency():Float
	{
		#if lime_miniaudio
		if (engine != null)
			return engine.get_latency();
		#end

		return 0;
	}

	public static function shutdown():Void
	{
		#if lime_miniaudio
		if (__devicePoller != null)
		{
			__devicePoller.stop();
			__devicePoller = null;
		}

		if (engine != null)
		{
			engine.stop();
			engine.uninit();
			engine = null;
		}

		#if lime_miniaudio_debug_output
		if (log != null)
		{
			log.uninit();
			log = null;
		}
		#end
		#end
	}

	public static function resume():Void
	{
		if (active)
			return;

		#if lime_miniaudio
		engine.start();
		#end

		active = true;
	}

	public static function suspend():Void
	{
		if (!active)
			return;

		#if lime_miniaudio
		engine.stop();
		#end

		active = false;
	}

	@:noCompletion private static function __pollDevices():Void
	{
		#if lime_miniaudio
		if (engine == null)
			return;

		if (engine.take_rerouted() > 0)
			onDefaultPlaybackDeviceChanged.dispatch(getPlaybackDefaultDeviceName());

		final watchPlayback = __hasListeners(onPlaybackDeviceAdded) || __hasListeners(onPlaybackDeviceRemoved)
			|| (__playbackDeviceName != null && automaticDefaultPlaybackDevice);
		final watchCapture = __hasListeners(onCaptureDeviceAdded) || __hasListeners(onCaptureDeviceRemoved)
			|| __hasListeners(onDefaultCaptureDeviceChanged);

		if (!watchPlayback && !watchCapture)
		{
			__playbackDevices = __captureDevices = null;
			__defaultCaptureDevice = null;
			return;
		}

		// enumerating devices is slow, so only every 2 seconds
		final now = System.getTimer();
		if (now < __nextDeviceScan)
			return;
		__nextDeviceScan = now + 2000;

		if (watchPlayback)
		{
			final devices = getPlaybackDeviceNames();

			if (__playbackDevices != null)
			{
				for (name in devices)
					if (!__playbackDevices.contains(name))
						onPlaybackDeviceAdded.dispatch(name);

				for (name in __playbackDevices)
					if (!devices.contains(name))
						onPlaybackDeviceRemoved.dispatch(name);
			}

			__playbackDevices = devices;

			// a chosen device went away: go back to the default device
			if (__playbackDeviceName != null && automaticDefaultPlaybackDevice && !devices.contains(__playbackDeviceName))
			{
				refresh(null);
				onDefaultPlaybackDeviceChanged.dispatch(getPlaybackDefaultDeviceName());
				return;
			}
		}

		if (watchCapture)
		{
			final devices = getCaptureDeviceNames();

			if (__captureDevices != null)
			{
				for (name in devices)
					if (!__captureDevices.contains(name))
						onCaptureDeviceAdded.dispatch(name);

				for (name in __captureDevices)
					if (!devices.contains(name))
						onCaptureDeviceRemoved.dispatch(name);
			}

			__captureDevices = devices;

			final defaultCapture = getCaptureDefaultDeviceName();
			if (__defaultCaptureDevice != null && defaultCapture != __defaultCaptureDevice)
				onDefaultCaptureDeviceChanged.dispatch(defaultCapture);
			__defaultCaptureDevice = defaultCapture;
		}
		#end
	}

	@:noCompletion private static inline function __hasListeners(event:Event<String->Void>):Bool
	{
		return event.__listeners.length > 0;
	}

	@:noCompletion private static function __applyVolume():Void
	{
		#if lime_miniaudio
		if (engine != null)
			engine.set_volume(__muted ? 0 : __gain);
		#end
	}

	@:noCompletion private static inline function get_muted():Bool
	{
		return __muted;
	}

	@:noCompletion private static function set_muted(value:Bool):Bool
	{
		__muted = value;
		__applyVolume();
		return value;
	}

	@:noCompletion private static inline function get_gain():Float
	{
		return __gain;
	}

	@:noCompletion private static function set_gain(value:Float):Float
	{
		__gain = value;
		__applyVolume();
		return value;
	}

	@:noCompletion
	private static function onActivate():Void
	{
		if (resumeOnFocus)
		{
			resumeOnFocus = false;

			AudioManager.resume();
		}
	}

	@:noCompletion
	private static function onDeactivate():Void
	{
		resumeOnFocus = resumeOnFocus || AudioManager.active;

		AudioManager.suspend();
	}
}
