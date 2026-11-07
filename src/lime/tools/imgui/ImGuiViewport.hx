package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImGuiFlags;
import lime.tools.imgui.ImGuiTypes;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiViewport extends ImGuiPtrHandle
{
    public var id(get, set):ImGuiID;
    public var flags(get, set):ImGuiViewportFlags;
    public var posX(get, set):Float;
    public var posY(get, set):Float;
    public var sizeX(get, set):Float;
    public var sizeY(get, set):Float;
    public var framebufferScaleX(get, set):Float;
    public var framebufferScaleY(get, set):Float;
    public var workPosX(get, set):Float;
    public var workPosY(get, set):Float;
    public var workSizeX(get, set):Float;
    public var workSizeY(get, set):Float;
    public var dpiScale(get, set):Float;
    public var parentViewportId(get, set):ImGuiID;
    
    private function get_id():ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_id(handle);
        #end
        return 0;
    }
    private function set_id(ID:ImGuiID):ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_id(handle, ID);
        #end
        return 0;
    }
    private function get_flags():ImGuiViewportFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_flags(handle);
        #end
        return 0;
    }
    private function set_flags(Flags:ImGuiViewportFlags):ImGuiViewportFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_flags(handle, Flags);
        #end
        return 0;
    }
    private function get_posX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_pos_x(handle);
        #end
        return 0;
    }
    private function set_posX(PosX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_pos_x(handle, PosX);
        #end
        return 0;
    }
    private function get_posY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_pos_y(handle);
        #end
        return 0;
    }
    private function set_posY(PosY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_pos_y(handle, PosY);
        #end
        return 0;
    }
    private function get_sizeX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_size_x(handle);
        #end
        return 0;
    }
    private function set_sizeX(SizeX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_size_x(handle, SizeX);
        #end
        return 0;
    }
    private function get_sizeY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_size_y(handle);
        #end
        return 0;
    }
    private function set_sizeY(SizeY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_size_y(handle, SizeY);
        #end
        return 0;
    }
    private function get_framebufferScaleX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_framebuffer_scale_x(handle);
        #end
        return 0;
    }
    private function set_framebufferScaleX(FramebufferScaleX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_framebuffer_scale_x(handle, FramebufferScaleX);
        #end
        return 0;
    }
    private function get_framebufferScaleY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_framebuffer_scale_y(handle);
        #end
        return 0;
    }
    private function set_framebufferScaleY(FramebufferScaleY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_framebuffer_scale_y(handle, FramebufferScaleY);
        #end
        return 0;
    }
    private function get_workPosX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_work_pos_x(handle);
        #end
        return 0;
    }
    private function set_workPosX(WorkPosX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_work_pos_x(handle, WorkPosX);
        #end
        return 0;
    }
    private function get_workPosY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_work_pos_y(handle);
        #end
        return 0;
    }
    private function set_workPosY(WorkPosY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_work_pos_y(handle, WorkPosY);
        #end
        return 0;
    }
    private function get_workSizeX():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_work_size_x(handle);
        #end
        return 0;
    }
    private function set_workSizeX(WorkSizeX:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_work_size_x(handle, WorkSizeX);
        #end
        return 0;
    }
    private function get_workSizeY():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_work_size_y(handle);
        #end
        return 0;
    }
    private function set_workSizeY(WorkSizeY:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_work_size_y(handle, WorkSizeY);
        #end
        return 0;
    }
    private function get_dpiScale():Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_dpi_scale(handle);
        #end
        return 0;
    }
    private function set_dpiScale(DpiScale:Float):Float
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_dpi_scale(handle, DpiScale);
        #end
        return 0;
    }
    private function get_parentViewportId():ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_get_parent_viewport_id(handle);
        #end
        return 0;
    }
    private function set_parentViewportId(ParentViewportId:ImGuiID):ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_viewport_set_parent_viewport_id(handle, ParentViewportId);
        #end
        return 0;
    }
}