package lime.media;

import haxe.Int64;
import haxe.io.Bytes;

import lime.app.Future;
import lime.utils.ArrayBufferView;
import lime.utils.Log;
#if lime_miniaudio
import lime.media.miniaudio.MAAudioBuffer;
import lime.media.miniaudio.MAAudioRingBuffer;
import lime.media.miniaudio.MADataFormat;
import lime.media.miniaudio.MADecoder;
import lime.media.miniaudio.MADecoderConfig;
import lime.media.miniaudio.MAFormat;
import lime.system.ThreadPool;
import lime.system.WorkOutput;

#if cpp
import cpp.Pointer;

import lime.media.miniaudio.MAHelpers;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.utils.Int32Array;
import lime.utils.UInt8Array;
#end
#end

/**
	The `AudioBuffer` class represents a buffer of audio data that can be played back using an `AudioSource`.
	It supports a variety of audio formats and platforms, providing a consistent API for loading and managing audio data.

	Depending on the platform, the audio backend may differ, but the class provides a unified interface for accessing
	audio data, whether it's stored in memory, loaded from a file, or streamed.

	@see lime.media.AudioSource
**/
@:access(lime.utils.Assets)
class AudioBuffer
{
	/**
		The number of bits per sample in the audio data.
	**/
	#if lime_miniaudio
	public var bitsPerSample(get, never):Int;
	#else
	public var bitsPerSample:Int;
	#end

	/**
		The number of audio channels (e.g., 1 for mono, 2 for stereo).
	**/
	public var channels:Int;

	/**
		The sample rate of the audio data, in Hz.
	**/
	public var sampleRate:Int;

	#if lime_miniaudio
	/**
		The format of the audio data.
	**/
	public var format:MAFormat;
	#end

	/**
		The number of audio frames.
	**/
	public var frames:Int64;

	/**
		The raw audio data stored as a `ArrayBufferView`.
	**/
	public var data:ArrayBufferView;

	#if lime_miniaudio
	@:noCompletion private static var __localThreadPool:ThreadPool;

	@:noCompletion private var __srcMADecoder:MADecoder;
	@:noCompletion private var __srcMAAudioBuffer:MAAudioBuffer;
	@:noCompletion private var __srcMAAudioRingBuffer:MAAudioRingBuffer;
	#end

	@:noCompletion private var __srcCustom:Dynamic;

	/**
		Creates a new, empty `AudioBuffer` instance.
	**/
	public function new() {}

	/**
		Returns whether this `AudioBuffer` is valid or not.
	**/
	public function isValid():Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final validMADataSource:Bool = __srcMADecoder != null || __srcMAAudioBuffer != null || __srcMAAudioRingBuffer != null;

		final validData:Bool = data != null && data.length > 0;

