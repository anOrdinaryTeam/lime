package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime._internal.backend.native.NativeCFFI;

import lime.tools.imgui.ImGuiFlags;
import lime.tools.imgui.ImGuiTypes;

@:access(lime._internal.backend.native.NativeCFFI)
class ImGuiInputTextCallbackData extends ImGuiTempPtrHandle
{
    public var eventFlag(get, null):ImGuiInputTextFlags;
    public var flags(get, null):ImGuiInputTextFlags;
    public var ID(get, null):ImGuiID;
    public var eventKey(get, null):ImGuiKey;
    public var eventChar(get, set):Int;
    public var eventActivated(get, null):Bool;
    public var bufTextLen(get, set):Int;
    public var bufSize(get, null):Int;
    public var cursorPos(get, set):Int;
    public var selectionStart(get, set):Int;
    public var selectionEnd(get, set):Int;

    public function deleteChars(pos:Int, bytes_count:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_input_text_callback_data_delete_chars(handle, pos, bytes_count);
        #end
    }

    public function insertChars(pos:Int, text:String):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_input_text_callback_data_insert_chars(handle, pos, text);
        #end
    }

    public function selectAll():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_input_text_callback_data_select_all(handle);
        #end
    }

    public function setSelection(s:Int, e:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_input_text_callback_data_set_selection(handle, s, e);
        #end
    }

    public function clearSelection():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_input_text_callback_data_clear_selection(handle);
        #end
    }

    public function hasSelection():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_input_text_callback_data_has_selection(handle);
        #end
        return false;
    }
    
    private function get_eventFlag():ImGuiInputTextFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_event_flag(handle);
        #end
        return 0;
    }
    private function get_flags():ImGuiInputTextFlags
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_flags(handle);
        #end
        return 0;
    }
    private function get_ID():ImGuiID
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_id(handle);
        #end
        return 0;
    }
    private function get_eventKey():ImGuiKey
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_event_key(handle);
        #end
        return 0;
    }
    private function get_eventChar():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_event_char(handle);
        #end
        return 0;
    }
    private function set_eventChar(EventChar:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_set_event_char(handle, EventChar);
        #end
        return 0;
    }
    private function get_eventActivated():Bool
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return false;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_event_activated(handle);
        #end
        return false;
    }
    private function get_bufTextLen():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_buf_text_len(handle);
        #end
        return 0;
    }
    private function set_bufTextLen(BufTextLen:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_set_buf_text_len(handle, BufTextLen);
        #end
        return 0;
    }
    private function get_bufSize():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_buf_size(handle);
        #end
        return 0;
    }
    private function get_cursorPos():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_cursor_pos(handle);
        #end
        return 0;
    }
    private function set_cursorPos(CursorPos:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_set_cursor_pos(handle, CursorPos);
        #end
        return 0;
    }
    private function get_selectionStart():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_selection_start(handle);
        #end
        return 0;
    }
    private function set_selectionStart(SelectionStart:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_set_selection_start(handle, SelectionStart);
        #end
        return 0;
    }
    private function get_selectionEnd():Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_get_selection_end(handle);
        #end
        return 0;
    }
    private function set_selectionEnd(SelectionEnd:Int):Int
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return 0;
        return NativeCFFI.lime_imgui_input_text_callback_data_set_selection_end(handle, SelectionEnd);
        #end
        return 0;
    }
}