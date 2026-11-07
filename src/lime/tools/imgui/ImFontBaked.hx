package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImFontBaked extends ImGuiTempPtrHandle
{
    public function clearOutputData():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_font_baked_clear_output_data(handle);
        #end
    }

    public function findGlyph(c:Int):ImFontGlyph
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFontGlyph(0);
        return new ImFontGlyph(NativeCFFI.lime_imgui_font_baked_find_glyph(handle, c));
        #end
        return new ImFontGlyph(0);
    }

    public function findGlyphNoFallback(c:Int):ImFontGlyph
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImFontGlyph(0);
        return new ImFontGlyph(NativeCFFI.lime_imgui_font_baked_find_glyph_no_fallback(handle, c));
        #end
        return new ImFontGlyph(0);
    }

    public function getCharAdvance(c:Int):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_baked_get_char_advance(handle, c);
        #end
        return 0;
    }

    public function isGlyphLoaded(c:Int):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_font_baked_is_glyph_loaded(handle, c);
        #end
        return false;
    }
}