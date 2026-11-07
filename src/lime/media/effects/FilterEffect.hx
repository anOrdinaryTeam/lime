package lime.media.effects;

import lime.media.AudioEffect;
import lime.media.AudioManager;
#if lime_miniaudio
import lime.media.miniaudio.MANode;
import lime.media.miniaudio.nodes.MABpfNode;
import lime.media.miniaudio.nodes.MABpfNodeConfig;
import lime.media.miniaudio.nodes.MAHpfNode;
import lime.media.miniaudio.nodes.MAHpfNodeConfig;
import lime.media.miniaudio.nodes.MALpfNode;
import lime.media.miniaudio.nodes.MALpfNodeConfig;
#end

/**
	A low-pass, high-pass or band-pass filter (Codename Engine API), made of
	miniaudio's second order filter nodes.

	```haxe
	var muffle = new FilterEffect(LOWPASS, 800);
	source.addEffect(muffle);
	muffle.frequency = 400; // retunes every source using it
	```
**/
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FilterEffect extends AudioEffect
{
	/**
		The kind of filter. Changing it rebuilds the filter on every source.
	**/
	public var type(default, set):FilterEffectType;

	/**
		Cutoff (or center, for band-pass) frequency in Hz.
	**/
	public var frequency(default, set):Float;

	/**
		Filter order (steepness), 2 by default. Takes effect on new nodes and type changes.
	**/
	public var order:Int = 2;

	public function new(type:FilterEffectType = LOWPASS, frequency:Float = 1000)
	{
		super();
		this.type = type;
		this.frequency = frequency;
	}

	#if lime_miniaudio
	@:noCompletion private var __channels:Int = 2;
	@:noCompletion private var __sampleRate:Int = 48000;

	@:noCompletion private override function __createNode(channels:Int, sampleRate:Int):Null<MANode>
	{
		__channels = channels;
		__sampleRate = sampleRate;

		final graph = AudioManager.engine != null ? AudioManager.engine.get_node_graph() : null;
		if (graph == null)
			return null;

		return switch (type)
		{
			case HIGHPASS: MAHpfNode.init(graph, MAHpfNodeConfig.init(channels, sampleRate, __cutoff(), order));
			case BANDPASS: MABpfNode.init(graph, MABpfNodeConfig.init(channels, sampleRate, __cutoff(), order));
			default: MALpfNode.init(graph, MALpfNodeConfig.init(channels, sampleRate, __cutoff(), order));
		}
	}

	@:noCompletion private override function __destroyNode(node:MANode):Void
	{
		switch (type)
		{
			case HIGHPASS: (node : MAHpfNode).uninit();
			case BANDPASS: (node : MABpfNode).uninit();
			default: (node : MALpfNode).uninit();
		}
	}

	@:noCompletion private function __retune():Void
	{
		if (__nodes == null)
			return;

		for (node in __nodes)
		{
			switch (type)
			{
				case HIGHPASS: (node : MAHpfNode).reinit(MAHpfNodeConfig.init(__channels, __sampleRate, __cutoff(), order));
				case BANDPASS: (node : MABpfNode).reinit(MABpfNodeConfig.init(__channels, __sampleRate, __cutoff(), order));
				default: (node : MALpfNode).reinit(MALpfNodeConfig.init(__channels, __sampleRate, __cutoff(), order));
			}
		}
	}

	/**
		Cutoff kept inside what the sample rate can represent.
	**/
	@:noCompletion private inline function __cutoff():Float
	{
		final nyquist = __sampleRate * 0.5 - 1;
		return frequency < 1 ? 1 : (frequency > nyquist ? nyquist : frequency);
	}
	#end

	@:noCompletion private function set_type(value:FilterEffectType):FilterEffectType
	{
		if (type == value)
			return value;

		#if lime_miniaudio
		// nodes of the old type must be released with the old type
		if (__nodes != null && __appliedSources != null && __appliedSources.length > 0)
		{
			for (source in __appliedSources)
				@:privateAccess source.__backend.detachEffects();
			for (source in __appliedSources)
				__releaseNode(source);
			type = value;
			for (source in __appliedSources)
				@:privateAccess source.__backend.updateEffects();
			return value;
		}
		#end

		return type = value;
	}

	@:noCompletion private function set_frequency(value:Float):Float
	{
		frequency = value;
		#if lime_miniaudio
		__retune();
		#end
		return value;
	}
}

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FilterEffectType(String) from String to String
{
	var LOWPASS = "lowpass";
	var HIGHPASS = "highpass";
	var BANDPASS = "bandpass";
}
