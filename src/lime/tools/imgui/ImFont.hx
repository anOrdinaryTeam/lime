package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImFont extends ImGuiPtrHandle
{
    public function isGlyphInFont(c:Int):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_font_is_glyph_in_font(handle, c);
        #end
        return false;
    }

    public function isLoaded():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_font_is_loaded(handle);
        #end
        return false;
    }

    public function getDebugName():String
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return "";
        return NativeCFFI.lime_imgui_font_get_debug_name(handle);
        #end
        return "";
    }
}