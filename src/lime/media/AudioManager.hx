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
		Shadow's miniaudio backend does not report device changes, so it is never dispatched.
	**/
	public static var onDefaultPlaybackDeviceChanged = new Event<String->Void>();

	/**
		Dispatched when a playback device is added (Codename Engine API). Never dispatched here.
	**/
	public static var onPlaybackDeviceAdded = new Event<String->Void>();

	/**
		Dispatched when a playback device is removed (Codename Engine API). Never dispatched here.
	**/
	public static var onPlaybackDeviceRemoved = new Event<String->Void>();

	/**
		Dispatched when the default capture device changes (Codename Engine API). Never dispatched here.
	**/
	public static var onDefaultCaptureDeviceChanged = new Event<String->Void>();

	/**
		Dispatched when a capture device is added (Codename Engine API). Never dispatched here.
	**/
	public static var onCaptureDeviceAdded = new Event<String->Void>();

	/**
		Dispatched when a capture device is removed (Codename Engine API). Never dispatched here.
	**/
	public static var onCaptureDeviceRemoved = new Event<String->Void>();

	/**
		Whether playback follows the system's default device (Codename Engine API).
		miniaudio already follows it where the platform allows.
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
		}
		#end
	}

	/**
		Reopens the audio device (Codename Engine API). Not supported by Shadow's miniaudio
		backend, which keeps its device; always returns false.
	**/
	public static function refresh(?deviceName:String):Bool
	{
		return false;
	}

	/**
		Name of the default capture device (Codename Engine API). Not available here: null.
	**/
	public static function getCaptureDefaultDeviceName():String
	{
		return null;
	}

	/**
		Names of the capture devices (Codename Engine API). Not available here: empty.
	**/
	public static function getCaptureDeviceNames():Array<String>
	{
		return [];
	}

	/**
		Name of the playback device in use (Codename Engine API). Not available here: null.
	**/
	public static function getCurrentPlaybackDeviceName():String
	{
		return null;
	}

	/**
		Name of the default playback device (Codename Engine API). Not available here: null.
	**/
	public static function getPlaybackDefaultDeviceName():String
	{
		return null;
	}

	/**
		Names of the playback devices (Codename Engine API). Not available here: empty.
	**/
	public static function getPlaybackDeviceNames():Array<String>
	{
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
