package lime.tools.imgui;

import lime.tools.imgui.ImGuiTypes;

#if cpp
import cpp.Pointer;
#end

#if (cpp && !cppia)
import cpp.Float32;
#else
typedef Float32 = Float;
#end

@:allow(lime.tools.imgui.ImGui)
class ImGuiBoolPtr
{
	public var value:Bool;
	#if cpp
	@:unreflective
	private var ptr:Pointer<Bool>;
	#end

	public function new(v:Bool)
	{
		value = v;
		#if cpp
		ptr = Pointer.addressOf(value);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiStringPtr
{
	public var value:String;
	#if cpp
	@:unreflective
	private var ptr:Pointer<String>;
	#end

	public function new(v:String)
	{
		value = v;
		#if cpp
		ptr = Pointer.addressOf(value);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiFloatPtr
{
	//has to be float32 because haxe floats are 64 bit
	public var value:Float32;

	#if cpp
	@:unreflective
	private var ptr:Pointer<Float32>;
	#end

	public function new(v:Float)
	{
		value = v;
		#if cpp
		ptr = Pointer.addressOf(value);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiFloat2Ptr
{
	public var values:haxe.ds.Vector<Float32> = new haxe.ds.Vector<Float32>(2);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Float32>;
	#end

	public function new(v0:Float, v1:Float)
	{
		values[0] = v0;
		values[1] = v1;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiFloat3Ptr
{
	public var values:haxe.ds.Vector<Float32> = new haxe.ds.Vector<Float32>(3);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Float32>;
	#end

	public function new(v0:Float, v1:Float, v2:Float)
	{
		values[0] = v0;
		values[1] = v1;
		values[2] = v2;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}

	public function toImColor():ImColor
	{
		return ImColor.create(255, Std.int(values[0] * 255.0), Std.int(values[1] * 255.0), Std.int(values[2] * 255.0));
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiFloat4Ptr
{
	public var values:haxe.ds.Vector<Float32> = new haxe.ds.Vector<Float32>(4);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Float32>;
	#end

	public function new(v0:Float, v1:Float, v2:Float, v3:Float)
	{
		values[0] = v0;
		values[1] = v1;
		values[2] = v2;
		values[3] = v3;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}

	public function toImColor():ImColor
	{
		return ImColor.create(Std.int(values[3] * 255.0), Std.int(values[0] * 255.0), Std.int(values[1] * 255.0), Std.int(values[2] * 255.0));
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiIntPtr
{
	public var value:Int;

	#if cpp
	@:unreflective
	private var ptr:Pointer<Int>;
	#end

	public function new(v:Int)
	{
		value = v;
		#if cpp
		ptr = Pointer.addressOf(value);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiInt2Ptr
{
	public var values:haxe.ds.Vector<Int> = new haxe.ds.Vector<Int>(2);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Int>;
	#end

	public function new(v0:Int, v1:Int)
	{
		values[0] = v0;
		values[1] = v1;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiInt3Ptr
{
	public var values:haxe.ds.Vector<Int> = new haxe.ds.Vector<Int>(3);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Int>;
	#end

	public function new(v0:Int, v1:Int, v2:Int)
	{
		values[0] = v0;
		values[1] = v1;
		values[2] = v2;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiInt4Ptr
{
	public var values:haxe.ds.Vector<Int> = new haxe.ds.Vector<Int>(4);

	#if cpp
	@:unreflective
	private var ptr:Pointer<Int>;
	#end

	public function new(v0:Int, v1:Int, v2:Int, v3:Int)
	{
		values[0] = v0;
		values[1] = v1;
		values[2] = v2;
		values[3] = v3;
		#if cpp
		ptr = Pointer.arrayElem(cast values, 0);
		#end
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiPtrHandle
{
	//this is the cpp pointer stored as a float (double)
	@:unreflective
	private var handle(default, null):Float = 0.0;

    public function new(handle:Float = 0.0)
    {
        this.handle = handle;
    }

    public function getHandle() { return handle; }
	public function isValid() { return handle != 0.0; }
}

//same as ImGuiPtrHandle but for only 1 frame, used for safety
class ImGuiTempPtrHandle extends ImGuiPtrHandle
{
	@:unreflective
	private var frameCount:Int = 0;
	override public function new (handle:Float = 0.0)
	{
		super(handle);
		frameCount = ImGui.getFrameCount();
	}

	override public function isValid() {
		return handle != 0.0 && ImGui.getFrameCount() == frameCount;
	}
}

@:allow(lime.tools.imgui.ImGui)
class ImGuiInputTextCallback
{
	private var callback:Float->Void;

	#if cpp
	@:unreflective
	private var ptr:Pointer<Float->Void>;
	#end

	public function new(func:ImGuiInputTextCallbackData->Void)
	{
		callback = function(handle:Float) {
			func(new ImGuiInputTextCallbackData(handle));
		};
		#if cpp
		ptr = Pointer.addressOf(callback);
		#end
	}
}