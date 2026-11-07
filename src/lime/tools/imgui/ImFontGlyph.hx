package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImFontGlyph extends ImGuiTempPtrHandle
{
    public var colored(get, set):Int;
    public var visible(get, set):Int;
    public var sourceIdx(get, set):Int;
    public var codepoint(get, set):Int;
    public var advanceX(get, set):Float;
    public var x0(get, set):Float;
    public var y0(get, set):Float;
    public var x1(get, set):Float;
    public var y1(get, set):Float;
    public var u0(get, set):Float;
    public var v0(get, set):Float;
    public var u1(get, set):Float;
    public var v1(get, set):Float;
    public var packId(get, set):Int;

    private function get_colored():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_colored(handle);
        #end
        return 0;
    }
    private function set_colored(Colored:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_colored(handle, Colored);
        #end
        return 0;
    }
    private function get_visible():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_visible(handle);
        #end
        return 0;
    }
    private function set_visible(Visible:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_visible(handle, Visible);
        #end
        return 0;
    }
    private function get_sourceIdx():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_source_idx(handle);
        #end
        return 0;
    }
    private function set_sourceIdx(SourceIdx:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_source_idx(handle, SourceIdx);
        #end
        return 0;
    }
    private function get_codepoint():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_codepoint(handle);
        #end
        return 0;
    }
    private function set_codepoint(Codepoint:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_codepoint(handle, Codepoint);
        #end
        return 0;
    }
    private function get_advanceX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_advance_x(handle);
        #end
        return 0;
    }
    private function set_advanceX(AdvanceX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_advance_x(handle, AdvanceX);
        #end
        return 0;
    }
    private function get_x0():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_x_0(handle);
        #end
        return 0;
    }
    private function set_x0(X0:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_x_0(handle, X0);
        #end
        return 0;
    }
    private function get_y0():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_y_0(handle);
        #end
        return 0;
    }
    private function set_y0(Y0:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_y_0(handle, Y0);
        #end
        return 0;
    }
    private function get_x1():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_x_1(handle);
        #end
        return 0;
    }
    private function set_x1(X1:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_x_1(handle, X1);
        #end
        return 0;
    }
    private function get_y1():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_y_1(handle);
        #end
        return 0;
    }
    private function set_y1(Y1:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_y_1(handle, Y1);
        #end
        return 0;
    }
    private function get_u0():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_u_0(handle);
        #end
        return 0;
    }
    private function set_u0(U0:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_u_0(handle, U0);
        #end
        return 0;
    }
    private function get_v0():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_v_0(handle);
        #end
        return 0;
    }
    private function set_v0(V0:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_v_0(handle, V0);
        #end
        return 0;
    }
    private function get_u1():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_u_1(handle);
        #end
        return 0;
    }
    private function set_u1(U1:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_u_1(handle, U1);
        #end
        return 0;
    }
    private function get_v1():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_v_1(handle);
        #end
        return 0;
    }
    private function set_v1(V1:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_v_1(handle, V1);
        #end
        return 0;
    }
    private function get_packId():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_get_pack_id(handle);
        #end
        return 0;
    }
    private function set_packId(PackId:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_font_glyph_set_pack_id(handle, PackId);
        #end
        return 0;
    }
}