		return validMADataSource || validData;
		#else
		return __srcCustom != null;
		#end
	}

	/**
		Disposes of the resources used by this `AudioBuffer`, such as unloading any associated audio data.
	**/
	public function dispose():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		if (__srcMADecoder != null)
		{
			__srcMADecoder.uninit();
			__srcMADecoder = null;
		}
		else if (__srcMAAudioBuffer != null)
		{
			__srcMAAudioBuffer.uninit();
			__srcMAAudioBuffer = null;
		}
		else if (__srcMAAudioRingBuffer != null)
		{
			__srcMAAudioRingBuffer.uninit();
			__srcMAAudioRingBuffer = null;
		}
		else if (data != null && data.length > 0)
		{
			data.buffer = null;
			data = null;
		}
		#end
	}

	/**
		Creates an `AudioBuffer` from a `Bytes` object.

		@param bytes The `Bytes` object containing the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	public static function fromBytes(bytes:Bytes, ?stream:Bool = false):AudioBuffer
	{
		if (bytes == null)
		{
			return null;
		}

		#if (lime_cffi && lime_miniaudio && !macro)
		return __createFromMADecoder(MADecoder.init_memory(bytes, MADecoderConfig.init(F32, 0, 0)), stream);
		#else
		return null;
		#end
	}

	/**
		Creates an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return An `AudioBuffer` instance with the audio data loaded from the file.
	**/
	public static function fromFile(path:String, ?stream:Bool = false):AudioBuffer
	{
		if (path == null)
		{
			return null;
		}

		#if (lime_cffi && lime_miniaudio && !macro)
		return __createFromMADecoder(MADecoder.init_file(path, MADecoderConfig.init(F32, 0, 0)), stream);
		#else
		return null;
		#end
	}

	/**
		Asynchronously loads an `AudioBuffer` from a `Bytes` object.

		@param bytes The `Bytes` object containing the audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromBytes(bytes:Bytes):Future<AudioBuffer>
	{
		if (bytes == null)
		{
			return Future.withValue(null);
		}

		#if (lime_cffi && lime_miniaudio && !macro)
		if (__localThreadPool == null)
		{
			__localThreadPool = new ThreadPool(0, 2);
			__localThreadPool.onComplete.add(localThreadPool_onComplete);
			__localThreadPool.onError.add(localThreadPool_onError);
		}

		var promise = new lime.app.Promise<AudioBuffer>();

		__localThreadPool.run(localThreadPool_doWork, {promise: promise, bytes: bytes});

		return promise.future;
		#else
		return Future.withValue(null);
		#end
	}

	/**
		Asynchronously loads an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromFile(path:String):Future<AudioBuffer>
	{
		if (path == null)
		{
			return Future.withValue(null);
		}

		#if (lime_cffi && lime_miniaudio && !macro)
		if (__localThreadPool == null)
		{
			__localThreadPool = new ThreadPool(0, 2);
			__localThreadPool.onComplete.add(localThreadPool_onComplete);
			__localThreadPool.onError.add(localThreadPool_onError);
		}

		var promise = new lime.app.Promise<AudioBuffer>();

		__localThreadPool.run(localThreadPool_doWork, {promise: promise, path: path});

		return promise.future;
		#else
		return Future.withValue(null);
		#end
	}

	/**
		Decodes a streamed buffer fully into `data` (Codename Engine API). Does nothing for
		buffers that are already decoded. Call it before an `AudioSource` plays the buffer:
		the stream's decoder is released.
	**/
	public function load():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro && cpp)
		if (__srcMADecoder == null || (data != null && data.length > 0))
			return;

		final decoder = __srcMADecoder;
		decoder.seek_to_pcm_frame(0);

		// releases the decoder whether it succeeds or not
		final loaded = __createFromMADecoder(decoder, false);
		__srcMADecoder = null;

		if (loaded != null)
		{
			frames = loaded.frames;
			sampleRate = loaded.sampleRate;
			channels = loaded.channels;
			format = loaded.format;
			data = loaded.data;
		}
		#end
	}

	/**
		Same as `load()`, on a background thread (Codename Engine API).

		@param onLoad Called with this buffer once it is decoded.
		@param onError Called if decoding fails.
	**/
	public function loadAsync(?onLoad:AudioBuffer->Void, ?onError:String->Void):Void
	{
		final future = new Future<AudioBuffer>(function()
		{
			load();
			return this;
		}, true);

		future.onComplete(function(buffer)
		{
			if (onError != null && !buffer.isValid())
				onError("Cannot decode audio buffer");
			else if (onLoad != null)
				onLoad(buffer);
		});

		future.onError(function(error)
		{
			if (onError != null)
				onError(Std.string(error));
		});
	}

	/**
		Creates an `AudioBuffer` from Base64-encoded audio data, with or without a
		`data:<type>;base64,` prefix (Codename Engine API).

		@param base64String The Base64-encoded audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
	**/
	public static function fromBase64(base64String:String, ?stream:Bool = false):AudioBuffer
	{
		if (base64String == null)
			return null;

		final comma = base64String.indexOf(",");
		if (comma > -1)
			base64String = base64String.substring(comma + 1);

		var bytes:Bytes = null;
		try
		{
			bytes = haxe.crypto.Base64.decode(base64String);
		}
		catch (e:Dynamic)
		{
			Log.error("Invalid Base64 audio data");
			return null;
		}

		return fromBytes(bytes, stream);
	}

	/**
		Same as `fromBytes(bytes, true)` (Codename Engine API).
	**/
	public static inline function fromBytesStream(bytes:Bytes):AudioBuffer
	{
		return fromBytes(bytes, true);
	}

	/**
		Same as `fromFile(path, true)` (Codename Engine API).
	**/
	public static inline function fromFileStream(path:String):AudioBuffer
	{
		return fromFile(path, true);
	}

	/**
		Creates an `AudioBuffer` from the first of `paths` that loads (Codename Engine API).

		@param paths The file paths to try, in order.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
	**/
	public static function fromFiles(paths:Array<String>, ?stream:Bool = false):AudioBuffer
	{
		if (paths == null)
			return null;

		for (path in paths)
		{
			final buffer = fromFile(path, stream);
			if (buffer != null)
				return buffer;
		}

		return null;
	}

	/**
		Same as `fromFiles(paths, true)` (Codename Engine API).
	**/
	public static inline function fromFilesStream(paths:Array<String>):AudioBuffer
	{
		return fromFiles(paths, true);
	}

	/**
		Asynchronously loads an `AudioBuffer` from the first of `paths` that loads (Codename Engine API).

		@param paths The file paths to try, in order.
		@return A `Future` that resolves to the loaded `AudioBuffer`, or null if none loaded.
	**/
	public static function loadFromFiles(paths:Array<String>):Future<AudioBuffer>
	{
		if (paths == null || paths.length == 0)
			return Future.withValue(null);

		final promise = new lime.app.Promise<AudioBuffer>();
		var index = 0;

		function next():Void
		{
			if (index >= paths.length)
			{
				promise.complete(null);
				return;
			}

			final future = loadFromFile(paths[index++]);
			future.onComplete(function(buffer)
			{
				if (buffer != null)
					promise.complete(buffer);
				else
					next();
			});
			future.onError(function(_) next());
		}

		next();
		return promise.future;
	}

	@:noCompletion private static function __getCodec(bytes:Bytes):String
	{
		var signature:String = null;

		try
		{
			signature = bytes.getString(0, 4);
		}
		catch (e:Dynamic)
		{
			// if the bytes don't represent a valid UTF-8 string, getString()
			// may throw an exception. in that case, we expect to end up in
			// the default switch case below where it tries to detect MP3.
		}

		switch (signature)
		{
			case "OggS":
				try
				{
					if (bytes.length >= 36 && bytes.getString(28, 8) == "OpusHead")
					{
						return "audio/opus";
					}
				}
				catch (e:Dynamic) {}

				return "audio/ogg";
			case "fLaC":
				return "audio/flac";
			case "RIFF" if (bytes.getString(8, 4) == "WAVE"):
				return "audio/wav";
			default:
				switch ([bytes.get(0), bytes.get(1), bytes.get(2)])
				{
					case [73, 68, 51] | [255, 251, _] | [255, 250, _] | [255, 243, _]: return "audio/mp3";
					default:
				}
		}

		Log.error("Unsupported sound format");

		return null;
	}

	#if (lime_cffi && lime_miniaudio && !macro)
	@:noCompletion private static function __createFromMADecoder(decoder:MADecoder, ?stream:Bool = false):AudioBuffer
	{
		if (decoder != null)
		{
			var frames:Int64 = decoder.get_length_in_pcm_frames();

			if (frames > 0)
			{
				var dataFormat:MADataFormat = decoder.get_data_format();

				if (stream)
				{
					var buffer:AudioBuffer = new AudioBuffer();
					buffer.frames = frames;
					buffer.sampleRate = dataFormat.sampleRate;
					buffer.channels = dataFormat.channels;
					buffer.format = dataFormat.format;
					buffer.__srcMADecoder = decoder;
					return buffer;
				}
				else
				{
					#if cpp
					// When we are not streaming and we are required to put these frames inside an buffer,
					// We cant use Int64 as the buffer's length as per Haxe's limitation,
					// And even if youd wanna go beyound the limit, at that point youd use streaming which doesnt have this issue anyway.
					var totalFrames:Int = Int64.toInt(frames);

					var bytesPerSample:Int = MAHelpers.get_bytes_per_sample(dataFormat.format);

					var dataBuffer:ArrayBufferView = null;

					switch (dataFormat.format)
					{
						case U8:
							dataBuffer = new UInt8Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case S16:
							dataBuffer = new Int16Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case S32:
							dataBuffer = new Int32Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case F32:
							dataBuffer = new Float32Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						default:
							Log.error('Unsupported audio buffer format: ${MAHelpers.get_format_name(dataFormat.format)}');
					}

					if (dataBuffer != null && decoder.read_pcm_frames(Pointer.ofArray(dataBuffer.buffer.getData()), totalFrames) > 0)
					{
						decoder.uninit();
						decoder = null;

						var buffer:AudioBuffer = new AudioBuffer();
						buffer.frames = frames;
						buffer.sampleRate = dataFormat.sampleRate;
						buffer.channels = dataFormat.channels;
						buffer.format = dataFormat.format;
						buffer.data = dataBuffer;
						return buffer;
					}
					#end
				}
			}

			decoder.uninit();
			decoder = null;
		}

		return null;
	}

	@:noCompletion private static function localThreadPool_doWork(state:Dynamic, output:WorkOutput):Void
	{
		var decoder:MADecoder = null;

		if (state.path != null)
		{
			decoder = MADecoder.init_file(state.path, MADecoderConfig.init(F32, 0, 0));
		}
		else if (state.bytes != null)
		{
			decoder = MADecoder.init_memory(state.bytes, MADecoderConfig.init(F32, 0, 0));
		}

		if (decoder != null)
		{
			var audioBuffer:AudioBuffer = __createFromMADecoder(decoder);

			if (audioBuffer != null)
			{
				output.sendComplete({
					state: state,
					audioBuffer: audioBuffer
				});

				return;
			}
		}

		output.sendError({
			state: state,
			message: "Cannot load file: " + state.path
		});
	}

	@:noCompletion private static function localThreadPool_onComplete(data:Dynamic):Void
	{
		data.state.promise.complete(data.audioBuffer);
	}

	@:noCompletion private static function localThreadPool_onError(data:Dynamic):Void
	{
		data.state.promise.error(data.message);
	}
	#end

	// Get & Set Methods
	#if lime_miniaudio
	@:noCompletion private function get_bitsPerSample():Int
	{
		return switch (format)
		{
			case U8: 8;
			case S16: 16;
			case S24: 24;
			case S32: 32;
			case F32: 32;
			default: 0;
		}
	}
	#end
}
