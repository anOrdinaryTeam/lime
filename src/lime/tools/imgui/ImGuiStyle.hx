package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImGuiTypes;
import lime.tools.imgui.ImGuiFlags;
import lime._internal.backend.native.NativeCFFI;

/*
@:access(lime._internal.backend.native.NativeCFFI)
abstract ImGuiStyleColors(Array<ImVec4>) from Array<ImVec4> {

    static var _style:ImGuiStyle; //set by the style before accessing

    @:arrayAccess
    public inline function get(k:Int):ImVec4 {
        return get_colors(k);
    }
    @:arrayAccess
    public inline function set(k:Int, v:ImVec4):ImVec4 {
        return set_colors(k, v);
    }

    private function get_colors(index:Int):ImVec4
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!_style.isValid()) return new ImVec4();
        @:privateAccess
        var c:Dynamic = NativeCFFI.lime_imgui_style_get_colors(_style.handle, index);
        return new ImVec4(c.x, c.y, c.z, c.w);
        #end
        return new ImVec4();
    }
    private function set_colors(index:Int, color:ImVec4):ImVec4
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!_style.isValid()) return new ImVec4();
        @:privateAccess
        var c:Dynamic = NativeCFFI.lime_imgui_style_set_colors(_style.handle, index, color);
        return new ImVec4(c.x, c.y, c.z, c.w);
        #end
        return new ImVec4();
    }
}
*/

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiStyle extends ImGuiPtrHandle
{
    public var fontSizeBase(get, set):Float;
    public var fontScaleMain(get, set):Float;
    public var fontScaleDpi(get, set):Float;
    public var alpha(get, set):Float;
    public var disabledAlpha(get, set):Float;
    public var windowPaddingX(get, set):Float;
    public var windowPaddingY(get, set):Float;
    public var windowRounding(get, set):Float;
    public var windowBorderSize(get, set):Float;
    public var windowBorderHoverPadding(get, set):Float;
    public var windowMinSizeX(get, set):Float;
    public var windowMinSizeY(get, set):Float;
    public var windowTitleAlignX(get, set):Float;
    public var windowTitleAlignY(get, set):Float;
    public var windowMenuButtonPosition(get, set):Int;
    public var childRounding(get, set):Float;
    public var childBorderSize(get, set):Float;
    public var popupRounding(get, set):Float;
    public var popupBorderSize(get, set):Float;
    public var framePaddingX(get, set):Float;
    public var framePaddingY(get, set):Float;
    public var frameRounding(get, set):Float;
    public var frameBorderSize(get, set):Float;
    public var itemSpacingX(get, set):Float;
    public var itemSpacingY(get, set):Float;
    public var itemInnerSpacingX(get, set):Float;
    public var itemInnerSpacingY(get, set):Float;
    public var cellPaddingX(get, set):Float;
    public var cellPaddingY(get, set):Float;
    public var touchExtraPaddingX(get, set):Float;
    public var touchExtraPaddingY(get, set):Float;
    public var indentSpacing(get, set):Float;
    public var columnsMinSpacing(get, set):Float;
    public var scrollbarSize(get, set):Float;
    public var scrollbarRounding(get, set):Float;
    public var scrollbarPadding(get, set):Float;
    public var grabMinSize(get, set):Float;
    public var grabRounding(get, set):Float;
    public var logSliderDeadzone(get, set):Float;
    public var imageRounding(get, set):Float;
    public var imageBorderSize(get, set):Float;
    public var tabRounding(get, set):Float;
    public var tabBorderSize(get, set):Float;
    public var tabMinWidthBase(get, set):Float;
    public var tabMinWidthShrink(get, set):Float;
    public var tabCloseButtonMinWidthSelected(get, set):Float;
    public var tabCloseButtonMinWidthUnselected(get, set):Float;
    public var tabBarBorderSize(get, set):Float;
    public var tabBarOverlineSize(get, set):Float;
    public var tableAngledHeadersAngle(get, set):Float;
    public var tableAngledHeadersTextAlignX(get, set):Float;
    public var tableAngledHeadersTextAlignY(get, set):Float;
    public var treeLinesFlags(get, set):ImGuiTreeNodeFlags;
    public var treeLinesSize(get, set):Float;
    public var treeLinesRounding(get, set):Float;
    public var dragDropTargetRounding(get, set):Float;
    public var dragDropTargetBorderSize(get, set):Float;
    public var dragDropTargetPadding(get, set):Float;
    public var colorMarkerSize(get, set):Float;
    public var colorButtonPosition(get, set):Int;
    public var buttonTextAlignX(get, set):Float;
    public var buttonTextAlignY(get, set):Float;
    public var selectableTextAlignX(get, set):Float;
    public var selectableTextAlignY(get, set):Float;
    public var separatorSize(get, set):Float;
    public var separatorTextBorderSize(get, set):Float;
    public var separatorTextAlignX(get, set):Float;
    public var separatorTextAlignY(get, set):Float;
    public var separatorTextPaddingX(get, set):Float;
    public var separatorTextPaddingY(get, set):Float;
    public var displayWindowPaddingX(get, set):Float;
    public var displayWindowPaddingY(get, set):Float;
    public var displaySafeAreaPaddingX(get, set):Float;
    public var displaySafeAreaPaddingY(get, set):Float;
    public var dockingNodeHasCloseButton(get, set):Bool;
    public var dockingSeparatorSize(get, set):Float;
    public var mouseCursorScale(get, set):Float;
    public var antiAliasedLines(get, set):Bool;
    public var antiAliasedLinesUseTex(get, set):Bool;
    public var antiAliasedFill(get, set):Bool;
    public var curveTessellationTol(get, set):Float;
    public var circleTessellationMaxError(get, set):Float;

    public var hoverStationaryDelay(get, set):Float;
    public var hoverDelayShort(get, set):Float;
    public var hoverDelayNormal(get, set):Float;
    public var hoverFlagsForTooltipMouse(get, set):ImGuiHoveredFlags;
    public var hoverFlagsForTooltipNav(get, set):ImGuiHoveredFlags;
    /*
    public var colors(get, null):ImGuiStyleColors;
    private function get_colors():ImGuiStyleColors
    {
        @:privateAccess
        ImGuiStyleColors._style = this;
        return colors;
    }

    override public function new(handle:Float = 0.0)
    {
        super(handle);
        //colors = new ImGuiStyleColors();
        //colors.parentStyle = this;
    }*/
    public function getColor(idx:ImGuiCol):ImVec4
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImVec4();
        var c:Dynamic = NativeCFFI.lime_imgui_style_get_colors(handle, idx);
        return new ImVec4(c.x, c.y, c.z, c.w);
        #end
        return new ImVec4();
    }
    public function setColor(idx:ImGuiCol, col:ImVec4):ImVec4
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImVec4();
        @:privateAccess
        var c:Dynamic = NativeCFFI.lime_imgui_style_set_colors(handle, idx, col);
        return new ImVec4(c.x, c.y, c.z, c.w);
        #end
        return new ImVec4();
    }

    private function get_fontSizeBase():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_font_size_base(handle);
        #end
        return 0;
    }
    private function set_fontSizeBase(FontSizeBase:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_font_size_base(handle, FontSizeBase);
        #end
        return 0;
    }
    private function get_fontScaleMain():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_font_scale_main(handle);
        #end
        return 0;
    }
    private function set_fontScaleMain(FontScaleMain:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_font_scale_main(handle, FontScaleMain);
        #end
        return 0;
    }
    private function get_fontScaleDpi():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_font_scale_dpi(handle);
        #end
        return 0;
    }
    private function set_fontScaleDpi(FontScaleDpi:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_font_scale_dpi(handle, FontScaleDpi);
        #end
        return 0;
    }
    private function get_alpha():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_alpha(handle);
        #end
        return 0;
    }
    private function set_alpha(Alpha:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_alpha(handle, Alpha);
        #end
        return 0;
    }
    private function get_disabledAlpha():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_disabled_alpha(handle);
        #end
        return 0;
    }
    private function set_disabledAlpha(DisabledAlpha:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_disabled_alpha(handle, DisabledAlpha);
        #end
        return 0;
    }
    private function get_windowPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_padding_x(handle);
        #end
        return 0;
    }
    private function set_windowPaddingX(WindowPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_padding_x(handle, WindowPaddingX);
        #end
        return 0;
    }
    private function get_windowPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_padding_y(handle);
        #end
        return 0;
    }
    private function set_windowPaddingY(WindowPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_padding_y(handle, WindowPaddingY);
        #end
        return 0;
    }
    private function get_windowRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_rounding(handle);
        #end
        return 0;
    }
    private function set_windowRounding(WindowRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_rounding(handle, WindowRounding);
        #end
        return 0;
    }
    private function get_windowBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_border_size(handle);
        #end
        return 0;
    }
    private function set_windowBorderSize(WindowBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_border_size(handle, WindowBorderSize);
        #end
        return 0;
    }
    private function get_windowBorderHoverPadding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_border_hover_padding(handle);
        #end
        return 0;
    }
    private function set_windowBorderHoverPadding(WindowBorderHoverPadding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_border_hover_padding(handle, WindowBorderHoverPadding);
        #end
        return 0;
    }
    private function get_windowMinSizeX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_min_size_x(handle);
        #end
        return 0;
    }
    private function set_windowMinSizeX(WindowMinSizeX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_min_size_x(handle, WindowMinSizeX);
        #end
        return 0;
    }
    private function get_windowMinSizeY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_min_size_y(handle);
        #end
        return 0;
    }
    private function set_windowMinSizeY(WindowMinSizeY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_min_size_y(handle, WindowMinSizeY);
        #end
        return 0;
    }
    private function get_windowTitleAlignX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_title_align_x(handle);
        #end
        return 0;
    }
    private function set_windowTitleAlignX(WindowTitleAlignX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_title_align_x(handle, WindowTitleAlignX);
        #end
        return 0;
    }
    private function get_windowTitleAlignY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_title_align_y(handle);
        #end
        return 0;
    }
    private function set_windowTitleAlignY(WindowTitleAlignY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_title_align_y(handle, WindowTitleAlignY);
        #end
        return 0;
    }
    private function get_windowMenuButtonPosition():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_window_menu_button_position(handle);
        #end
        return 0;
    }
    private function set_windowMenuButtonPosition(WindowMenuButtonPosition:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_window_menu_button_position(handle, WindowMenuButtonPosition);
        #end
        return 0;
    }
    private function get_childRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_child_rounding(handle);
        #end
        return 0;
    }
    private function set_childRounding(ChildRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_child_rounding(handle, ChildRounding);
        #end
        return 0;
    }
    private function get_childBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_child_border_size(handle);
        #end
        return 0;
    }
    private function set_childBorderSize(ChildBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_child_border_size(handle, ChildBorderSize);
        #end
        return 0;
    }
    private function get_popupRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_popup_rounding(handle);
        #end
        return 0;
    }
    private function set_popupRounding(PopupRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_popup_rounding(handle, PopupRounding);
        #end
        return 0;
    }
    private function get_popupBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_popup_border_size(handle);
        #end
        return 0;
    }
    private function set_popupBorderSize(PopupBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_popup_border_size(handle, PopupBorderSize);
        #end
        return 0;
    }
    private function get_framePaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_frame_padding_x(handle);
        #end
        return 0;
    }
    private function set_framePaddingX(FramePaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_frame_padding_x(handle, FramePaddingX);
        #end
        return 0;
    }
    private function get_framePaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_frame_padding_y(handle);
        #end
        return 0;
    }
    private function set_framePaddingY(FramePaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_frame_padding_y(handle, FramePaddingY);
        #end
        return 0;
    }
    private function get_frameRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_frame_rounding(handle);
        #end
        return 0;
    }
    private function set_frameRounding(FrameRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_frame_rounding(handle, FrameRounding);
        #end
        return 0;
    }
    private function get_frameBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_frame_border_size(handle);
        #end
        return 0;
    }
    private function set_frameBorderSize(FrameBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_frame_border_size(handle, FrameBorderSize);
        #end
        return 0;
    }
    private function get_itemSpacingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_item_spacing_x(handle);
        #end
        return 0;
    }
    private function set_itemSpacingX(ItemSpacingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_item_spacing_x(handle, ItemSpacingX);
        #end
        return 0;
    }
    private function get_itemSpacingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_item_spacing_y(handle);
        #end
        return 0;
    }
    private function set_itemSpacingY(ItemSpacingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_item_spacing_y(handle, ItemSpacingY);
        #end
        return 0;
    }
    private function get_itemInnerSpacingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_item_inner_spacing_x(handle);
        #end
        return 0;
    }
    private function set_itemInnerSpacingX(ItemInnerSpacingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_item_inner_spacing_x(handle, ItemInnerSpacingX);
        #end
        return 0;
    }
    private function get_itemInnerSpacingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_item_inner_spacing_y(handle);
        #end
        return 0;
    }
    private function set_itemInnerSpacingY(ItemInnerSpacingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_item_inner_spacing_y(handle, ItemInnerSpacingY);
        #end
        return 0;
    }
    private function get_cellPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_cell_padding_x(handle);
        #end
        return 0;
    }
    private function set_cellPaddingX(CellPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_cell_padding_x(handle, CellPaddingX);
        #end
        return 0;
    }
    private function get_cellPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_cell_padding_y(handle);
        #end
        return 0;
    }
    private function set_cellPaddingY(CellPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_cell_padding_y(handle, CellPaddingY);
        #end
        return 0;
    }
    private function get_touchExtraPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_touch_extra_padding_x(handle);
        #end
        return 0;
    }
    private function set_touchExtraPaddingX(TouchExtraPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_touch_extra_padding_x(handle, TouchExtraPaddingX);
        #end
        return 0;
    }
    private function get_touchExtraPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_touch_extra_padding_y(handle);
        #end
        return 0;
    }
    private function set_touchExtraPaddingY(TouchExtraPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_touch_extra_padding_y(handle, TouchExtraPaddingY);
        #end
        return 0;
    }
    private function get_indentSpacing():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_indent_spacing(handle);
        #end
        return 0;
    }
    private function set_indentSpacing(IndentSpacing:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_indent_spacing(handle, IndentSpacing);
        #end
        return 0;
    }
    private function get_columnsMinSpacing():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_columns_min_spacing(handle);
        #end
        return 0;
    }
    private function set_columnsMinSpacing(ColumnsMinSpacing:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_columns_min_spacing(handle, ColumnsMinSpacing);
        #end
        return 0;
    }
    private function get_scrollbarSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_scrollbar_size(handle);
        #end
        return 0;
    }
    private function set_scrollbarSize(ScrollbarSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_scrollbar_size(handle, ScrollbarSize);
        #end
        return 0;
    }
    private function get_scrollbarRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_scrollbar_rounding(handle);
        #end
        return 0;
    }
    private function set_scrollbarRounding(ScrollbarRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_scrollbar_rounding(handle, ScrollbarRounding);
        #end
        return 0;
    }
    private function get_scrollbarPadding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_scrollbar_padding(handle);
        #end
        return 0;
    }
    private function set_scrollbarPadding(ScrollbarPadding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_scrollbar_padding(handle, ScrollbarPadding);
        #end
        return 0;
    }
    private function get_grabMinSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_grab_min_size(handle);
        #end
        return 0;
    }
    private function set_grabMinSize(GrabMinSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_grab_min_size(handle, GrabMinSize);
        #end
        return 0;
    }
    private function get_grabRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_grab_rounding(handle);
        #end
        return 0;
    }
    private function set_grabRounding(GrabRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_grab_rounding(handle, GrabRounding);
        #end
        return 0;
    }
    private function get_logSliderDeadzone():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_log_slider_deadzone(handle);
        #end
        return 0;
    }
    private function set_logSliderDeadzone(LogSliderDeadzone:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_log_slider_deadzone(handle, LogSliderDeadzone);
        #end
        return 0;
    }
    private function get_imageRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_image_rounding(handle);
        #end
        return 0;
    }
    private function set_imageRounding(ImageRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_image_rounding(handle, ImageRounding);
        #end
        return 0;
    }
    private function get_imageBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_image_border_size(handle);
        #end
        return 0;
    }
    private function set_imageBorderSize(ImageBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_image_border_size(handle, ImageBorderSize);
        #end
        return 0;
    }
    private function get_tabRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_rounding(handle);
        #end
        return 0;
    }
    private function set_tabRounding(TabRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_rounding(handle, TabRounding);
        #end
        return 0;
    }
    private function get_tabBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_border_size(handle);
        #end
        return 0;
    }
    private function set_tabBorderSize(TabBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_border_size(handle, TabBorderSize);
        #end
        return 0;
    }
    private function get_tabMinWidthBase():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_min_width_base(handle);
        #end
        return 0;
    }
    private function set_tabMinWidthBase(TabMinWidthBase:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_min_width_base(handle, TabMinWidthBase);
        #end
        return 0;
    }
    private function get_tabMinWidthShrink():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_min_width_shrink(handle);
        #end
        return 0;
    }
    private function set_tabMinWidthShrink(TabMinWidthShrink:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_min_width_shrink(handle, TabMinWidthShrink);
        #end
        return 0;
    }
    private function get_tabCloseButtonMinWidthSelected():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_close_button_min_width_selected(handle);
        #end
        return 0;
    }
    private function set_tabCloseButtonMinWidthSelected(TabCloseButtonMinWidthSelected:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_close_button_min_width_selected(handle, TabCloseButtonMinWidthSelected);
        #end
        return 0;
    }
    private function get_tabCloseButtonMinWidthUnselected():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_close_button_min_width_unselected(handle);
        #end
        return 0;
    }
    private function set_tabCloseButtonMinWidthUnselected(TabCloseButtonMinWidthUnselected:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_close_button_min_width_unselected(handle, TabCloseButtonMinWidthUnselected);
        #end
        return 0;
    }
    private function get_tabBarBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_bar_border_size(handle);
        #end
        return 0;
    }
    private function set_tabBarBorderSize(TabBarBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_bar_border_size(handle, TabBarBorderSize);
        #end
        return 0;
    }
    private function get_tabBarOverlineSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tab_bar_overline_size(handle);
        #end
        return 0;
    }
    private function set_tabBarOverlineSize(TabBarOverlineSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tab_bar_overline_size(handle, TabBarOverlineSize);
        #end
        return 0;
    }
    private function get_tableAngledHeadersAngle():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_table_angled_headers_angle(handle);
        #end
        return 0;
    }
    private function set_tableAngledHeadersAngle(TableAngledHeadersAngle:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_table_angled_headers_angle(handle, TableAngledHeadersAngle);
        #end
        return 0;
    }
    private function get_tableAngledHeadersTextAlignX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_table_angled_headers_text_align_x(handle);
        #end
        return 0;
    }
    private function set_tableAngledHeadersTextAlignX(TableAngledHeadersTextAlignX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_table_angled_headers_text_align_x(handle, TableAngledHeadersTextAlignX);
        #end
        return 0;
    }
    private function get_tableAngledHeadersTextAlignY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_table_angled_headers_text_align_y(handle);
        #end
        return 0;
    }
    private function set_tableAngledHeadersTextAlignY(TableAngledHeadersTextAlignY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_table_angled_headers_text_align_y(handle, TableAngledHeadersTextAlignY);
        #end
        return 0;
    }
    private function get_treeLinesFlags():ImGuiTreeNodeFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tree_lines_flags(handle);
        #end
        return 0;
    }
    private function set_treeLinesFlags(TreeLinesFlags:ImGuiTreeNodeFlags):ImGuiTreeNodeFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tree_lines_flags(handle, TreeLinesFlags);
        #end
        return 0;
    }
    private function get_treeLinesSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tree_lines_size(handle);
        #end
        return 0;
    }
    private function set_treeLinesSize(TreeLinesSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tree_lines_size(handle, TreeLinesSize);
        #end
        return 0;
    }
    private function get_treeLinesRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_tree_lines_rounding(handle);
        #end
        return 0;
    }
    private function set_treeLinesRounding(TreeLinesRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_tree_lines_rounding(handle, TreeLinesRounding);
        #end
        return 0;
    }
    private function get_dragDropTargetRounding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_drag_drop_target_rounding(handle);
        #end
        return 0;
    }
    private function set_dragDropTargetRounding(DragDropTargetRounding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_drag_drop_target_rounding(handle, DragDropTargetRounding);
        #end
        return 0;
    }
    private function get_dragDropTargetBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_drag_drop_target_border_size(handle);
        #end
        return 0;
    }
    private function set_dragDropTargetBorderSize(DragDropTargetBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_drag_drop_target_border_size(handle, DragDropTargetBorderSize);
        #end
        return 0;
    }
    private function get_dragDropTargetPadding():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_drag_drop_target_padding(handle);
        #end
        return 0;
    }
    private function set_dragDropTargetPadding(DragDropTargetPadding:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_drag_drop_target_padding(handle, DragDropTargetPadding);
        #end
        return 0;
    }
    private function get_colorMarkerSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_color_marker_size(handle);
        #end
        return 0;
    }
    private function set_colorMarkerSize(ColorMarkerSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_color_marker_size(handle, ColorMarkerSize);
        #end
        return 0;
    }
    private function get_colorButtonPosition():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_color_button_position(handle);
        #end
        return 0;
    }
    private function set_colorButtonPosition(ColorButtonPosition:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_color_button_position(handle, ColorButtonPosition);
        #end
        return 0;
    }
    private function get_buttonTextAlignX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_button_text_align_x(handle);
        #end
        return 0;
    }
    private function set_buttonTextAlignX(ButtonTextAlignX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_button_text_align_x(handle, ButtonTextAlignX);
        #end
        return 0;
    }
    private function get_buttonTextAlignY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_button_text_align_y(handle);
        #end
        return 0;
    }
    private function set_buttonTextAlignY(ButtonTextAlignY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_button_text_align_y(handle, ButtonTextAlignY);
        #end
        return 0;
    }
    private function get_selectableTextAlignX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_selectable_text_align_x(handle);
        #end
        return 0;
    }
    private function set_selectableTextAlignX(SelectableTextAlignX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_selectable_text_align_x(handle, SelectableTextAlignX);
        #end
        return 0;
    }
    private function get_selectableTextAlignY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_selectable_text_align_y(handle);
        #end
        return 0;
    }
    private function set_selectableTextAlignY(SelectableTextAlignY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_selectable_text_align_y(handle, SelectableTextAlignY);
        #end
        return 0;
    }
    private function get_separatorSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_size(handle);
        #end
        return 0;
    }
    private function set_separatorSize(SeparatorSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_size(handle, SeparatorSize);
        #end
        return 0;
    }
    private function get_separatorTextBorderSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_text_border_size(handle);
        #end
        return 0;
    }
    private function set_separatorTextBorderSize(SeparatorTextBorderSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_text_border_size(handle, SeparatorTextBorderSize);
        #end
        return 0;
    }
    private function get_separatorTextAlignX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_text_align_x(handle);
        #end
        return 0;
    }
    private function set_separatorTextAlignX(SeparatorTextAlignX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_text_align_x(handle, SeparatorTextAlignX);
        #end
        return 0;
    }
    private function get_separatorTextAlignY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_text_align_y(handle);
        #end
        return 0;
    }
    private function set_separatorTextAlignY(SeparatorTextAlignY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_text_align_y(handle, SeparatorTextAlignY);
        #end
        return 0;
    }
    private function get_separatorTextPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_text_padding_x(handle);
        #end
        return 0;
    }
    private function set_separatorTextPaddingX(SeparatorTextPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_text_padding_x(handle, SeparatorTextPaddingX);
        #end
        return 0;
    }
    private function get_separatorTextPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_separator_text_padding_y(handle);
        #end
        return 0;
    }
    private function set_separatorTextPaddingY(SeparatorTextPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_separator_text_padding_y(handle, SeparatorTextPaddingY);
        #end
        return 0;
    }
    private function get_displayWindowPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_display_window_padding_x(handle);
        #end
        return 0;
    }
    private function set_displayWindowPaddingX(DisplayWindowPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_display_window_padding_x(handle, DisplayWindowPaddingX);
        #end
        return 0;
    }
    private function get_displayWindowPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_display_window_padding_y(handle);
        #end
        return 0;
    }
    private function set_displayWindowPaddingY(DisplayWindowPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_display_window_padding_y(handle, DisplayWindowPaddingY);
        #end
        return 0;
    }
    private function get_displaySafeAreaPaddingX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_display_safe_area_padding_x(handle);
        #end
        return 0;
    }
    private function set_displaySafeAreaPaddingX(DisplaySafeAreaPaddingX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_display_safe_area_padding_x(handle, DisplaySafeAreaPaddingX);
        #end
        return 0;
    }
    private function get_displaySafeAreaPaddingY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_display_safe_area_padding_y(handle);
        #end
        return 0;
    }
    private function set_displaySafeAreaPaddingY(DisplaySafeAreaPaddingY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_display_safe_area_padding_y(handle, DisplaySafeAreaPaddingY);
        #end
        return 0;
    }
    private function get_dockingNodeHasCloseButton():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_get_docking_node_has_close_button(handle);
        #end
        return false;
    }
    private function set_dockingNodeHasCloseButton(DockingNodeHasCloseButton:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_set_docking_node_has_close_button(handle, DockingNodeHasCloseButton);
        #end
        return false;
    }
    private function get_dockingSeparatorSize():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_docking_separator_size(handle);
        #end
        return 0;
    }
    private function set_dockingSeparatorSize(DockingSeparatorSize:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_docking_separator_size(handle, DockingSeparatorSize);
        #end
        return 0;
    }
    private function get_mouseCursorScale():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_mouse_cursor_scale(handle);
        #end
        return 0;
    }
    private function set_mouseCursorScale(MouseCursorScale:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_mouse_cursor_scale(handle, MouseCursorScale);
        #end
        return 0;
    }
    private function get_antiAliasedLines():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_get_anti_aliased_lines(handle);
        #end
        return false;
    }
    private function set_antiAliasedLines(AntiAliasedLines:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_set_anti_aliased_lines(handle, AntiAliasedLines);
        #end
        return false;
    }
    private function get_antiAliasedLinesUseTex():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_get_anti_aliased_lines_use_tex(handle);
        #end
        return false;
    }
    private function set_antiAliasedLinesUseTex(AntiAliasedLinesUseTex:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_set_anti_aliased_lines_use_tex(handle, AntiAliasedLinesUseTex);
        #end
        return false;
    }
    private function get_antiAliasedFill():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_get_anti_aliased_fill(handle);
        #end
        return false;
    }
    private function set_antiAliasedFill(AntiAliasedFill:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_style_set_anti_aliased_fill(handle, AntiAliasedFill);
        #end
        return false;
    }
    private function get_curveTessellationTol():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_curve_tessellation_tol(handle);
        #end
        return 0;
    }
    private function set_curveTessellationTol(CurveTessellationTol:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_curve_tessellation_tol(handle, CurveTessellationTol);
        #end
        return 0;
    }
    private function get_circleTessellationMaxError():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_circle_tessellation_max_error(handle);
        #end
        return 0;
    }
    private function set_circleTessellationMaxError(CircleTessellationMaxError:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_circle_tessellation_max_error(handle, CircleTessellationMaxError);
        #end
        return 0;
    }

    private function get_hoverStationaryDelay():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_hover_stationary_delay(handle);
        #end
        return 0;
    }
    private function set_hoverStationaryDelay(HoverStationaryDelay:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_hover_stationary_delay(handle, HoverStationaryDelay);
        #end
        return 0;
    }
    private function get_hoverDelayShort():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_hover_delay_short(handle);
        #end
        return 0;
    }
    private function set_hoverDelayShort(HoverDelayShort:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_hover_delay_short(handle, HoverDelayShort);
        #end
        return 0;
    }
    private function get_hoverDelayNormal():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_hover_delay_normal(handle);
        #end
        return 0;
    }
    private function set_hoverDelayNormal(HoverDelayNormal:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_hover_delay_normal(handle, HoverDelayNormal);
        #end
        return 0;
    }
    private function get_hoverFlagsForTooltipMouse():ImGuiHoveredFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_hover_flags_for_tooltip_mouse(handle);
        #end
        return 0;
    }
    private function set_hoverFlagsForTooltipMouse(HoverFlagsForTooltipMouse:ImGuiHoveredFlags):ImGuiHoveredFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_hover_flags_for_tooltip_mouse(handle, HoverFlagsForTooltipMouse);
        #end
        return 0;
    }
    private function get_hoverFlagsForTooltipNav():ImGuiHoveredFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_get_hover_flags_for_tooltip_nav(handle);
        #end
        return 0;
    }
    private function set_hoverFlagsForTooltipNav(HoverFlagsForTooltipNav:ImGuiHoveredFlags):ImGuiHoveredFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_style_set_hover_flags_for_tooltip_nav(handle, HoverFlagsForTooltipNav);
        #end
        return 0;
    }
}