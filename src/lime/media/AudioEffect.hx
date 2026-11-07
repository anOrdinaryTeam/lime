package lime.media;

#if lime_miniaudio
import lime.media.miniaudio.MANode;
#end

/**
	An audio effect that can be applied to one or more `AudioSource`s with
	`AudioSource.addEffect` (Codename Engine API).

	On Shadow's miniaudio backend every source that uses an effect gets its own
	node from it, inserted between the sound and its output.
**/
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.media.AudioSource)
class AudioEffect
{
	/**
		Disables this audio effect, without removing it from its sources.
	**/
	public var bypass(default, set):Bool = false;

	/**
		Whether this effect is disposed when it is removed from its last source.
	**/
	public var autoDispose:Bool = true;

	@:allow(lime.media.AudioSource)
	@:noCompletion private var __appliedSources:Array<AudioSource>;

	#if lime_miniaudio
	@:noCompletion private var __nodes:haxe.ds.ObjectMap<AudioSource, MANode>;
	#end

	public function new()
	{
		__appliedSources = [];
		#if lime_miniaudio
		__nodes = new haxe.ds.ObjectMap();
		#end
	}

	/**
		Removes this effect from every source and releases its resources.
	**/
	public function dispose():Void
	{
		if (__appliedSources == null)
			return;

		final autoDispose = this.autoDispose;
		this.autoDispose = false; // removeEffect would dispose again
		for (source in __appliedSources.copy())
			if (source != null)
				source.removeEffect(this);
		this.autoDispose = autoDispose;

		__appliedSources = null;
	}

	#if lime_miniaudio
	/**
		Node of this effect for `source`, created on first use. Null if the effect has none.
	**/
	@:allow(lime._internal.backend.native.NativeAudioSource)
	@:noCompletion private function __getNode(source:AudioSource, channels:Int, sampleRate:Int):Null<MANode>
	{
		var node = __nodes.get(source);
		if (node == null)
		{
			node = __createNode(channels, sampleRate);
			if (node != null)
				__nodes.set(source, node);
		}
		return node;
	}

	/**
		Releases this effect's node for `source`. Its sound must already be detached from it.
	**/
	@:allow(lime._internal.backend.native.NativeAudioSource)
	@:noCompletion private function __releaseNode(source:AudioSource):Void
	{
		final node = __nodes.get(source);
		if (node == null)
			return;

		__nodes.remove(source);
		node.detach_all_output_buses();
		__destroyNode(node);
	}

	/**
		Creates the miniaudio node of this effect. Subclasses implement it.
	**/
	@:noCompletion private function __createNode(channels:Int, sampleRate:Int):Null<MANode>
	{
		return null;
	}

	/**
		Releases a node made by `__createNode`. Subclasses implement it.
	**/
	@:noCompletion private function __destroyNode(node:MANode):Void {}

	/**
		Releases every node and rebuilds the effect chain of each source, for changes
		that need new nodes (like a different filter type).
	**/
	@:noCompletion private function __recreateNodes():Void
	{
		if (__appliedSources == null)
			return;

		for (source in __appliedSources)
			source.__backend.detachEffects();
		for (source in __appliedSources)
			__releaseNode(source);
		for (source in __appliedSources)
			source.__backend.updateEffects();
	}
	#end

	@:noCompletion private function set_bypass(value:Bool):Bool
	{
		if (bypass == value)
			return value;

		bypass = value;

		#if lime_miniaudio
		if (__appliedSources != null)
			for (source in __appliedSources)
				source.__backend.updateEffects();
		#end

		return value;
	}
}
