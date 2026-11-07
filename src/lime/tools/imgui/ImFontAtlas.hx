package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImFontAtlas extends ImGuiPtrHandle
{
    public function addFont(?font_cfg:ImFontConfig = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFont(0);
        return new ImFont(NativeCFFI.lime_imgui_font_atlas_add_font(handle, font_cfg));
        #end
        return new ImFont(0);
    }

    public function addFontDefault(?font_cfg:ImFontConfig = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFont(0);
        return new ImFont(NativeCFFI.lime_imgui_font_atlas_add_font_default(handle, font_cfg));
        #end
        return new ImFont(0);
    }

    public function addFontDefaultVector(?font_cfg:ImFontConfig = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFont(0);
        return new ImFont(NativeCFFI.lime_imgui_font_atlas_add_font_default_vector(handle, font_cfg));
        #end
        return new ImFont(0);
    }

    public function addFontDefaultBitmap(?font_cfg:ImFontConfig = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFont(0);
        return new ImFont(NativeCFFI.lime_imgui_font_atlas_add_font_default_bitmap(handle, font_cfg));
        #end
        return new ImFont(0);
    }

    public function addFontFromFileTTF(filename:String, size_pixels:Float = 0.0, ?font_cfg:ImFontConfig = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFont(0);
        return new ImFont(NativeCFFI.lime_imgui_font_atlas_add_font_from_file_ttf(handle, filename, size_pixels, font_cfg));
        #end
        return new ImFont(0);
    }

    public function removeFont(font:ImFont):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid() || !font.isValid()) return;
        NativeCFFI.lime_imgui_font_atlas_remove_font(handle, font.handle);
        #end
    }

    public function clear():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_font_atlas_clear(handle);
        #end
    }

    public function compactCache():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_font_atlas_compact_cache(handle);
        #end
    }
}