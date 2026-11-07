package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImGuiTypes;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiTableSortSpecs extends ImGuiTempPtrHandle
{
    public var specsCount(get, set):Int;
    public var specsDirty(get, set):Bool;

    public function getSpecs(index:Int):ImGuiTableColumnSortSpecs
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return new ImGuiTableColumnSortSpecs(0.0);
        return new ImGuiTableColumnSortSpecs(NativeCFFI.lime_imgui_table_sort_specs_get_specs(handle, index));
        #end
        return new ImGuiTableColumnSortSpecs(0.0);
    }
    
    private function get_specsCount():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_sort_specs_get_specs_count(handle);
        #end
        return 0;
    }
    private function set_specsCount(SpecsCount:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_sort_specs_set_specs_count(handle, SpecsCount);
        #end
        return 0;
    }
    private function get_specsDirty():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_table_sort_specs_get_specs_dirty(handle);
        #end
        return false;
    }
    private function set_specsDirty(SpecsDirty:Bool):Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_table_sort_specs_set_specs_dirty(handle, SpecsDirty);
        #end
        return false;
    }
}

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiTableColumnSortSpecs extends ImGuiTempPtrHandle
{
    public var columnUserID(get, null):ImGuiID;
    public var columnIndex(get, null):Int;
    public var sortOrder(get, null):Int;
    public var sortDirection(get, null):ImGuiSortDirection;

    private function get_columnUserID():ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_column_sort_specs_get_column_user_id(handle);
        #end
        return 0;
    }
    private function get_columnIndex():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_column_sort_specs_get_column_index(handle);
        #end
        return 0;
    }
    private function get_sortOrder():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_column_sort_specs_get_sort_order(handle);
        #end
        return 0;
    }
    private function get_sortDirection():ImGuiSortDirection
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_table_column_sort_specs_get_sort_direction(handle);
        #end
        return 0;
    }
}