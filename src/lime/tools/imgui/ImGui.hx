package lime.tools.imgui;

#if (!lime_doc_gen || lime_imgui)
import haxe.Int64;
import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;

import lime.tools.imgui.ImGuiTypes;
import lime.tools.imgui.ImGuiFlags;
import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImFont;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGui
{
	public static inline var FLOAT_MAX:Float = 3.402823466e+38;
	
	//Notes and differences betweeen default ImGui
	//	- C++ floats are 32 bit and Haxe floats are 64 bit! ImGui mainly uses 32 bit floats and they get auto converted and there may be a small loss in precision
	//	- Most functions that use ImVec2 as an argument are just 2 floats instead for convenience
	//	- Some functions that would be overloadable have slightly altered names

	//////////////////////////////////////////////////////////////////////////////////////
	// Custom
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isAnyWindowMultiViewport():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_any_window_multi_viewport();
		#end
		return false;
	}

	public static function clearAllWindowSettings():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_clear_all_window_settings();
		#end
	}

	public static function bringNamedWindowToDisplayFront(name:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_bring_named_window_to_display_front(name);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Main
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getStyle():ImGuiStyle
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImGuiStyle(NativeCFFI.lime_imgui_get_style());
		#end
		return new ImGuiStyle(0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Demo/Debug/Info
	//////////////////////////////////////////////////////////////////////////////////////

	public static function showDemoWindow(p_open:ImGuiBoolPtr = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_demo_window(p_open != null ? p_open.ptr : null);
		#end
	}

	public static function showMetricsWindow(p_open:ImGuiBoolPtr = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_metrics_window(p_open != null ? p_open.ptr : null);
		#end
	}

	public static function showDebugLogWindow(p_open:ImGuiBoolPtr = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_debug_log_window(p_open != null ? p_open.ptr : null);
		#end
	}

	public static function showIDStackToolWindow(p_open:ImGuiBoolPtr = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_id_stack_tool_window(p_open != null ? p_open.ptr : null);
		#end
	}

	public static function showAboutWindow(p_open:ImGuiBoolPtr = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_about_window(p_open != null ? p_open.ptr : null);
		#end
	}
	
	public static function showStyleEditor(?style:ImGuiStyle = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_style_editor(style != null && style.isValid() ? style.handle : 0.0);
		#end
	}

	public static function showStyleSelector(label:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_style_selector(label);
		#end
	}

	public static function showFontSelector(label:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_font_selector(label);
		#end
	}

	public static function showUserGuide():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_show_user_guide();
		#end
	}

	public static function getVersion():String
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_version();
		#end
		return "";
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Windows
	//////////////////////////////////////////////////////////////////////////////////////

	public static function begin(name:String, p_open:ImGuiBoolPtr = null, flags:ImGuiWindowFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin(name, p_open != null ? p_open.ptr : null, flags);
		#else
		return false;
		#end
	}
    public static function end():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Child Windows
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginChild(name:String, width:Float, height:Float, childFlags:ImGuiChildFlags = 0, windowFlags:ImGuiWindowFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_child(name, width, height, childFlags, windowFlags);
		#else
		return false;
		#end
	}

	public static function endChild():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_child();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Window Utils
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isWindowAppearing():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_window_appearing();
		#end
		return false;
	}

	public static function isWindowCollapsed():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_window_collapsed();
		#end
		return false;
	}

	public static function isWindowFocused(flags:ImGuiFocusedFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_window_focused(flags);
		#end
		return false;
	}

	public static function isWindowHovered(flags:ImGuiHoveredFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_window_hovered(flags);
		#end
		return false;
	}

	public static function getWindowDrawList():ImDrawList
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImDrawList(NativeCFFI.lime_imgui_get_window_draw_list());
		#end
		return new ImDrawList(0.0);
	}

	public static function getWindowDpiScale():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_window_dpi_scale();
		#end
		return 0;
	}

	public static function getWindowPos():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_window_pos();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getWindowSize():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_window_size();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getWindowWidth():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_window_width();
		#end
		return 0;
	}

	public static function getWindowHeight():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_window_height();
		#end
		return 0;
	}

	public static function getWindowViewport():ImGuiViewport
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImGuiViewport(NativeCFFI.lime_imgui_get_window_viewport());
		#end
		return new ImGuiViewport(0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Window manipulation
	//////////////////////////////////////////////////////////////////////////////////////

	public static function setNextWindowPos(posX:Float, posY:Float, cond:ImGuiCond = 0, pivotX:Float = 0, pivotY:Float = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_pos(posX, posY, cond, pivotX, pivotY);
		#end
	}

	public static function setNextWindowSize(width:Float, height:Float, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_size(width, height, cond);
		#end
	}

	public static function setNextWindowConstraints(minX:Float, minY:Float, maxX:Float, maxY:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_constraints(minX, minY, maxX, maxY);
		#end
	}

	public static function setNextWindowContentSize(width:Float, height:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_content_size(width, height);
		#end
	}

	public static function setNextWindowCollapsed(collapsed:Bool, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_collapsed(collapsed, cond);
		#end
	}

	public static function setNextWindowFocus():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_focus();
		#end
	}

	public static function setNextWindowScroll(scrollX:Float, scrollY:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_scroll(scrollX, scrollY);
		#end
	}

	public static function setNextWindowBGAlpha(alpha:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_bg_alpha(alpha);
		#end
	}

	public static function setNextWindowViewport(viewportID:Int):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_viewport(viewportID);
		#end
	}

	public static function setWindowPos(posX:Float, posY:Float, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_window_pos(posX, posY, cond);
		#end
	}

	public static function setWindowSize(width:Float, height:Float, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_window_size(width, height, cond);
		#end
	}

	public static function setWindowCollapsed(collapsed:Bool, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_window_collapsed(collapsed, cond);
		#end
	}

	public static function setWindowFocus():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_window_focus();
		#end
	}

	public static function setNamedWindowPos(name:String, posX:Float, posY:Float, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_named_window_pos(name, posX, posY, cond);
		#end
	}

	public static function setNamedWindowSize(name:String, width:Float, height:Float, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_named_window_size(name, width, height, cond);
		#end
	}

	public static function setNamedWindowCollapsed(name:String, collapsed:Bool, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_named_window_collapsed(name, collapsed, cond);
		#end
	}

	public static function setNamedWindowFocus(name:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_named_window_focus(name);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Window scrolling
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getScrollX():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_scroll_x();
		#end
		return 0.0;
	}

	public static function getScrollY():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_scroll_y();
		#end
		return 0.0;
	}

	public static function setScrollX(x:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_x(x);
		#end
	}

	public static function setScrollY(y:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_y(y);
		#end
	}

	public static function getScrollMaxX():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_scroll_max_x();
		#end
		return 0.0;
	}

	public static function getScrollMaxY():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_scroll_max_y();
		#end
		return 0.0;
	}

	public static function setScrollHereX(centerXRatio:Float = 0.5):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_here_x(centerXRatio);
		#end
	}

	public static function setScrollHereY(centerYRatio:Float = 0.5):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_here_y(centerYRatio);
		#end
	}

	public static function setScrollFromPosX(localX:Float, centerXRatio:Float = 0.5):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_from_pos_x(localX, centerXRatio);
		#end
	}

	public static function setScrollFromPosY(localY:Float, centerYRatio:Float = 0.5):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_scroll_from_pos_y(localY, centerYRatio);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Font parameter stacks
	//////////////////////////////////////////////////////////////////////////////////////

	public static function pushFont(font:ImFont, fontSizeBaseUnscaled:Float = 0.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (!font.isValid()) return;
		NativeCFFI.lime_imgui_push_font(font.handle, fontSizeBaseUnscaled);
		#end
	}

	public static function popFont():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_font();
		#end
	}

	public static function getFont():ImFont
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImFont(NativeCFFI.lime_imgui_get_font());
		#end
		return new ImFont(0.0);
	}

	public static function getFontSize():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_font_size();
		#end
		return 0.0;
	}

	public static function getFontBaked():ImFontBaked
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImFontBaked(NativeCFFI.lime_imgui_get_font_baked());
		#end
		return new ImFontBaked(0.0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Shared parameter stacks
	//////////////////////////////////////////////////////////////////////////////////////

	public static function pushStyleColor(idx:ImGuiCol, col:ImColor):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var colAsInt:Int = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
		NativeCFFI.lime_imgui_push_style_color(idx, colAsInt);
		#end
	}

	public static function popStyleColor(count:Int = 1):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_style_color(count);
		#end
	}

	public static function pushStyleVar(idx:ImGuiStyleVar, val:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_style_var(idx, val);
		#end
	}
	
	//slightly different name because we can't overload
	public static function pushStyleVar2(idx:ImGuiStyleVar, x:Float, y:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_style_var2(idx, x, y);
		#end
	}

	public static function popStyleVar(count:Int = 1):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_style_var(count);
		#end
	}

	public static function pushItemFlag(option:ImGuiItemFlags, enabled:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_item_flag(option, enabled);
		#end
	}

	public static function popItemFlag():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_item_flag();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Window parameter stacks
	//////////////////////////////////////////////////////////////////////////////////////

	public static function pushItemWidth(width:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_item_width(width);
		#end
	}

	public static function popItemWidth():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_item_width();
		#end
	}

	public static function setNextItemWidth(width:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_item_width(width);
		#end
	}

	public static function calcItemWidth():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_calc_item_width();
		#end
		return 0.0;
	}

	public static function pushTextWrapPos(wrapLocalPosX:Float = 0.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_text_wrap_pos(wrapLocalPosX);
		#end
	}

	public static function popTextWrapPos():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_text_wrap_pos();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Style read access
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getFontTexUVWhitePixel():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_font_tex_uv_white_pixel();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getStyleColor(idx:ImGuiCol, alphaMul:Float = 1.0):ImColor
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var col:ImColor = NativeCFFI.lime_imgui_get_color_u32(idx, alphaMul);
		//abgr (as argb) to argb
		//a bit confusing but it matches up
		var colAsInt:Int = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
		return new ImColor(colAsInt);
		#end
		return 0;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Layout cursor positioning
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getCursorScreenPos():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_cursor_screen_pos();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function setCursorScreenPos(x:Float, y:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_cursor_screen_pos(x, y);
		#end
	}

	public static function getContentRegionAvail():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_content_region_avail();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getCursorPos():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_cursor_pos();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function setCursorPos(x:Float, y:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_cursor_pos(x, y);
		#end
	}

	public static function getCursorStartPos():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_cursor_start_pos();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Other layout functions
	//////////////////////////////////////////////////////////////////////////////////////

	public static function separator():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_separator();
		#end
	}

	public static function sameLine(offsetStartX:Float = 0.0, spacing:Float = -1.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_sameline(offsetStartX, spacing);
		#end
	}

	public static function newLine():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_newline();
		#end
	}

	public static function spacing():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_spacing();
		#end
	}

	public static function dummy(width:Float, height:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_dummy(width, height);
		#end
	}

	public static function indent(indentWidth:Float = 0.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_indent(indentWidth);
		#end
	}

	public static function unindent(indentWidth:Float = 0.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_unindent(indentWidth);
		#end
	}

	public static function beginGroup():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_begin_group();
		#end
	}

	public static function endGroup():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_group();
		#end
	}

	public static function alignTextToFramePadding():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_align_text_to_frame_padding();
		#end
	}

	public static function getTextLineHeight():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_text_line_height();
		#end
		return 0.0;
	}

	public static function getTextLineHeightWithSpacing():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_text_line_height_with_spacing();
		#end
		return 0.0;
	}

	public static function getFrameHeight():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_frame_height();
		#end
		return 0.0;
	}

	public static function getFrameHeightWithSpacing():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_frame_height_with_spacing();
		#end
		return 0.0;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// ID stacks/scopes
	//////////////////////////////////////////////////////////////////////////////////////

	public static function pushIDFromStr(str_id:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_id_str(str_id);
		#end
	}

	public static function pushIDFromStr2(begin:String, end:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_id_str2(begin, end);
		#end
	}

	public static function pushIDFromInt(id:Int):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_id_int(id);
		#end
	}

	public static function popID():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_id();
		#end
	}

	public static function getIDFromStr(str_id:String):ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_id_str(str_id);
		#end
		return 0;
	}

	public static function getIDFromStr2(begin:String, end:String):ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_id_str2(begin, end);
		#end
		return 0;
	}

	public static function getIDFromInt(id:Int):ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_id_int(id);
		#end
		return 0;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Text widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function textUnformatted(text:String, ?textEnd:String = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_text_unformatted(text, textEnd);
		#end
	}

	public static function text(text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_text(Std.string(text));
		#end
	}

	public static function textColored(col:ImColor, text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var colAsInt:Int = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
		NativeCFFI.lime_imgui_text_colored(colAsInt, Std.string(text));
		#end
	}

	public static function textDisabled(text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_text_disabled(Std.string(text));
		#end
	}

	public static function textWrapped(text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_text_wrapped(Std.string(text));
		#end
	}

	public static function labelText(text:Dynamic, format:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_label_text(Std.string(text), format);
		#end
	}

	public static function bulletText(text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_bullet_text(Std.string(text));
		#end
	}

	public static function separatorText(text:Dynamic):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_separator_text(Std.string(text));
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Main widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function button(label:String, width:Float = 0, height:Float = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_button(label, width, height);
		#end
		return false;
	}

	public static function smallButton(label:String):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_small_button(label);
		#end
		return false;
	}

	public static function invisibleButton(label:String, width:Float = 0, height:Float = 0, flags:ImGuiButtonFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_invisible_button(label, width, height, flags);
		#end
		return false;
	}

	public static function arrowButton(label:String, dir:ImGuiDir):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_arrow_button(label, dir);
		#end
		return false;
	}

	public static function checkbox(label:String, v:ImGuiBoolPtr = null):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_checkbox(label, v != null ? v.ptr : null);
		#end
		return false;
	}

	public static function checkboxFlags(label:String, v:ImGuiIntPtr, flag:Int):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_checkbox_flags(label, v.ptr, flag);
		#end
		return false;
	}

	public static function radioButton(label:String, v:ImGuiIntPtr, buttonValue:Int):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_radio_button(label, v.ptr, buttonValue);
		#end
		return false;
	}

	public static function progressBar(fraction:Float, sizeX:Float = 0.0, sizeY:Float = 0.0, ?overlay:String = null):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_progress_bar(fraction, sizeX, sizeY, overlay);
		#end
	}

	public static function bullet():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_bullet();
		#end
	}

	public static function textLink(label:String):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_text_link(label);
		#end
		return false;
	}

	public static function textLinkOpenURL(label:String, url:String):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_text_link_open_url(label, url);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Image widgets
	//////////////////////////////////////////////////////////////////////////////////////

    public static function image(texID:ImTextureID, imageWidth:Float, imageHeight:Float, uvX:Float = 0.0, uvY:Float = 0.0, uvZ:Float = 1.0, uvW:Float = 1.0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        NativeCFFI.lime_imgui_image(texID, imageWidth, imageHeight, uvX, uvY, uvZ, uvW);
		#end
	}

	public static function imageWithBg(texID:ImTextureID, imageWidth:Float, imageHeight:Float, uvX:Float = 0.0, uvY:Float = 0.0, uvZ:Float = 1.0, uvW:Float = 1.0, bg_col:ImColor = 0x00000000, tint_col:ImColor = 0xFFFFFFFF):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var bgCol:Int = ((bg_col.a & 0xFF) << 24) | ((bg_col.b & 0xFF) << 16) | ((bg_col.g & 0xFF) << 8) | (bg_col.r & 0xFF);
		var tintCol:Int = ((tint_col.a & 0xFF) << 24) | ((tint_col.b & 0xFF) << 16) | ((tint_col.g & 0xFF) << 8) | (tint_col.r & 0xFF);
		NativeCFFI.lime_imgui_image_with_bg(texID, imageWidth, imageHeight, uvX, uvY, uvZ, uvW, bgCol, tintCol);
		#end
	}

	public static function imageButton(str_id:String, texID:ImTextureID, imageWidth:Float, imageHeight:Float, uvX:Float = 0.0, uvY:Float = 0.0, uvZ:Float = 1.0, uvW:Float = 1.0, bg_col:ImColor = 0x00000000, tint_col:ImColor = 0xFFFFFFFF):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var bgCol:Int = ((bg_col.a & 0xFF) << 24) | ((bg_col.b & 0xFF) << 16) | ((bg_col.g & 0xFF) << 8) | (bg_col.r & 0xFF);
		var tintCol:Int = ((tint_col.a & 0xFF) << 24) | ((tint_col.b & 0xFF) << 16) | ((tint_col.g & 0xFF) << 8) | (tint_col.r & 0xFF);
		return NativeCFFI.lime_imgui_image_button(str_id, texID, imageWidth, imageHeight, uvX, uvY, uvZ, uvW, bgCol, tintCol);
		#end
		return false;
	}
	//////////////////////////////////////////////////////////////////////////////////////
	// Combo box / drop down widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginCombo(label:String, preview_value:String, flags:ImGuiComboFlags):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_combo(label, preview_value, flags);
		#end
		return false;
	}

	public static function endCombo():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_combo();
		#end
	}

	public static function combo(label:String, currentIndex:ImGuiIntPtr, items:Array<String>, maxHeight:Int = -1):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (currentIndex == null) return false;
		return NativeCFFI.lime_imgui_combo(label, currentIndex.ptr, items, maxHeight);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// drag sliders
	//////////////////////////////////////////////////////////////////////////////////////

	public static function dragFloat(label:String, v:ImGuiFloatPtr, speed:Float = 1.0, min:Float = 0.0, max:Float = 0.0, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_float(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragFloat2(label:String, v:ImGuiFloat2Ptr, speed:Float = 1.0, min:Float = 0.0, max:Float = 0.0, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_float2(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragFloat3(label:String, v:ImGuiFloat3Ptr, speed:Float = 1.0, min:Float = 0.0, max:Float = 0.0, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_float3(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragFloat4(label:String, v:ImGuiFloat4Ptr, speed:Float = 1.0, min:Float = 0.0, max:Float = 0.0, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_float4(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragFloatRange2(label:String, currentMin:ImGuiFloatPtr, currentMax:ImGuiFloatPtr, speed:Float = 1.0, min:Float = 0.0, max:Float = 0.0, format:String = "%.3f", formatMax:String = null, flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (currentMin == null || currentMax == null) return false;
		return NativeCFFI.lime_imgui_drag_float_range2(label, currentMin.ptr, currentMax.ptr, speed, min, max, format, formatMax, flags);
		#end
		return false;
	}

	public static function dragInt(label:String, v:ImGuiIntPtr, speed:Float = 1.0, min:Int = 0, max:Int = 0, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_int(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragInt2(label:String, v:ImGuiInt2Ptr, speed:Float = 1.0, min:Int = 0, max:Int = 0, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_int2(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragInt3(label:String, v:ImGuiInt3Ptr, speed:Float = 1.0, min:Int = 0, max:Int = 0, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_int3(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragInt4(label:String, v:ImGuiInt4Ptr, speed:Float = 1.0, min:Int = 0, max:Int = 0, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_drag_int4(label, v.ptr, speed, min, max, format, flags);
		#end
		return false;
	}

	public static function dragIntRange2(label:String, currentMin:ImGuiIntPtr, currentMax:ImGuiIntPtr, speed:Float = 1.0, min:Int = 0, max:Int = 0, format:String = "%d", formatMax:String = null, flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (currentMin == null || currentMax == null) return false;
		return NativeCFFI.lime_imgui_drag_int_range2(label, currentMin.ptr, currentMax.ptr, speed, min, max, format, formatMax, flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// sliders
	//////////////////////////////////////////////////////////////////////////////////////

	public static function sliderFloat(label:String, v:ImGuiFloatPtr, min:Float, max:Float, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_float(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderFloat2(label:String, v:ImGuiFloat2Ptr, min:Float, max:Float, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_float2(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderFloat3(label:String, v:ImGuiFloat3Ptr, min:Float, max:Float, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_float3(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderFloat4(label:String, v:ImGuiFloat4Ptr, min:Float, max:Float, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_float4(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderAngle(label:String, vRad:ImGuiFloatPtr, minDegrees:Float = -360, maxDegrees:Float = 360, format:String = "%.0f deg", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (vRad == null) return false;
		return NativeCFFI.lime_imgui_slider_angle(label, vRad.ptr, minDegrees, maxDegrees, format, flags);
		#end
		return false;
	}

	public static function sliderInt(label:String, v:ImGuiIntPtr, min:Int, max:Int, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_int(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderInt2(label:String, v:ImGuiInt2Ptr, min:Int, max:Int, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_int2(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderInt3(label:String, v:ImGuiInt3Ptr, min:Int, max:Int, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_int3(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function sliderInt4(label:String, v:ImGuiInt4Ptr, min:Int, max:Int, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_slider_int4(label, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function verticalSliderFloat(label:String, width:Float, height:Float, v:ImGuiFloatPtr, min:Float, max:Float, format:String = "%.3f", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_vslider_float(label, width, height, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	public static function verticalSliderInt(label:String, width:Float, height:Float, v:ImGuiIntPtr, min:Int, max:Int, format:String = "%d", flags:ImGuiSliderFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_vslider_int(label, width, height, v.ptr, min, max, format, flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// input widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function inputText(label:String, str:ImGuiStringPtr, flags:ImGuiInputTextFlags = 0, callback:ImGuiInputTextCallback = null):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (str == null) return false;
		return NativeCFFI.lime_imgui_input_text(label, str.ptr, flags, callback != null ? callback.ptr : null);
		#end
		return false;
	}

	public static function inputTextMultiline(label:String, str:ImGuiStringPtr, width:Float, height:Float, flags:ImGuiInputTextFlags = 0, callback:ImGuiInputTextCallback = null):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (str == null) return false;
		return NativeCFFI.lime_imgui_input_multiline(label, str.ptr, width, height, flags, callback != null ? callback.ptr : null);
		#end
		return false;
	}

	public static function inputTextWithHint(label:String, hint:String, str:ImGuiStringPtr, flags:ImGuiInputTextFlags = 0, callback:ImGuiInputTextCallback = null):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (str == null) return false;
		return NativeCFFI.lime_imgui_input_text_with_hint(label, hint, str.ptr, flags, callback != null ? callback.ptr : null);
		#end
		return false;
	}

	public static function inputFloat(label:String, v:ImGuiFloatPtr, step:Float = 0.0, stepFast:Float = 0.0, format:String = "%.3f", flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_float(label, v.ptr, step, stepFast, format, flags);
		#end
		return false;
	}

	public static function inputFloat2(label:String, v:ImGuiFloat2Ptr, format:String = "%.3f", flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_float2(label, v.ptr, format, flags);
		#end
		return false;
	}

	public static function inputFloat3(label:String, v:ImGuiFloat3Ptr, format:String = "%.3f", flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_float3(label, v.ptr, format, flags);
		#end
		return false;
	}

	public static function inputFloat4(label:String, v:ImGuiFloat4Ptr, format:String = "%.3f", flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_float4(label, v.ptr, format, flags);
		#end
		return false;
	}

	public static function inputInt(label:String, v:ImGuiIntPtr, step:Int = 1, stepFast:Int = 100, flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_int(label, v.ptr, step, stepFast, flags);
		#end
		return false;
	}

	public static function inputInt2(label:String, v:ImGuiInt2Ptr, flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_int2(label, v.ptr, flags);
		#end
		return false;
	}

	public static function inputInt3(label:String, v:ImGuiInt3Ptr, flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_int3(label, v.ptr, flags);
		#end
		return false;
	}

	public static function inputInt4(label:String, v:ImGuiInt4Ptr, flags:ImGuiInputTextFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_input_int4(label, v.ptr, flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// color pickers/editors
	//////////////////////////////////////////////////////////////////////////////////////

	public static function colorEdit3(label:String, v:ImGuiFloat3Ptr, flags:ImGuiColorEditFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_color_edit3(label, v.ptr, flags);
		#end
		return false;
	}

	public static function colorEdit4(label:String, v:ImGuiFloat4Ptr, flags:ImGuiColorEditFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_color_edit4(label, v.ptr, flags);
		#end
		return false;
	}

	public static function colorPicker3(label:String, v:ImGuiFloat3Ptr, flags:ImGuiColorEditFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_color_picker3(label, v.ptr, flags);
		#end
		return false;
	}

	public static function colorPicker4(label:String, v:ImGuiFloat4Ptr, flags:ImGuiColorEditFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (v == null) return false;
		return NativeCFFI.lime_imgui_color_picker4(label, v.ptr, flags);
		#end
		return false;
	}

	public static function colorButton(descID:String, col:ImColor, flags:ImGuiColorEditFlags = 0, width:Float = 0.0, height:Float = 0.0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var colAsInt:Int = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
		return NativeCFFI.lime_imgui_color_button(descID, colAsInt, flags, width, height);
		#end
		return false;
	}

	public static function setColorEditOptions(flags:ImGuiColorEditFlags):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_color_edit_options(flags);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Tree widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function treeNode(str_id:String, fmt:String):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_tree_node(str_id, fmt);
		#end
		return false;
	}

	public static function treeNodeEx(str_id:String, flags:ImGuiTreeNodeFlags, fmt:String):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_tree_node_ex(str_id, flags, fmt);
		#end
		return false;
	}

	public static function treePush(str_id:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_tree_push(str_id);
		#end
	}

	public static function treePop():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_tree_pop();
		#end
	}

	public static function getTreeNodeToLabelSpacing():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_tree_node_to_label_spacing();
		#end
		return 0;
	}

	public static function collapsingHeader(label:String, p_visible:ImGuiBoolPtr = null, flags:ImGuiTreeNodeFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_collapsing_header(label, p_visible != null ? p_visible.ptr : null, flags);
		#end
		return false;
	}

	public static function setNextItemOpen(is_open:Bool, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_item_open(is_open, cond);
		#end
	}

	public static function setNextItemStorageID(storage_id:ImGuiID):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_item_storage_id(storage_id);
		#end
	}

	public static function treeNodeGetOpen(storage_id:ImGuiID):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_tree_node_get_open(storage_id);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Selectables
	//////////////////////////////////////////////////////////////////////////////////////

	public static function selectable(label:String, selected:Bool):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_selectable(label, selected);
		#end
		return false;
	}

	public static function selectableWithPtr(label:String, p_selected:ImGuiBoolPtr, flags:ImGuiSelectableFlags):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_selectable_with_ptr(label, p_selected != null ? p_selected.ptr : null, flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// List box widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginListBox(label:String, sizeX:Float = 0, sizeY:Float = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_list_box(label, sizeX, sizeY);
		#end
		return false;
	}

	public static function endListBox():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_list_box();
		#end
	}

	public static function listBox(label:String, current_item:ImGuiIntPtr, items:Array<String>, height_in_items:Int = -1):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (current_item == null) return false;
		return NativeCFFI.lime_imgui_list_box(label, current_item.ptr, items, height_in_items);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Data plotting widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function plotLines(label:String, values:Array<Float>, values_count:Int, values_offset:Int = 0, ?overlay_text:String = null, scale_min:Float = ImGui.FLOAT_MAX, scale_max:Float = ImGui.FLOAT_MAX, graph_sizeX:Float = 0, graph_sizeY:Float = 0, stride:Int = 4):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_plot_lines(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_sizeX, graph_sizeY, stride);
		#end
	}

	public static function plotHistogram(label:String, values:Array<Float>, values_count:Int, values_offset:Int = 0, ?overlay_text:String = null, scale_min:Float = ImGui.FLOAT_MAX, scale_max:Float = ImGui.FLOAT_MAX, graph_sizeX:Float = 0, graph_sizeY:Float = 0, stride:Int = 4):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_plot_histogram(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_sizeX, graph_sizeY, stride);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Menu widgets
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginMenuBar():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_menu_bar();
		#end
		return false;
	}

	public static function endMenuBar():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_menu_bar();
		#end
	}

	public static function beginMainMenuBar():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_main_menu_bar();
		#end
		return false;
	}

	public static function endMainMenuBar():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_main_menu_bar();
		#end
	}

	public static function beginMenu(label:String, enabled:Bool = true):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_menu(label, enabled);
		#end
		return false;
	}

	public static function endMenu():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_menu();
		#end
	}

	public static function menuItem(label:String, ?shortcut:String = null, selected:Bool = false, enabled:Bool = true):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_menu_item(label, shortcut, selected, enabled);
		#end
		return false;
	}

	public static function menuItemWithToggle(label:String, ?shortcut:String = null, p_selected:ImGuiBoolPtr, enabled:Bool = true):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (p_selected == null) return false;
		return NativeCFFI.lime_imgui_menu_item_with_toggle(label, shortcut, p_selected.ptr, enabled);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Tooltips
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginTooltip():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_tooltip();
		#end
		return false;
	}

	public static function endTooltip():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_tooltip();
		#end
	}

	public static function setTooltip(fmt:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_tooltip(fmt);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Tooltip helpers
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginItemTooltip():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_item_tooltip();
		#end
		return false;
	}

	public static function setItemTooltip(fmt:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_item_tooltip(fmt);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Popups and modals
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginPopup(str_id:String, flags:ImGuiWindowFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_popup(str_id, flags);
		#end
		return false;
	}

	public static function beginPopupModal(name:String, p_open:ImGuiBoolPtr = null, flags:ImGuiWindowFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_popup_modal(name, p_open != null ? p_open.ptr : null, flags);
		#end
		return false;
	}

	public static function endPopup():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_popup();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Popups open/close
	//////////////////////////////////////////////////////////////////////////////////////

	public static function openPopup(str_id:String, popup_flags:ImGuiPopupFlags = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_open_popup(str_id, popup_flags);
		#end
	}

	public static function openPopupOnItemClick(str_id:String, popup_flags:ImGuiPopupFlags = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_open_popup_on_item_click(str_id, popup_flags);
		#end
	}

	public static function closeCurrentPopup():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_close_current_popup();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Popups open+begin helpers
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginPopupContextItem(str_id:String, popup_flags:ImGuiPopupFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_popup_context_item(str_id, popup_flags);
		#end
		return false;
	}

	public static function beginPopupContextWindow(str_id:String, popup_flags:ImGuiPopupFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_popup_context_window(str_id, popup_flags);
		#end
		return false;
	}

	public static function beginPopupContextVoid(str_id:String, popup_flags:ImGuiPopupFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_popup_context_void(str_id, popup_flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Popups query functions
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isPopupOpen(str_id:String, flags:ImGuiPopupFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_popup_open(str_id, flags);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Tables
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginTable(str_id:String, columns:Int, flags:ImGuiTableFlags = 0, outer_sizeX:Float = 0, outer_sizeY:Float = 0, inner_width:Float = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_table(str_id, columns, flags, outer_sizeX, outer_sizeY, inner_width);
		#end
		return false;
	}

	public static function endTable():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_table();
		#end
	}

	public static function tableNextRow(row_flags:ImGuiTableRowFlags = 0, min_row_height:Float = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_next_row(row_flags, min_row_height);
		#end
	}

	public static function tableNextColumn():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_next_column();
		#end
		return false;
	}

	public static function tableSetColumnIndex(column_n:Int):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_set_column_index(column_n);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Table headers and columns
	//////////////////////////////////////////////////////////////////////////////////////

	public static function tableSetupColumn(label:String, flags:ImGuiTableColumnFlags = 0, init_width_or_weight:Float = 0, user_id:ImGuiID = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_setup_column(label, flags, init_width_or_weight, user_id);
		#end
	}

	public static function tableSetupScrollFreeze(cols:Int, rows:Int):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_setup_scroll_freeze(cols, rows);
		#end
	}

	public static function tableHeader(label:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_header(label);
		#end
	}

	public static function tableHeadersRow():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_headers_row();
		#end
	}

	public static function tableAngledHeadersRow():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_angled_headers_row();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Table sorting and misc
	//////////////////////////////////////////////////////////////////////////////////////

	public static function tableGetSortSpecs():ImGuiTableSortSpecs
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImGuiTableSortSpecs(NativeCFFI.lime_imgui_table_get_sort_specs());
		#end
		return new ImGuiTableSortSpecs(0);
	}

	public static function tableGetColumnCount():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_column_count();
		#end
		return 0;
	}

	public static function tableGetColumnIndex():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_column_index();
		#end
		return 0;
	}

	public static function tableGetRowIndex():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_row_index();
		#end
		return 0;
	}

	public static function tableGetColumnName(column_n:Int = -1):String
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_column_name(column_n);
		#end
		return "";
	}

	public static function tableGetColumnFlags(column_n:Int = -1):ImGuiTableColumnFlags
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_column_flags(column_n);
		#end
		return 0;
	}

	public static function tableSetColumnEnabled(column_n:Int, v:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_table_set_column_enabled(column_n, v);
		#end
	}

	public static function tableGetHoveredColumn():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_table_get_hovered_column();
		#end
		return 0;
	}

	public static function tableSetBgColor(target:ImGuiTableBgTarget, col:ImColor, column_n:Int = -1):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var colAsInt:Int = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
		NativeCFFI.lime_imgui_table_set_bg_color(target, colAsInt, column_n);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Legacy columns
	//////////////////////////////////////////////////////////////////////////////////////

	public static function columns(count:Int = 1, ?id:String = null, borders:Bool = true):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_columns(count, id, borders);
		#end
	}

	public static function nextColumn():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_next_column();
		#end
	}

	public static function getColumnIndex():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_column_index();
		#end
		return 0;
	}

	public static function getColumnWidth(column_index:Int = -1):Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_column_width(column_index);
		#end
		return 0;
	}

	public static function setColumnWidth(column_index:Int, width:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_column_width(column_index, width);
		#end
	}

	public static function getColumnOffset(column_index:Int = -1):Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_column_offset(column_index);
		#end
		return 0;
	}

	public static function setColumnOffset(column_index:Int, offset_x:Float):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_column_offset(column_index, offset_x);
		#end
	}

	public static function getColumnsCount():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_columns_count();
		#end
		return 0;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Tab bars and tabs
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginTabBar(str_id:String, flags:ImGuiTabBarFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_tab_bar(str_id, flags);
		#end
		return false;
	}

	public static function endTabBar():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_tab_bar();
		#end
	}

	public static function beginTabItem(label:String, ?p_open:ImGuiBoolPtr = null, flags:ImGuiTabItemFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_tab_item(label, p_open != null ? p_open.ptr : null, flags);
		#end
		return false;
	}

	public static function endTabItem():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_tab_item();
		#end
	}

	public static function tabItemButton(label:String, flags:ImGuiTabItemFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_tab_item_button(label, flags);
		#end
		return false;
	}

	public static function setTabItemClosed(tab_or_docked_window_label:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_tab_item_closed(tab_or_docked_window_label);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Docking
	//////////////////////////////////////////////////////////////////////////////////////

	public static function dockSpace(dockspace_id:ImGuiID, sizeX:Float = 0, sizeY:Float = 0, flags:ImGuiDockNodeFlags = 0):ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_dock_space(dockspace_id, sizeX, sizeY, flags);
		#end
		return 0;
	}

	public static function dockSpaceOverViewport(dockspace_id:ImGuiID, ?viewport:ImGuiViewport = null, flags:ImGuiDockNodeFlags = 0):ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_dock_space_over_viewport(dockspace_id, viewport != null && viewport.isValid() ? viewport.handle : 0.0, flags);
		#end
		return 0;
	}

	public static function setNextWindowDockID(dock_id:ImGuiID, cond:ImGuiCond = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_window_dock_id(dock_id, cond);
		#end
	}

	public static function getWindowDockID():ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_window_dock_id();
		#end
		return 0;
	}

	public static function isWindowDocked():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_window_docked();
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Logging
	//////////////////////////////////////////////////////////////////////////////////////



	//////////////////////////////////////////////////////////////////////////////////////
	// Drag and drop
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginDragDropSource(flags:ImGuiDragDropFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_drag_drop_source(flags);
		#end
		return false;
	}

	public static function setDragDropPayload(payload:ImGuiPayload, cond:ImGuiCond = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_set_drag_drop_payload(payload.type, payload.serialize(), cond);
		#end
		return false;
	}

	public static function endDragDropSource():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_drag_drop_source();
		#end
	}

	public static function beginDragDropTarget():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_begin_drag_drop_target();
		#end
		return false;
	}

	public static function acceptDragDropPayload(type:String, flags:ImGuiDragDropFlags = 0):ImGuiPayload
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var ret = NativeCFFI.lime_imgui_accept_drag_drop_payload(type, flags);
		if (ret == null || ret == "") return null;
		var payload = new ImGuiPayload(type, null);
		payload.deserialize(ret);
		return payload;
		#end
		return null;
	}

	public static function endDragDropTarget():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_drag_drop_target();
		#end
	}

	public static function getDragDropPayload():ImGuiPayload
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var ret = NativeCFFI.lime_imgui_get_drag_drop_payload();
		if (ret == "") return null;
		var payload = new ImGuiPayload("", null); //TODO: rework so it returns the type
		payload.deserialize(ret);
		return payload;
		#end
		return null;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Disabling
	//////////////////////////////////////////////////////////////////////////////////////

	public static function beginDisabled(disabled:Bool = true):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_begin_disabled(disabled);
		#end
	}

	public static function endDisabled():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_end_disabled();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Clipping
	//////////////////////////////////////////////////////////////////////////////////////

	public static function pushClipRect(clip_rect_minX:Float, clip_rect_minY:Float, clip_rect_maxX:Float, clip_rect_maxY:Float, intersect_with_current_clip_rect:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_push_clip_rect(clip_rect_minX, clip_rect_minY, clip_rect_maxX, clip_rect_maxY, intersect_with_current_clip_rect);
		#end
	}

	public static function popClipRect():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_pop_clip_rect();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Focus
	//////////////////////////////////////////////////////////////////////////////////////

	public static function setItemDefaultFocus():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_item_default_focus();
		#end
	}

	public static function setKeyboardFocusHere(offset:Int = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_keyboard_focus_here(offset);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Keyboard/gamepad navigation
	//////////////////////////////////////////////////////////////////////////////////////

	public static function setNavCursorVisible(visible:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_nav_cursor_visible(visible);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Overlapping mode
	//////////////////////////////////////////////////////////////////////////////////////

	public static function setNextItemAllowOverlap():Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_item_allow_overlap();
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Item/widget utils and query funcs
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isItemHovered(flags:ImGuiHoveredFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_hovered(flags);
		#end
		return false;
	}

	public static function isItemActive():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_active();
		#end
		return false;
	}

	public static function isItemFocused():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_focused();
		#end
		return false;
	}

	public static function isItemClicked(mouse_button:ImGuiMouseButton = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_clicked(mouse_button);
		#end
		return false;
	}

	public static function isItemVisible():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_visible();
		#end
		return false;
	}

	public static function isItemEdited():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_edited();
		#end
		return false;
	}

	public static function isItemActivated():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_activated();
		#end
		return false;
	}

	public static function isItemDeactivated():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_deactivated();
		#end
		return false;
	}

	public static function isItemDeactivatedAfterEdit():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_deactivated_after_edit();
		#end
		return false;
	}

	public static function isItemToggledOpen():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_item_toggled_open();
		#end
		return false;
	}

	public static function isAnyItemHovered():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_any_item_hovered();
		#end
		return false;
	}

	public static function isAnyItemActive():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_any_item_active();
		#end
		return false;
	}

	public static function isAnyItemFocused():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_any_item_focused();
		#end
		return false;
	}

	public static function getItemID():ImGuiID
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_item_id();
		#end
		return 0;
	}

	public static function getItemRectMin():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_item_rect_min();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getItemRectMax():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_item_rect_max();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getItemRectSize():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_item_rect_size();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getItemFlags():ImGuiItemFlags
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_item_flags();
		#end
		return 0;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Viewports
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getMainViewport():ImGuiViewport
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImGuiViewport(NativeCFFI.lime_imgui_get_main_viewport());
		#end
		return new ImGuiViewport(0.0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Draw Lists
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getBackgroundDrawList(?viewport:ImGuiViewport):ImDrawList
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImDrawList(NativeCFFI.lime_imgui_get_background_draw_list(viewport != null ? viewport.handle : 0.0));
		#end
		return new ImDrawList(0.0);
	}

	public static function getForegroundDrawList(?viewport:ImGuiViewport):ImDrawList
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImDrawList(NativeCFFI.lime_imgui_get_foreground_draw_list(viewport != null ? viewport.handle : 0.0));
		#end
		return new ImDrawList(0.0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Misc utils
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isRectVisible(rect_minX:Float, rect_minY:Float, rect_maxX:Float, rect_maxY:Float):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_rect_visible(rect_minX, rect_minY, rect_maxX, rect_maxY);
		#end
		return false;
	}

	public static function getTime():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_time();
		#end
		return 0;
	}

	public static function getFrameCount():Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_frame_count();
		#end
		return 0;
	}

	public static function setStateStorage(storage:ImGuiStorage):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		if (!storage.isValid()) return;
		NativeCFFI.lime_imgui_set_state_storage(storage.handle);
		#end
	}

	public static function getStateStorage():ImGuiStorage
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return new ImGuiStorage(NativeCFFI.lime_imgui_get_state_storage());
		#end
		return new ImGuiStorage(0.0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Text utils
	//////////////////////////////////////////////////////////////////////////////////////

	public static function calcTextSize(text:String, ?text_end:String = null, hide_text_after_double_hash:Bool = false, wrap_width:Float = -1.0):ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_calc_text_size(text, text_end, hide_text_after_double_hash, wrap_width);
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Color utils
	//////////////////////////////////////////////////////////////////////////////////////

	//not sure if these are needed?

	//////////////////////////////////////////////////////////////////////////////////////
	// Input utils (raw)
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isKeyDown(key:ImGuiKey):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_key_down(key);
		#end
		return false;
	}

	public static function isKeyPressed(key:ImGuiKey, repeat:Bool = true):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_key_pressed(key, repeat);
		#end
		return false;
	}

	public static function isKeyReleased(key:ImGuiKey):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_key_released(key);
		#end
		return false;
	}

	public static function isKeyChordPressed(key_chord:ImGuiKeyChord):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_key_chord_pressed(key_chord);
		#end
		return false;
	}

	public static function getKeyPressedAmount(key:ImGuiKey, repeat_delay:Float, rate:Float):Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_key_pressed_amount(key, repeat_delay, rate);
		#end
		return 0;
	}

	public static function getKeyName(key:ImGuiKey):String
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_key_name(key);
		#end
		return "";
	}

	public static function setNextFrameWantCaptureKeyboard(want_capture_keyboard:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_frame_want_capture_keyboard(want_capture_keyboard);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Input utils (shortcuts)
	//////////////////////////////////////////////////////////////////////////////////////

	public static function shortcut(key_chord:ImGuiKeyChord, flags:ImGuiInputFlags = 0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_shortcut(key_chord, flags);
		#end
		return false;
	}

	public static function setNextItemShortcut(key_chord:ImGuiKeyChord, flags:ImGuiInputFlags = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_item_shortcut(key_chord, flags);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Input utils (key/input ownership)
	//////////////////////////////////////////////////////////////////////////////////////

	public static function setItemKeyOwner(key:ImGuiKey):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_set_item_key_owner(key);
		#end
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Input utils (mouse)
	//////////////////////////////////////////////////////////////////////////////////////

	public static function isMouseDown(button:ImGuiMouseButton):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_down(button);
		#end
		return false;
	}

	public static function isMouseClicked(button:ImGuiMouseButton, repeat:Bool = false):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_clicked(button, repeat);
		#end
		return false;
	}

	public static function isMouseReleased(button:ImGuiMouseButton):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_released(button);
		#end
		return false;
	}

	public static function isMouseDoubleClicked(button:ImGuiMouseButton):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_double_clicked(button);
		#end
		return false;
	}

	public static function isMouseReleasedWithDelay(button:ImGuiMouseButton, delay:Float):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_released_with_delay(button, delay);
		#end
		return false;
	}

	public static function getMouseClickedCount(button:ImGuiMouseButton):Int
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_mouse_clicked_count(button);
		#end
		return 0;
	}

	public static function isMouseHoveringRect(r_minX:Float, r_minY:Float, r_maxX:Float, r_maxY:Float, clip:Bool = true):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_hovering_rect(r_minX, r_minY, r_maxX, r_maxY, clip);
		#end
		return false;
	}

	public static function isMousePosValid(posX:Float, posY:Float):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_pos_valid(posX, posY);
		#end
		return false;
	}

	public static function getMousePos():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_mouse_pos();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function getMousePosOnOpeningCurrentPopup():ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_mouse_pos_on_opening_current_popup();
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function isMouseDragging(button:ImGuiMouseButton, lock_threshold:Float = -1.0):Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_is_mouse_dragging(button, lock_threshold);
		#end
		return false;
	}

	public static function getMouseDragDelta(button:ImGuiMouseButton, lock_threshold:Float = -1.0):ImVec2
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		var vec:Dynamic = NativeCFFI.lime_imgui_get_mouse_drag_delta(button, lock_threshold);
		return new ImVec2(vec.x, vec.y);
		#end
		return null;
	}

	public static function resetMouseDragDelta(button:ImGuiMouseButton = 0):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_reset_mouse_drag_delta(button);
		#end
	}

	public static function getMouseCursor():ImGuiMouseCursor
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_mouse_cursor();
		#end
		return 0;
	}

	public static function setMouseCursor(cursor_type:ImGuiMouseCursor):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_mouse_cursor(cursor_type);
		#end
	}

	public static function setNextFrameWantCaptureMouse(want_capture_mouse:Bool):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_next_frame_want_capture_mouse(want_capture_mouse);
		#end
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Clipboard utils
	//////////////////////////////////////////////////////////////////////////////////////

	public static function getClipboardText():String
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_get_clipboard_text();
		#end
		return "";
	}

	public static function setClipboardText(text:String):Void
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		NativeCFFI.lime_imgui_set_clipboard_text(text);
		#end
	}
}
#end