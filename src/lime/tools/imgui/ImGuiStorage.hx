package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImGuiTypes;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiStorage extends ImGuiPtrHandle
{
    public function clear():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_storage_clear(handle);
        #end
    }

    public function getInt(key:ImGuiID, default_val:Int = 0):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_storage_get_int(handle, key, default_val);
        #end
        return 0;
    }

    public function setInt(key:ImGuiID, val:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_storage_set_int(handle, key, val);
        #end
    }

    public function getBool(key:ImGuiID, default_val:Bool = false):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_storage_get_bool(handle, key, default_val);
        #end
        return false;
    }

    public function setBool(key:ImGuiID, val:Bool):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_storage_set_bool(handle, key, val);
        #end
    }

    public function getFloat(key:ImGuiID, default_val:Float = 0.0):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_storage_get_float(handle, key, default_val);
        #end
        return 0;
    }

    public function setFloat(key:ImGuiID, val:Float):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_storage_set_float(handle, key, val);
        #end
    }
}