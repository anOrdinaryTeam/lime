package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImFont;
import lime.tools.imgui.ImGuiFlags;
import lime.tools.imgui.ImGuiTypes;

import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiIO
{
    public static var configFlags(get, set):ImGuiConfigFlags;
    public static var backendFlags(get, set):ImGuiBackendFlags;
    public static var displaySizeX(get, set):Float;
    public static var displaySizeY(get, set):Float;
    public static var displayFramebufferScaleX(get, set):Float;
    public static var displayFramebufferScaleY(get, set):Float;
    public static var deltaTime(get, set):Float;
    public static var iniSavingRate(get, set):Float;
    public static var iniFilename(get, set):String;
    public static var logFilename(get, set):String;
    public static var fonts(get, null):ImFontAtlas;
    public static var fontDefault(get, set):ImFont;
    public static var fontAllowUserScaling(get, set):Bool;
    public static var configNavSwapGamepadButtons(get, set):Bool;
    public static var configNavMoveSetMousePos(get, set):Bool;
    public static var configNavCaptureKeyboard(get, set):Bool;
    public static var configNavEscapeClearFocusItem(get, set):Bool;
    public static var configNavEscapeClearFocusWindow(get, set):Bool;
    public static var configNavCursorVisibleAuto(get, set):Bool;
    public static var configNavCursorVisibleAlways(get, set):Bool;
    public static var configDockingNoSplit(get, set):Bool;
    public static var configDockingNoDockingOver(get, set):Bool;
    public static var configDockingWithShift(get, set):Bool;
    public static var configDockingAlwaysTabBar(get, set):Bool;
    public static var configDockingTransparentPayload(get, set):Bool;
    public static var configViewportsNoAutoMerge(get, set):Bool;
    public static var configViewportsNoTaskBarIcon(get, set):Bool;
    public static var configViewportsNoDecoration(get, set):Bool;
    public static var configViewportsNoDefaultParent(get, set):Bool;
    public static var configViewportsPlatformFocusSetsImGuiFocus(get, set):Bool;
    public static var configDpiScaleFonts(get, set):Bool;
    public static var configDpiScaleViewports(get, set):Bool;
    public static var mouseDrawCursor(get, set):Bool;
    public static var configMacOSXBehaviors(get, set):Bool;
    public static var configInputTextCursorBlink(get, set):Bool;
    public static var configInputTextEnterKeepActive(get, set):Bool;
    public static var configDragClickToInputText(get, set):Bool;
    public static var configWindowsResizeFromEdges(get, set):Bool;
    public static var configWindowsMoveFromTitleBarOnly(get, set):Bool;
    public static var configWindowsCopyContentsWithCtrlC(get, set):Bool;
    public static var configScrollbarScrollByPage(get, set):Bool;
    public static var configMemoryCompactTimer(get, set):Float;
    public static var mouseDoubleClickTime(get, set):Float;
    public static var mouseDoubleClickMaxDist(get, set):Float;
    public static var mouseDragThreshold(get, set):Float;
    public static var keyRepeatDelay(get, set):Float;
    public static var keyRepeatRate(get, set):Float;
    public static var configErrorRecovery(get, set):Bool;
    public static var configErrorRecoveryEnableAssert(get, set):Bool;
    public static var configErrorRecoveryEnableDebugLog(get, set):Bool;
    public static var configErrorRecoveryEnableTooltip(get, set):Bool;
    public static var configDebugIsDebuggerPresent(get, set):Bool;
    public static var configDebugHighlightIdConflicts(get, set):Bool;
    public static var configDebugHighlightIdConflictsShowItemPicker(get, set):Bool;
    public static var configDebugBeginReturnValueOnce(get, set):Bool;
    public static var configDebugBeginReturnValueLoop(get, set):Bool;
    public static var configDebugIgnoreFocusLoss(get, set):Bool;
    public static var configDebugIniSettings(get, set):Bool;
    public static var wantCaptureMouse(get, set):Bool;
    public static var wantCaptureKeyboard(get, set):Bool;
    public static var wantTextInput(get, set):Bool;
    public static var wantSetMousePos(get, set):Bool;
    public static var wantSaveIniSettings(get, set):Bool;
    public static var navActive(get, set):Bool;
    public static var navVisible(get, set):Bool;
    public static var framerate(get, set):Float;
    public static var metricsRenderVertices(get, set):Int;
    public static var metricsRenderIndices(get, set):Int;
    public static var metricsRenderWindows(get, set):Int;
    public static var metricsActiveWindows(get, set):Int;
    public static var mouseDeltaX(get, set):Float;
    public static var mouseDeltaY(get, set):Float;
	public static var mousePosX(get, null):Float;
	public static var mousePosY(get, null):Float;
	public static var mouseDown0(get, null):Bool;
	public static var mouseDown1(get, null):Bool;
	public static var mouseDown2(get, null):Bool;
	public static var mouseDown3(get, null):Bool;
	public static var mouseDown4(get, null):Bool;
	public static var mouseWheel(get, null):Float;
	public static var mouseWheelH(get, null):Float;
	public static var mouseSource(get, null):Int;
	public static var keyCtrl(get, null):Bool;
	public static var keyShift(get, null):Bool;
	public static var keyAlt(get, null):Bool;
	public static var keySuper(get, null):Bool;

    private static function get_configFlags():ImGuiConfigFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_flags();
        #end
        return 0;
    }
    private static function set_configFlags(ConfigFlags:ImGuiConfigFlags):ImGuiConfigFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_flags(ConfigFlags);
        #end
        return 0;
    }
    private static function get_backendFlags():ImGuiBackendFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_backend_flags();
        #end
        return 0;
    }
    private static function set_backendFlags(BackendFlags:ImGuiBackendFlags):ImGuiBackendFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_backend_flags(BackendFlags);
        #end
        return 0;
    }
    private static function get_displaySizeX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_display_size_x();
        #end
        return 0;
    }
    private static function set_displaySizeX(DisplaySizeX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_display_size_x(DisplaySizeX);
        #end
        return 0;
    }
    private static function get_displaySizeY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_display_size_y();
        #end
        return 0;
    }
    private static function set_displaySizeY(DisplaySizeY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_display_size_y(DisplaySizeY);
        #end
        return 0;
    }
    private static function get_displayFramebufferScaleX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_display_framebuffer_scale_x();
        #end
        return 0;
    }
    private static function set_displayFramebufferScaleX(DisplayFramebufferScaleX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_display_framebuffer_scale_x(DisplayFramebufferScaleX);
        #end
        return 0;
    }
    private static function get_displayFramebufferScaleY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_display_framebuffer_scale_y();
        #end
        return 0;
    }
    private static function set_displayFramebufferScaleY(DisplayFramebufferScaleY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_display_framebuffer_scale_y(DisplayFramebufferScaleY);
        #end
        return 0;
    }
    private static function get_deltaTime():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_delta_time();
        #end
        return 0;
    }
    private static function set_deltaTime(DeltaTime:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_delta_time(DeltaTime);
        #end
        return 0;
    }
    private static function get_iniSavingRate():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_ini_saving_rate();
        #end
        return 0;
    }
    private static function set_iniSavingRate(IniSavingRate:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_ini_saving_rate(IniSavingRate);
        #end
        return 0;
    }
    private static function get_iniFilename():String
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_ini_filename();
        #end
        return "";
    }
    private static function set_iniFilename(IniFilename:String):String
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_ini_filename(IniFilename);
        #end
        return "";
    }
    private static function get_logFilename():String
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_log_filename();
        #end
        return "0";
    }
    private static function set_logFilename(LogFilename:String):String
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_log_filename(LogFilename);
        #end
        return "0";
    }
    private static function get_fonts():ImFontAtlas
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return new ImFontAtlas(NativeCFFI.lime_imgui_io_get_fonts());
        #end
        return new ImFontAtlas(0);
    }
    /*private static function set_fonts(Fonts:ImFontAtlas*):ImFontAtlas*
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_fonts(Fonts);
        #end
        return 0;
    }*/
    private static function get_fontDefault():ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return new ImFont(NativeCFFI.lime_imgui_io_get_font_default());
        #end
        return new ImFont(0);
    }
    private static function set_fontDefault(?font:ImFont = null):ImFont
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        @:privateAccess
        return new ImFont(NativeCFFI.lime_imgui_io_set_font_default(font != null ? font.handle : 0));
        #end
        return new ImFont(0);
    }
    private static function get_fontAllowUserScaling():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_font_allow_user_scaling();
        #end
        return false;
    }
    private static function set_fontAllowUserScaling(FontAllowUserScaling:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_font_allow_user_scaling(FontAllowUserScaling);
        #end
        return false;
    }
    private static function get_configNavSwapGamepadButtons():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_swap_gamepad_buttons();
        #end
        return false;
    }
    private static function set_configNavSwapGamepadButtons(ConfigNavSwapGamepadButtons:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_swap_gamepad_buttons(ConfigNavSwapGamepadButtons);
        #end
        return false;
    }
    private static function get_configNavMoveSetMousePos():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_move_set_mouse_pos();
        #end
        return false;
    }
    private static function set_configNavMoveSetMousePos(ConfigNavMoveSetMousePos:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_move_set_mouse_pos(ConfigNavMoveSetMousePos);
        #end
        return false;
    }
    private static function get_configNavCaptureKeyboard():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_capture_keyboard();
        #end
        return false;
    }
    private static function set_configNavCaptureKeyboard(ConfigNavCaptureKeyboard:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_capture_keyboard(ConfigNavCaptureKeyboard);
        #end
        return false;
    }
    private static function get_configNavEscapeClearFocusItem():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_escape_clear_focus_item();
        #end
        return false;
    }
    private static function set_configNavEscapeClearFocusItem(ConfigNavEscapeClearFocusItem:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_escape_clear_focus_item(ConfigNavEscapeClearFocusItem);
        #end
        return false;
    }
    private static function get_configNavEscapeClearFocusWindow():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_escape_clear_focus_window();
        #end
        return false;
    }
    private static function set_configNavEscapeClearFocusWindow(ConfigNavEscapeClearFocusWindow:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_escape_clear_focus_window(ConfigNavEscapeClearFocusWindow);
        #end
        return false;
    }
    private static function get_configNavCursorVisibleAuto():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_cursor_visible_auto();
        #end
        return false;
    }
    private static function set_configNavCursorVisibleAuto(ConfigNavCursorVisibleAuto:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_cursor_visible_auto(ConfigNavCursorVisibleAuto);
        #end
        return false;
    }
    private static function get_configNavCursorVisibleAlways():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_nav_cursor_visible_always();
        #end
        return false;
    }
    private static function set_configNavCursorVisibleAlways(ConfigNavCursorVisibleAlways:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_nav_cursor_visible_always(ConfigNavCursorVisibleAlways);
        #end
        return false;
    }
    private static function get_configDockingNoSplit():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_docking_no_split();
        #end
        return false;
    }
    private static function set_configDockingNoSplit(ConfigDockingNoSplit:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_docking_no_split(ConfigDockingNoSplit);
        #end
        return false;
    }
    private static function get_configDockingNoDockingOver():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_docking_no_docking_over();
        #end
        return false;
    }
    private static function set_configDockingNoDockingOver(ConfigDockingNoDockingOver:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_docking_no_docking_over(ConfigDockingNoDockingOver);
        #end
        return false;
    }
    private static function get_configDockingWithShift():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_docking_with_shift();
        #end
        return false;
    }
    private static function set_configDockingWithShift(ConfigDockingWithShift:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_docking_with_shift(ConfigDockingWithShift);
        #end
        return false;
    }
    private static function get_configDockingAlwaysTabBar():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_docking_always_tab_bar();
        #end
        return false;
    }
    private static function set_configDockingAlwaysTabBar(ConfigDockingAlwaysTabBar:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_docking_always_tab_bar(ConfigDockingAlwaysTabBar);
        #end
        return false;
    }
    private static function get_configDockingTransparentPayload():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_docking_transparent_payload();
        #end
        return false;
    }
    private static function set_configDockingTransparentPayload(ConfigDockingTransparentPayload:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_docking_transparent_payload(ConfigDockingTransparentPayload);
        #end
        return false;
    }
    private static function get_configViewportsNoAutoMerge():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_viewports_no_auto_merge();
        #end
        return false;
    }
    private static function set_configViewportsNoAutoMerge(ConfigViewportsNoAutoMerge:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_viewports_no_auto_merge(ConfigViewportsNoAutoMerge);
        #end
        return false;
    }
    private static function get_configViewportsNoTaskBarIcon():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_viewports_no_task_bar_icon();
        #end
        return false;
    }
    private static function set_configViewportsNoTaskBarIcon(ConfigViewportsNoTaskBarIcon:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_viewports_no_task_bar_icon(ConfigViewportsNoTaskBarIcon);
        #end
        return false;
    }
    private static function get_configViewportsNoDecoration():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_viewports_no_decoration();
        #end
        return false;
    }
    private static function set_configViewportsNoDecoration(ConfigViewportsNoDecoration:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_viewports_no_decoration(ConfigViewportsNoDecoration);
        #end
        return false;
    }
    private static function get_configViewportsNoDefaultParent():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_viewports_no_default_parent();
        #end
        return false;
    }
    private static function set_configViewportsNoDefaultParent(ConfigViewportsNoDefaultParent:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_viewports_no_default_parent(ConfigViewportsNoDefaultParent);
        #end
        return false;
    }
    private static function get_configViewportsPlatformFocusSetsImGuiFocus():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_viewports_platform_focus_sets_im_gui_focus();
        #end
        return false;
    }
    private static function set_configViewportsPlatformFocusSetsImGuiFocus(ConfigViewportsPlatformFocusSetsImGuiFocus:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_viewports_platform_focus_sets_im_gui_focus(ConfigViewportsPlatformFocusSetsImGuiFocus);
        #end
        return false;
    }
    private static function get_configDpiScaleFonts():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_dpi_scale_fonts();
        #end
        return false;
    }
    private static function set_configDpiScaleFonts(ConfigDpiScaleFonts:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_dpi_scale_fonts(ConfigDpiScaleFonts);
        #end
        return false;
    }
    private static function get_configDpiScaleViewports():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_dpi_scale_viewports();
        #end
        return false;
    }
    private static function set_configDpiScaleViewports(ConfigDpiScaleViewports:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_dpi_scale_viewports(ConfigDpiScaleViewports);
        #end
        return false;
    }
    private static function get_mouseDrawCursor():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_draw_cursor();
        #end
        return false;
    }
    private static function set_mouseDrawCursor(MouseDrawCursor:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_draw_cursor(MouseDrawCursor);
        #end
        return false;
    }
    private static function get_configMacOSXBehaviors():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_mac_o_s_x_behaviors();
        #end
        return false;
    }
    private static function set_configMacOSXBehaviors(ConfigMacOSXBehaviors:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_mac_o_s_x_behaviors(ConfigMacOSXBehaviors);
        #end
        return false;
    }
    private static function get_configInputTextCursorBlink():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_input_text_cursor_blink();
        #end
        return false;
    }
    private static function set_configInputTextCursorBlink(ConfigInputTextCursorBlink:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_input_text_cursor_blink(ConfigInputTextCursorBlink);
        #end
        return false;
    }
    private static function get_configInputTextEnterKeepActive():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_input_text_enter_keep_active();
        #end
        return false;
    }
    private static function set_configInputTextEnterKeepActive(ConfigInputTextEnterKeepActive:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_input_text_enter_keep_active(ConfigInputTextEnterKeepActive);
        #end
        return false;
    }
    private static function get_configDragClickToInputText():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_drag_click_to_input_text();
        #end
        return false;
    }
    private static function set_configDragClickToInputText(ConfigDragClickToInputText:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_drag_click_to_input_text(ConfigDragClickToInputText);
        #end
        return false;
    }
    private static function get_configWindowsResizeFromEdges():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_windows_resize_from_edges();
        #end
        return false;
    }
    private static function set_configWindowsResizeFromEdges(ConfigWindowsResizeFromEdges:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_windows_resize_from_edges(ConfigWindowsResizeFromEdges);
        #end
        return false;
    }
    private static function get_configWindowsMoveFromTitleBarOnly():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_windows_move_from_title_bar_only();
        #end
        return false;
    }
    private static function set_configWindowsMoveFromTitleBarOnly(ConfigWindowsMoveFromTitleBarOnly:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_windows_move_from_title_bar_only(ConfigWindowsMoveFromTitleBarOnly);
        #end
        return false;
    }
    private static function get_configWindowsCopyContentsWithCtrlC():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_windows_copy_contents_with_ctrl_c();
        #end
        return false;
    }
    private static function set_configWindowsCopyContentsWithCtrlC(ConfigWindowsCopyContentsWithCtrlC:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_windows_copy_contents_with_ctrl_c(ConfigWindowsCopyContentsWithCtrlC);
        #end
        return false;
    }
    private static function get_configScrollbarScrollByPage():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_scrollbar_scroll_by_page();
        #end
        return false;
    }
    private static function set_configScrollbarScrollByPage(ConfigScrollbarScrollByPage:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_scrollbar_scroll_by_page(ConfigScrollbarScrollByPage);
        #end
        return false;
    }
    private static function get_configMemoryCompactTimer():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_memory_compact_timer();
        #end
        return 0;
    }
    private static function set_configMemoryCompactTimer(ConfigMemoryCompactTimer:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_memory_compact_timer(ConfigMemoryCompactTimer);
        #end
        return 0;
    }
    private static function get_mouseDoubleClickTime():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_double_click_time();
        #end
        return 0;
    }
    private static function set_mouseDoubleClickTime(MouseDoubleClickTime:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_double_click_time(MouseDoubleClickTime);
        #end
        return 0;
    }
    private static function get_mouseDoubleClickMaxDist():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_double_click_max_dist();
        #end
        return 0;
    }
    private static function set_mouseDoubleClickMaxDist(MouseDoubleClickMaxDist:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_double_click_max_dist(MouseDoubleClickMaxDist);
        #end
        return 0;
    }
    private static function get_mouseDragThreshold():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_drag_threshold();
        #end
        return 0;
    }
    private static function set_mouseDragThreshold(MouseDragThreshold:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_drag_threshold(MouseDragThreshold);
        #end
        return 0;
    }
    private static function get_keyRepeatDelay():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_key_repeat_delay();
        #end
        return 0;
    }
    private static function set_keyRepeatDelay(KeyRepeatDelay:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_key_repeat_delay(KeyRepeatDelay);
        #end
        return 0;
    }
    private static function get_keyRepeatRate():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_key_repeat_rate();
        #end
        return 0;
    }
    private static function set_keyRepeatRate(KeyRepeatRate:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_key_repeat_rate(KeyRepeatRate);
        #end
        return 0;
    }
    private static function get_configErrorRecovery():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_error_recovery();
        #end
        return false;
    }
    private static function set_configErrorRecovery(ConfigErrorRecovery:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_error_recovery(ConfigErrorRecovery);
        #end
        return false;
    }
    private static function get_configErrorRecoveryEnableAssert():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_error_recovery_enable_assert();
        #end
        return false;
    }
    private static function set_configErrorRecoveryEnableAssert(ConfigErrorRecoveryEnableAssert:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_error_recovery_enable_assert(ConfigErrorRecoveryEnableAssert);
        #end
        return false;
    }
    private static function get_configErrorRecoveryEnableDebugLog():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_error_recovery_enable_debug_log();
        #end
        return false;
    }
    private static function set_configErrorRecoveryEnableDebugLog(ConfigErrorRecoveryEnableDebugLog:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_error_recovery_enable_debug_log(ConfigErrorRecoveryEnableDebugLog);
        #end
        return false;
    }
    private static function get_configErrorRecoveryEnableTooltip():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_error_recovery_enable_tooltip();
        #end
        return false;
    }
    private static function set_configErrorRecoveryEnableTooltip(ConfigErrorRecoveryEnableTooltip:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_error_recovery_enable_tooltip(ConfigErrorRecoveryEnableTooltip);
        #end
        return false;
    }
    private static function get_configDebugIsDebuggerPresent():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_is_debugger_present();
        #end
        return false;
    }
    private static function set_configDebugIsDebuggerPresent(ConfigDebugIsDebuggerPresent:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_is_debugger_present(ConfigDebugIsDebuggerPresent);
        #end
        return false;
    }
    private static function get_configDebugHighlightIdConflicts():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_highlight_id_conflicts();
        #end
        return false;
    }
    private static function set_configDebugHighlightIdConflicts(ConfigDebugHighlightIdConflicts:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_highlight_id_conflicts(ConfigDebugHighlightIdConflicts);
        #end
        return false;
    }
    private static function get_configDebugHighlightIdConflictsShowItemPicker():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_highlight_id_conflicts_show_item_picker();
        #end
        return false;
    }
    private static function set_configDebugHighlightIdConflictsShowItemPicker(ConfigDebugHighlightIdConflictsShowItemPicker:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_highlight_id_conflicts_show_item_picker(ConfigDebugHighlightIdConflictsShowItemPicker);
        #end
        return false;
    }
    private static function get_configDebugBeginReturnValueOnce():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_begin_return_value_once();
        #end
        return false;
    }
    private static function set_configDebugBeginReturnValueOnce(ConfigDebugBeginReturnValueOnce:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_begin_return_value_once(ConfigDebugBeginReturnValueOnce);
        #end
        return false;
    }
    private static function get_configDebugBeginReturnValueLoop():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_begin_return_value_loop();
        #end
        return false;
    }
    private static function set_configDebugBeginReturnValueLoop(ConfigDebugBeginReturnValueLoop:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_begin_return_value_loop(ConfigDebugBeginReturnValueLoop);
        #end
        return false;
    }
    private static function get_configDebugIgnoreFocusLoss():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_ignore_focus_loss();
        #end
        return false;
    }
    private static function set_configDebugIgnoreFocusLoss(ConfigDebugIgnoreFocusLoss:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_ignore_focus_loss(ConfigDebugIgnoreFocusLoss);
        #end
        return false;
    }
    private static function get_configDebugIniSettings():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_config_debug_ini_settings();
        #end
        return false;
    }
    private static function set_configDebugIniSettings(ConfigDebugIniSettings:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_config_debug_ini_settings(ConfigDebugIniSettings);
        #end
        return false;
    }
    private static function get_wantCaptureMouse():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_want_capture_mouse();
        #end
        return false;
    }
    private static function set_wantCaptureMouse(WantCaptureMouse:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_want_capture_mouse(WantCaptureMouse);
        #end
        return false;
    }
    private static function get_wantCaptureKeyboard():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_want_capture_keyboard();
        #end
        return false;
    }
    private static function set_wantCaptureKeyboard(WantCaptureKeyboard:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_want_capture_keyboard(WantCaptureKeyboard);
        #end
        return false;
    }
    private static function get_wantTextInput():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_want_text_input();
        #end
        return false;
    }
    private static function set_wantTextInput(WantTextInput:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_want_text_input(WantTextInput);
        #end
        return false;
    }
    private static function get_wantSetMousePos():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_want_set_mouse_pos();
        #end
        return false;
    }
    private static function set_wantSetMousePos(WantSetMousePos:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_want_set_mouse_pos(WantSetMousePos);
        #end
        return false;
    }
    private static function get_wantSaveIniSettings():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_want_save_ini_settings();
        #end
        return false;
    }
    private static function set_wantSaveIniSettings(WantSaveIniSettings:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_want_save_ini_settings(WantSaveIniSettings);
        #end
        return false;
    }
    private static function get_navActive():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_nav_active();
        #end
        return false;
    }
    private static function set_navActive(NavActive:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_nav_active(NavActive);
        #end
        return false;
    }
    private static function get_navVisible():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_nav_visible();
        #end
        return false;
    }
    private static function set_navVisible(NavVisible:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_nav_visible(NavVisible);
        #end
        return false;
    }
    private static function get_framerate():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_framerate();
        #end
        return 0;
    }
    private static function set_framerate(Framerate:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_framerate(Framerate);
        #end
        return 0;
    }
    private static function get_metricsRenderVertices():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_metrics_render_vertices();
        #end
        return 0;
    }
    private static function set_metricsRenderVertices(MetricsRenderVertices:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_metrics_render_vertices(MetricsRenderVertices);
        #end
        return 0;
    }
    private static function get_metricsRenderIndices():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_metrics_render_indices();
        #end
        return 0;
    }
    private static function set_metricsRenderIndices(MetricsRenderIndices:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_metrics_render_indices(MetricsRenderIndices);
        #end
        return 0;
    }
    private static function get_metricsRenderWindows():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_metrics_render_windows();
        #end
        return 0;
    }
    private static function set_metricsRenderWindows(MetricsRenderWindows:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_metrics_render_windows(MetricsRenderWindows);
        #end
        return 0;
    }
    private static function get_metricsActiveWindows():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_metrics_active_windows();
        #end
        return 0;
    }
    private static function set_metricsActiveWindows(MetricsActiveWindows:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_metrics_active_windows(MetricsActiveWindows);
        #end
        return 0;
    }
    private static function get_mouseDeltaX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_delta_x();
        #end
        return 0;
    }
    private static function set_mouseDeltaX(MouseDeltaX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_delta_x(MouseDeltaX);
        #end
        return 0;
    }
    private static function get_mouseDeltaY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_get_mouse_delta_y();
        #end
        return 0;
    }
    private static function set_mouseDeltaY(MouseDeltaY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        return NativeCFFI.lime_imgui_io_set_mouse_delta_y(MouseDeltaY);
        #end
        return 0;
    }

	private static function get_mousePosX():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_pos_x();
		#end
		return 0;
	}
	private static function get_mousePosY():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_pos_y();
		#end
		return 0;
	}
	private static function get_mouseDown0():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_down_0();
		#end
		return false;
	}
	private static function get_mouseDown1():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_down_1();
		#end
		return false;
	}
	private static function get_mouseDown2():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_down_2();
		#end
		return false;
	}
	private static function get_mouseDown3():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_down_3();
		#end
		return false;
	}
	private static function get_mouseDown4():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_down_4();
		#end
		return false;
	}
	private static function get_mouseWheel():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_wheel();
		#end
		return 0;
	}
	private static function get_mouseWheelH():Float
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_wheel_h();
		#end
		return 0;
	}
	private static function get_mouseSource():ImGuiMouseSource
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_mouse_source();
		#end
		return 0;
	}
	private static function get_keyCtrl():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_key_ctrl();
		#end
		return false;
	}
	private static function get_keyShift():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_key_shift();
		#end
		return false;
	}
	private static function get_keyAlt():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_key_alt();
		#end
		return false;
	}
	private static function get_keySuper():Bool
	{
		#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
		return NativeCFFI.lime_imgui_io_get_key_super();
		#end
		return false;
	}
}
