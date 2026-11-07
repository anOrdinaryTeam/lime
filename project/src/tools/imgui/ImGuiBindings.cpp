#ifdef LIME_IMGUI
#include "imgui.h"
#include "imgui_internal.h"
#endif

#include <hx/CFFIPrime.h>
#include <system/CFFIPointer.h>
#include <system/ValuePointer.h>
#include <math/Vector2.h>


#ifdef LIME_IMGUI
struct InputTextCallback_UserData
{
    HxString*            Str;
	value* Callback = nullptr;
};

static int InputTextCallback(ImGuiInputTextCallbackData* data)
{
    InputTextCallback_UserData* user_data = (InputTextCallback_UserData*)data->UserData;
    if (data->EventFlag == ImGuiInputTextFlags_CallbackResize)
    {
        HxString* str = user_data->Str;
        str->__s = alloc_string_data(str->__s, data->BufTextLen); //hopefully won't cause any issues
        str->length = data->BufTextLen;
        data->Buf = (char*)str->__s;
    }

	if (user_data->Callback)
	{
		uintptr_t address = (uintptr_t)(void*)data;
		double addressHandle = 0;
		memcpy(&addressHandle, &address, sizeof(double));

		value c = *user_data->Callback;
		val_call1(c, alloc_float(addressHandle));
		//user_data->Callback->Call();
		//val_call0(*user_data->Callback);
	}
    return 0;
}
#endif

namespace lime {

	//hacky, but I'm not sure how to get pointers back to haxe (as a cpp.Pointer), we can just use the double as a handle since its 64 bit
	double getHandleFromPointer(void* ptr) {
		uintptr_t address = (uintptr_t)ptr;
		double addressHandle = 0;
		memcpy(&addressHandle, &address, sizeof(double));
		return addressHandle;
	}
	void* getPointerFromHandle(double handle) {
		uintptr_t address = 0;
		memcpy(&address, &handle, sizeof(uintptr_t));
		return (void*)address;
	}
	#ifdef LIME_IMGUI
	void fillStringVectorFromHXArray(ImVector<const char*>& vec, value& arr) {
		int length = val_array_size (arr);
		vec.reserve(length);
		for (int i = 0; i < length; i++) {
			vec.push_back(val_string(val_array_i (arr, i)));
		}
	}
	void fillFloatVectorFromHXArray(ImVector<float>& vec, value& arr) {
		int length = val_array_size (arr);
		vec.reserve(length);
		for (int i = 0; i < length; i++) {
			vec.push_back(val_float(val_array_i (arr, i)));
		}
	}
	void fillImVec2VectorFromHXArray(ImVector<ImVec2>& vec, value& arr) {
		int length = val_array_size (arr) / 2;
		vec.reserve(length);
		for (int i = 0; i < length; i++) {
			vec.push_back(ImVec2(val_float(val_array_i (arr, i*2)), val_float(val_array_i (arr, (i*2) + 1))));
		}
	}
	#endif

	double lime_imgui_get_style(){
		#ifdef LIME_IMGUI
		return getHandleFromPointer((void*)&ImGui::GetCurrentContext()->Style);
		#endif
		return 0;
	}

	void lime_imgui_show_demo_window (value p_open) {
		#ifdef LIME_IMGUI
		ImGui::ShowDemoWindow((bool*)val_data (p_open));
		#endif
	}

  void lime_imgui_show_metrics_window (value p_open) {
		#ifdef LIME_IMGUI
		ImGui::ShowMetricsWindow((bool*)val_data (p_open));
		#endif
	}

  void lime_imgui_show_debug_log_window (value p_open) {
		#ifdef LIME_IMGUI
		ImGui::ShowDebugLogWindow((bool*)val_data (p_open));
		#endif
	}

  void lime_imgui_show_id_stack_tool_window (value p_open) {
		#ifdef LIME_IMGUI
		ImGui::ShowIDStackToolWindow((bool*)val_data (p_open));
		#endif
	}

  void lime_imgui_show_about_window (value p_open) {
		#ifdef LIME_IMGUI
		ImGui::ShowAboutWindow((bool*)val_data (p_open));
		#endif
	}

  void lime_imgui_show_style_editor (double handle) {
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		ImGui::ShowStyleEditor(style);
		#endif
	}

  void lime_imgui_show_style_selector (HxString label) {
		#ifdef LIME_IMGUI
		ImGui::ShowStyleSelector(hxs_utf8(label, nullptr));
		#endif
	}

  void lime_imgui_show_font_selector (HxString label) {
		#ifdef LIME_IMGUI
		ImGui::ShowFontSelector(hxs_utf8(label, nullptr));
		#endif
	}

  void lime_imgui_show_user_guide () {
		#ifdef LIME_IMGUI
		ImGui::ShowUserGuide();
		#endif
	}

  HxString lime_imgui_get_version () {
		#ifdef LIME_IMGUI
		return HxString(ImGui::GetVersion());
		#endif
    return HxString(0, 0);
	}

	bool lime_imgui_begin (HxString name, value p_open, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::Begin(hxs_utf8(name, nullptr), (bool*)val_data (p_open), flags);
		#endif
		return false;
	}

	void lime_imgui_end () {
		#ifdef LIME_IMGUI
		ImGui::End();
		#endif
	}

	bool lime_imgui_begin_child (HxString str_id, float width, float height, int childFlags, int windowFlags) {
		#ifdef LIME_IMGUI
		return ImGui::BeginChild(hxs_utf8(str_id, nullptr), ImVec2(width, height), childFlags, windowFlags);
		#endif
		return false;
	}

	void lime_imgui_end_child () {
		#ifdef LIME_IMGUI
		ImGui::EndChild();
		#endif
	}

	bool lime_imgui_is_window_appearing () {
		#ifdef LIME_IMGUI
		return ImGui::IsWindowAppearing();
		#endif
		return false;
	}

	bool lime_imgui_is_window_collapsed () {
		#ifdef LIME_IMGUI
		return ImGui::IsWindowCollapsed();
		#endif
		return false;
	}

	bool lime_imgui_is_window_focused (int flags) {
		#ifdef LIME_IMGUI
		return ImGui::IsWindowFocused(flags);
		#endif
		return false;
	}

	bool lime_imgui_is_window_hovered (int flags) {
		#ifdef LIME_IMGUI
		return ImGui::IsWindowHovered(flags);
		#endif
		return false;
	}

	double lime_imgui_get_window_draw_list(){
        #ifdef LIME_IMGUI
        return getHandleFromPointer((void*)ImGui::GetWindowDrawList());
        #endif
        return 0;
	}

	float lime_imgui_get_window_dpi_scale () {
		#ifdef LIME_IMGUI
		return ImGui::GetWindowDpiScale();
		#endif
		return 0.0f;
	}

	value lime_imgui_get_window_pos () {
		#ifdef LIME_IMGUI
		ImVec2 pos = ImGui::GetWindowPos();
		return Vector2(pos.x, pos.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

	value lime_imgui_get_window_size () {
		#ifdef LIME_IMGUI
		ImVec2 size = ImGui::GetWindowSize();
		return Vector2(size.x, size.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

	float lime_imgui_get_window_width () {
		#ifdef LIME_IMGUI
		return ImGui::GetWindowWidth();
		#endif
		return 0.0f;
	}

	float lime_imgui_get_window_height () {
		#ifdef LIME_IMGUI
		return ImGui::GetWindowHeight();
		#endif
		return 0.0f;
	}

	double lime_imgui_get_window_viewport(){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = ImGui::GetWindowViewport();
		return getHandleFromPointer((void*)viewport);
		#endif
		return 0;
	}

    void lime_imgui_set_next_window_pos (float posX, float posY, int cond, float pivotX, float pivotY) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowPos(ImVec2(posX, posY), cond, ImVec2(pivotX, pivotY));
		#endif
	}

    void lime_imgui_set_next_window_size (float width, float height, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowSize(ImVec2(width, height), cond);
		#endif
	}

    void lime_imgui_set_next_window_constraints (float minX, float minY, float maxX, float maxY) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowSizeConstraints(ImVec2(minX, minY), ImVec2(maxX, maxY));
		#endif
	}

    void lime_imgui_set_next_window_content_size (float width, float height) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowContentSize(ImVec2(width, height));
		#endif
	}

    void lime_imgui_set_next_window_collapsed (bool collapsed, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowCollapsed(collapsed, cond);
		#endif
	}

    void lime_imgui_set_next_window_focus () {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowFocus();
		#endif
	}

    void lime_imgui_set_next_window_scroll (float scrollX, float scrollY) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowScroll(ImVec2(scrollX, scrollY));
		#endif
	}

    void lime_imgui_set_next_window_bg_alpha (float alpha) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowBgAlpha(alpha);
		#endif
	}

    void lime_imgui_set_next_window_viewport (int viewport_id) {
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowViewport(viewport_id);
		#endif
	}

    void lime_imgui_set_window_pos (float posX, float posY, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowPos(ImVec2(posX, posY), cond);
		#endif
	}

    void lime_imgui_set_window_size (float width, float height, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowSize(ImVec2(width, height), cond);
		#endif
	}

    void lime_imgui_set_window_collapsed (bool collapsed, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowCollapsed(collapsed, cond);
		#endif
	}

    void lime_imgui_set_window_focus () {
		#ifdef LIME_IMGUI
		ImGui::SetWindowFocus();
		#endif
	}

    void lime_imgui_set_named_window_pos (HxString name, float posX, float posY, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowPos(hxs_utf8(name, nullptr), ImVec2(posX, posY), cond);
		#endif
	}

    void lime_imgui_set_named_window_size (HxString name, float width, float height, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowSize(hxs_utf8(name, nullptr), ImVec2(width, height), cond);
		#endif
	}

    void lime_imgui_set_named_window_collapsed (HxString name, bool collapsed, int cond) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowCollapsed(hxs_utf8(name, nullptr), collapsed, cond);
		#endif
	}

    void lime_imgui_set_named_window_focus (HxString name) {
		#ifdef LIME_IMGUI
		ImGui::SetWindowFocus(hxs_utf8(name, nullptr));
		#endif
	}

  float lime_imgui_get_scroll_x() {
    #ifdef LIME_IMGUI
		return ImGui::GetScrollX();
		#endif
    return 0.0f;
  }

  float lime_imgui_get_scroll_y() {
    #ifdef LIME_IMGUI
		return ImGui::GetScrollY();
		#endif
    return 0.0f;
  }

  void lime_imgui_set_scroll_x(float x) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollX(x);
		#endif
  }

  void lime_imgui_set_scroll_y(float y) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollX(y);
		#endif
  }

  float lime_imgui_get_scroll_max_x() {
    #ifdef LIME_IMGUI
		return ImGui::GetScrollMaxX();
		#endif
    return 0.0f;
  }

  float lime_imgui_get_scroll_max_y() {
    #ifdef LIME_IMGUI
		return ImGui::GetScrollMaxY();
		#endif
    return 0.0f;
  }

  void lime_imgui_set_scroll_here_x(float center_x_ratio) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollHereX(center_x_ratio);
		#endif
  }

  void lime_imgui_set_scroll_here_y(float center_y_ratio) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollHereY(center_y_ratio);
		#endif
  }

  void lime_imgui_set_scroll_from_pos_x(float local_x, float center_x_ratio) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollFromPosX(local_x, center_x_ratio);
		#endif
  }

  void lime_imgui_set_scroll_from_pos_y(float local_y, float center_y_ratio) {
    #ifdef LIME_IMGUI
	  ImGui::SetScrollFromPosY(local_y, center_y_ratio);
		#endif
  }

  void lime_imgui_push_font(double handle, float font_size_base_unscaled) {
    #ifdef LIME_IMGUI
	ImFont* font = (ImFont*)getPointerFromHandle(handle);
	ImGui::PushFont(font, font_size_base_unscaled);
	#endif
  }

  void lime_imgui_pop_font() {
    #ifdef LIME_IMGUI
	ImGui::PopFont();
	#endif
  }
  
  double lime_imgui_get_font() {
	#ifdef LIME_IMGUI
	ImFont* font = ImGui::GetFont();
	return getHandleFromPointer((void*)font);
	#endif
	return 0.0;
  }

  float lime_imgui_get_font_size() {
	#ifdef LIME_IMGUI
	return ImGui::GetFontSize();
	#endif
	return 0.0f;
  }

  double lime_imgui_get_font_baked() {
	#ifdef LIME_IMGUI
	ImFontBaked* fontBaked = ImGui::GetFontBaked();
	return getHandleFromPointer((void*)fontBaked);
	#endif
	return 0.0;
  }

  void lime_imgui_push_style_color(int idx, int col) {
    #ifdef LIME_IMGUI
	  ImGui::PushStyleColor(idx, ImGui::ColorConvertU32ToFloat4(col));
		#endif
  }

  void lime_imgui_pop_style_color(int count) {
    #ifdef LIME_IMGUI
	  ImGui::PopStyleColor(count);
		#endif
  }

  void lime_imgui_push_style_var(int idx, float val) {
    #ifdef LIME_IMGUI
	  ImGui::PushStyleVar(idx, val);
		#endif
  }

  void lime_imgui_push_style_var2(int idx, float x, float y) {
    #ifdef LIME_IMGUI
	  ImGui::PushStyleVar(idx, ImVec2(x, y));
		#endif
  }

  void lime_imgui_pop_style_var(int count) {
    #ifdef LIME_IMGUI
	  ImGui::PopStyleVar(count);
		#endif
  }

  void lime_imgui_push_item_flag(int option, bool enabled) {
    #ifdef LIME_IMGUI
	  ImGui::PushItemFlag(option, enabled);
		#endif
  }

  void lime_imgui_pop_item_flag() {
    #ifdef LIME_IMGUI
	  ImGui::PopItemFlag();
		#endif
  }

  void lime_imgui_push_item_width(float width) {
    #ifdef LIME_IMGUI
	  ImGui::PushItemWidth(width);
		#endif
  }

  void lime_imgui_pop_item_width() {
    #ifdef LIME_IMGUI
	  ImGui::PopItemWidth();
		#endif
  }

  void lime_imgui_set_next_item_width(float width) {
    #ifdef LIME_IMGUI
	  ImGui::SetNextItemWidth(width);
		#endif
  }

  float lime_imgui_calc_item_width() {
    #ifdef LIME_IMGUI
	  return ImGui::CalcItemWidth();
		#endif
    return 0.0f;
  }

  void lime_imgui_push_text_wrap_pos(float wrap_local_pos_x) {
    #ifdef LIME_IMGUI
	  ImGui::PushTextWrapPos(wrap_local_pos_x);
		#endif
  }

  void lime_imgui_pop_text_wrap_pos() {
    #ifdef LIME_IMGUI
	  ImGui::PopTextWrapPos();
		#endif
  }

  value lime_imgui_get_font_tex_uv_white_pixel () {
		#ifdef LIME_IMGUI
		ImVec2 uv = ImGui::GetFontTexUvWhitePixel();
		return Vector2(uv.x, uv.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

  int lime_imgui_get_color_u32 (int idx, float alpha_mul) {
		#ifdef LIME_IMGUI
		return ImGui::GetColorU32(idx, alpha_mul);
		#endif
		return 0;
	}

  /* //apparently no vector 4 class on cpp side?
  value lime_imgui_get_style_color_vec4 (int idx) {
		#ifdef LIME_IMGUI
    const ImVec4& vec4 = ImGui::GetStyleColorVec4(idx);
		return Vector4(vec4.x, vec4.y, vec4.z, vec4.w).Value();
		#endif
		return Vector4(0.0, 0.0, 0.0, 0.0).Value();
	}
  */

  value lime_imgui_get_cursor_screen_pos () {
		#ifdef LIME_IMGUI
		ImVec2 vec2 = ImGui::GetCursorScreenPos();
		return Vector2(vec2.x, vec2.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

  void lime_imgui_set_cursor_screen_pos (float x, float y) {
		#ifdef LIME_IMGUI
		ImGui::SetCursorScreenPos(ImVec2(x, y));
		#endif
	}

  value lime_imgui_get_content_region_avail () {
		#ifdef LIME_IMGUI
		ImVec2 vec2 = ImGui::GetContentRegionAvail();
		return Vector2(vec2.x, vec2.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

  value lime_imgui_get_cursor_pos () {
		#ifdef LIME_IMGUI
		ImVec2 vec2 = ImGui::GetCursorPos();
		return Vector2(vec2.x, vec2.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

  void lime_imgui_set_cursor_pos (float x, float y) {
		#ifdef LIME_IMGUI
		ImGui::SetCursorPos(ImVec2(x, y));
		#endif
	}

  value lime_imgui_get_cursor_start_pos () {
		#ifdef LIME_IMGUI
		ImVec2 vec2 = ImGui::GetCursorStartPos();
		return Vector2(vec2.x, vec2.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}

  void lime_imgui_separator () {
		#ifdef LIME_IMGUI
		ImGui::Separator();
		#endif
	}

  void lime_imgui_sameline (float offset_from_start_x, float spacing) {
		#ifdef LIME_IMGUI
		ImGui::SameLine(offset_from_start_x, spacing);
		#endif
	}

  void lime_imgui_newline () {
		#ifdef LIME_IMGUI
		ImGui::NewLine();
		#endif
	}

  void lime_imgui_spacing () {
		#ifdef LIME_IMGUI
		ImGui::Spacing();
		#endif
	}

  void lime_imgui_dummy (float width, float height) {
		#ifdef LIME_IMGUI
		ImGui::Dummy(ImVec2(width, height));
		#endif
	}

  void lime_imgui_indent (float width) {
		#ifdef LIME_IMGUI
		ImGui::Indent(width);
		#endif
	}

  void lime_imgui_unindent (float width) {
		#ifdef LIME_IMGUI
		ImGui::Unindent(width);
		#endif
	}

  void lime_imgui_begin_group () {
		#ifdef LIME_IMGUI
		ImGui::BeginGroup();
		#endif
	}

  void lime_imgui_end_group () {
		#ifdef LIME_IMGUI
		ImGui::EndGroup();
		#endif
	}

  void lime_imgui_align_text_to_frame_padding () {
		#ifdef LIME_IMGUI
		ImGui::AlignTextToFramePadding();
		#endif
	}

  float lime_imgui_get_text_line_height() {
    #ifdef LIME_IMGUI
	  return ImGui::GetTextLineHeight();
		#endif
    return 0.0f;
  }

  float lime_imgui_get_text_line_height_with_spacing() {
    #ifdef LIME_IMGUI
	  return ImGui::GetTextLineHeightWithSpacing();
		#endif
    return 0.0f;
  }

  float lime_imgui_get_frame_height() {
    #ifdef LIME_IMGUI
	  return ImGui::GetFrameHeight();
		#endif
    return 0.0f;
  }

  float lime_imgui_get_frame_height_with_spacing() {
    #ifdef LIME_IMGUI
	  return ImGui::GetFrameHeightWithSpacing();
		#endif
    return 0.0f;
  }

  void lime_imgui_push_id_str (HxString str_id) {
		#ifdef LIME_IMGUI
		ImGui::PushID(hxs_utf8(str_id, nullptr));
		#endif
	}

  void lime_imgui_push_id_str2 (HxString begin, HxString end) {
		#ifdef LIME_IMGUI
		ImGui::PushID(hxs_utf8(begin, nullptr), hxs_utf8(end, nullptr));
		#endif
	}

  void lime_imgui_push_id_int (int id) {
		#ifdef LIME_IMGUI
		ImGui::PushID(id);
		#endif
	}

  void lime_imgui_pop_id () {
		#ifdef LIME_IMGUI
		ImGui::PopID();
		#endif
	}

  int lime_imgui_get_id_str (HxString str_id) {
		#ifdef LIME_IMGUI
    unsigned int id = ImGui::GetID(hxs_utf8(str_id, nullptr));
		return id;
		#endif
    return 0;
	}

  int lime_imgui_get_id_str2 (HxString begin, HxString end) {
		#ifdef LIME_IMGUI
    unsigned int id = ImGui::GetID(hxs_utf8(begin, nullptr), hxs_utf8(end, nullptr));
		return id;
		#endif
    return 0;
	}

  int lime_imgui_get_id_int (int int_id) {
		#ifdef LIME_IMGUI
    unsigned int id = ImGui::GetID(int_id);
		return id;
		#endif
    return 0;
	}

  void lime_imgui_text_unformatted (HxString text, HxString textEnd) {
		#ifdef LIME_IMGUI
		ImGui::TextUnformatted(hxs_utf8(text, nullptr), hxs_utf8(textEnd, nullptr));
		#endif
	}

	void lime_imgui_text (HxString text) {
		#ifdef LIME_IMGUI
		ImGui::Text(hxs_utf8(text, nullptr));
		#endif
	}

  void lime_imgui_text_colored (int col, HxString text) {
		#ifdef LIME_IMGUI
		ImGui::TextColored(ImGui::ColorConvertU32ToFloat4(col), hxs_utf8(text, nullptr));
		#endif
	}

	void lime_imgui_text_disabled (HxString text) {
		#ifdef LIME_IMGUI
		ImGui::TextDisabled(hxs_utf8(text, nullptr));
		#endif
	}

	void lime_imgui_text_wrapped (HxString text) {
		#ifdef LIME_IMGUI
		ImGui::TextWrapped(hxs_utf8(text, nullptr));
		#endif
	}

	void lime_imgui_label_text (HxString text, HxString format) {
		#ifdef LIME_IMGUI
		ImGui::LabelText(hxs_utf8(text, nullptr), hxs_utf8(format, nullptr));
		#endif
	}

	void lime_imgui_bullet_text (HxString text) {
		#ifdef LIME_IMGUI
		ImGui::BulletText(hxs_utf8(text, nullptr));
		#endif
	}

	void lime_imgui_separator_text (HxString text) {
		#ifdef LIME_IMGUI
		ImGui::SeparatorText(hxs_utf8(text, nullptr));
		#endif
	}

	bool lime_imgui_button (HxString label, float width, float height) {
		#ifdef LIME_IMGUI
		return ImGui::Button(hxs_utf8(label, nullptr), ImVec2(width, height));
		#endif
		return false;
	}

	bool lime_imgui_small_button (HxString label) {
		#ifdef LIME_IMGUI
		return ImGui::SmallButton(hxs_utf8(label, nullptr));
		#endif
		return false;
	}

  bool lime_imgui_invisible_button (HxString str_id, float width, float height, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InvisibleButton(hxs_utf8(str_id, nullptr), ImVec2(width, height), flags);
		#endif
		return false;
	}

  bool lime_imgui_arrow_button (HxString str_id, int dir) {
		#ifdef LIME_IMGUI
		return ImGui::ArrowButton(hxs_utf8(str_id, nullptr), (ImGuiDir)dir);
		#endif
		return false;
	}

	bool lime_imgui_checkbox (HxString label, value v) {
		#ifdef LIME_IMGUI
		return ImGui::Checkbox(hxs_utf8(label, nullptr), (bool*)val_data (v));
		#endif
		return false;
	}

  bool lime_imgui_checkbox_flags (HxString label, value v, int flag) {
		#ifdef LIME_IMGUI
		return ImGui::CheckboxFlags(hxs_utf8(label, nullptr), (int*)val_data (v), flag);
		#endif
		return false;
	}

  bool lime_imgui_radio_button (HxString label, value v, int v_button) {
		#ifdef LIME_IMGUI
		return ImGui::RadioButton(hxs_utf8(label, nullptr), (int*)val_data (v), v_button);
		#endif
		return false;
	}

  void lime_imgui_progress_bar (float fraction, float sizeX, float sizeY, HxString overlay) {
		#ifdef LIME_IMGUI
		ImGui::ProgressBar(fraction, ImVec2(sizeX, sizeY), hxs_utf8(overlay, nullptr));
		#endif
	}

  void lime_imgui_bullet () {
		#ifdef LIME_IMGUI
		ImGui::Bullet();
		#endif
	}

  bool lime_imgui_text_link (HxString label) {
		#ifdef LIME_IMGUI
		return ImGui::TextLink(hxs_utf8(label, nullptr));
		#endif
		return false;
	}

  bool lime_imgui_text_link_open_url (HxString label, HxString url) {
		#ifdef LIME_IMGUI
		return ImGui::TextLinkOpenURL(hxs_utf8(label, nullptr), hxs_utf8(url, nullptr));
		#endif
		return false;
	}

	void lime_imgui_image (int glTextureID, float imageWidth, float imageHeight, float uvX, float uvY, float uvZ, float uvW) {
		#ifdef LIME_IMGUI
		ImGui::Image((ImTextureID)(intptr_t)glTextureID, ImVec2(imageWidth, imageHeight), ImVec2(uvX, uvY), ImVec2(uvZ, uvW));
		#endif
	}

	void lime_imgui_image_with_bg(int tex_ref, float image_sizeX, float image_sizeY, float uv0X, float uv0Y, float uv1X, float uv1Y, int bg_col, int tint_col){
        #ifdef LIME_IMGUI
        ImGui::ImageWithBg((ImTextureID)(intptr_t)tex_ref, ImVec2(image_sizeX, image_sizeY), ImVec2(uv0X, uv0Y), ImVec2(uv1X, uv1Y), ImGui::ColorConvertU32ToFloat4(bg_col), ImGui::ColorConvertU32ToFloat4(tint_col));
        #endif
	}
	bool lime_imgui_image_button(HxString str_id, int tex_ref, float image_sizeX, float image_sizeY, float uv0X, float uv0Y, float uv1X, float uv1Y, int bg_col, int tint_col){
		#ifdef LIME_IMGUI
		return ImGui::ImageButton(hxs_utf8(str_id, nullptr), (ImTextureID)(intptr_t)tex_ref, ImVec2(image_sizeX, image_sizeY), ImVec2(uv0X, uv0Y), ImVec2(uv1X, uv1Y), ImGui::ColorConvertU32ToFloat4(bg_col), ImGui::ColorConvertU32ToFloat4(tint_col));
		#endif
		return false;
	}

	bool lime_imgui_begin_combo(HxString label, HxString preview_value, int flags){
        #ifdef LIME_IMGUI
        return ImGui::BeginCombo(hxs_utf8(label, nullptr), hxs_utf8(preview_value, nullptr), flags);
        #endif
        return false;
	}
	void lime_imgui_end_combo(){
		#ifdef LIME_IMGUI
		ImGui::EndCombo();
		#endif
	}

  	bool lime_imgui_combo (HxString label, value current_item, value items, int maxHeight) {
		#ifdef LIME_IMGUI
		ImVector<const char*> itemsCStr;
		fillStringVectorFromHXArray(itemsCStr, items);
		return ImGui::Combo(hxs_utf8(label, nullptr), (int*)val_data (current_item), itemsCStr.Data, itemsCStr.Size, maxHeight);
		#endif
		return false;
	}

    bool lime_imgui_drag_float (HxString label, value v, float v_speed, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragFloat(hxs_utf8(label, nullptr), (float*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_float2 (HxString label, value v, float v_speed, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragFloat2(hxs_utf8(label, nullptr), (float*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_float3 (HxString label, value v, float v_speed, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragFloat3(hxs_utf8(label, nullptr), (float*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_float4 (HxString label, value v, float v_speed, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragFloat4(hxs_utf8(label, nullptr), (float*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_float_range2 (HxString label, value v_current_min, value v_current_max, float v_speed, float v_min, float v_max, HxString format, HxString format_max, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragFloatRange2(hxs_utf8(label, nullptr), (float*)val_data (v_current_min), (float*)val_data (v_current_max), v_speed, v_min, v_max, hxs_utf8(format, nullptr), hxs_utf8(format_max, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_int (HxString label, value v, float v_speed, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragInt(hxs_utf8(label, nullptr), (int*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_int2 (HxString label, value v, float v_speed, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragInt2(hxs_utf8(label, nullptr), (int*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_int3 (HxString label, value v, float v_speed, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragInt3(hxs_utf8(label, nullptr), (int*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_int4 (HxString label, value v, float v_speed, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragInt4(hxs_utf8(label, nullptr), (int*)val_data (v), v_speed, v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

    bool lime_imgui_drag_int_range2 (HxString label, value v_current_min, value v_current_max, float v_speed, int v_min, int v_max, HxString format, HxString format_max, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::DragIntRange2(hxs_utf8(label, nullptr), (int*)val_data (v_current_min), (int*)val_data (v_current_max), v_speed, v_min, v_max, hxs_utf8(format, nullptr), hxs_utf8(format_max, nullptr), flags);
		#endif
		return false;
	}
  
  bool lime_imgui_slider_float (HxString label, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderFloat(hxs_utf8(label, nullptr), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_float2 (HxString label, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderFloat2(hxs_utf8(label, nullptr), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_float3 (HxString label, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderFloat3(hxs_utf8(label, nullptr), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_float4 (HxString label, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderFloat4(hxs_utf8(label, nullptr), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_angle (HxString label, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderAngle(hxs_utf8(label, nullptr), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_int (HxString label, value v, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderInt(hxs_utf8(label, nullptr), (int*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_int2 (HxString label, value v, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderInt2(hxs_utf8(label, nullptr), (int*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_int3 (HxString label, value v, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderInt3(hxs_utf8(label, nullptr), (int*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_slider_int4 (HxString label, value v, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::SliderInt4(hxs_utf8(label, nullptr), (int*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_vslider_float (HxString label, float width, float height, value v, float v_min, float v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::VSliderFloat(hxs_utf8(label, nullptr), ImVec2(width, height), (float*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_vslider_int (HxString label, float width, float height, value v, int v_min, int v_max, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::VSliderInt(hxs_utf8(label, nullptr), ImVec2(width, height), (int*)val_data (v), v_min, v_max, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_text (HxString label, value strPtr, int flags, value callback) {
		#ifdef LIME_IMGUI
    flags |= ImGuiInputTextFlags_CallbackResize;

    HxString* str = (HxString*)val_data (strPtr);
    InputTextCallback_UserData cb_user_data;
    cb_user_data.Str = str;
	if (callback != nullptr && !val_is_null(callback)) {
		cb_user_data.Callback = (value*)val_data(callback);
	}
    return ImGui::InputText(hxs_utf8(label, nullptr), (char*)str->__s, str->length + 1, flags, InputTextCallback, &cb_user_data);
		#endif
		return false;
	}

  bool lime_imgui_input_multiline (HxString label, value strPtr, float width, float height, int flags, value callback) {
		#ifdef LIME_IMGUI
    flags |= ImGuiInputTextFlags_CallbackResize;

    HxString* str = (HxString*)val_data (strPtr);
    InputTextCallback_UserData cb_user_data;
    cb_user_data.Str = str;
	if (callback != nullptr && !val_is_null(callback)) {
		cb_user_data.Callback = (value*)val_data(callback);
	}
    return ImGui::InputTextMultiline(hxs_utf8(label, nullptr), (char*)str->__s, str->length + 1, ImVec2(width, height), flags, InputTextCallback, &cb_user_data);
		#endif
		return false;
	}

  bool lime_imgui_input_text_with_hint (HxString label, HxString hint, value strPtr, int flags, value callback) {
		#ifdef LIME_IMGUI
    flags |= ImGuiInputTextFlags_CallbackResize;

    HxString* str = (HxString*)val_data (strPtr);
    InputTextCallback_UserData cb_user_data;
    cb_user_data.Str = str;
	if (callback != nullptr && !val_is_null(callback)) {
		cb_user_data.Callback = (value*)val_data(callback);
	}
    return ImGui::InputTextWithHint(hxs_utf8(label, nullptr), hxs_utf8(hint, nullptr), (char*)str->__s, str->length + 1, flags, InputTextCallback, &cb_user_data);
		#endif
		return false;
	}

  bool lime_imgui_input_float (HxString label, value v, float step, float step_fast, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputFloat(hxs_utf8(label, nullptr), (float*)val_data (v), step, step_fast, hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_float2 (HxString label, value v, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputFloat2(hxs_utf8(label, nullptr), (float*)val_data (v), hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_float3 (HxString label, value v, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputFloat3(hxs_utf8(label, nullptr), (float*)val_data (v), hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_float4 (HxString label, value v, HxString format, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputFloat4(hxs_utf8(label, nullptr), (float*)val_data (v), hxs_utf8(format, nullptr), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_int (HxString label, value v, int step, int step_fast, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputInt(hxs_utf8(label, nullptr), (int*)val_data (v), step, step_fast, flags);
		#endif
		return false;
	}

  bool lime_imgui_input_int2 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputInt2(hxs_utf8(label, nullptr), (int*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_int3 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputInt3(hxs_utf8(label, nullptr), (int*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_input_int4 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::InputInt4(hxs_utf8(label, nullptr), (int*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_color_edit3 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::ColorEdit3(hxs_utf8(label, nullptr), (float*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_color_edit4 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::ColorEdit4(hxs_utf8(label, nullptr), (float*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_color_picker3 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::ColorPicker3(hxs_utf8(label, nullptr), (float*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_color_picker4 (HxString label, value v, int flags) {
		#ifdef LIME_IMGUI
		return ImGui::ColorPicker4(hxs_utf8(label, nullptr), (float*)val_data (v), flags);
		#endif
		return false;
	}

  bool lime_imgui_color_button (HxString desc_id, int col, int flags, float width, float height) {
		#ifdef LIME_IMGUI
		return ImGui::ColorButton(hxs_utf8(desc_id, nullptr), ImGui::ColorConvertU32ToFloat4(col), flags, ImVec2(width, height));
		#endif
		return false;
	}

	void lime_imgui_set_color_edit_options(int flags){
		#ifdef LIME_IMGUI
		ImGui::SetColorEditOptions(flags);
		#endif
	}
	bool lime_imgui_tree_node(HxString str_id, HxString fmt){
		#ifdef LIME_IMGUI
		return ImGui::TreeNode(hxs_utf8(str_id, nullptr), hxs_utf8(fmt, nullptr));
		#endif
		return false;
	}
	bool lime_imgui_tree_node_ex(HxString str_id, int flags, HxString fmt){
		#ifdef LIME_IMGUI
		return ImGui::TreeNodeEx(hxs_utf8(str_id, nullptr), flags, hxs_utf8(fmt, nullptr));
		#endif
		return false;
	}
	void lime_imgui_tree_push(HxString str_id){
		#ifdef LIME_IMGUI
		ImGui::TreePush(hxs_utf8(str_id, nullptr));
		#endif
	}
	void lime_imgui_tree_pop(){
		#ifdef LIME_IMGUI
		ImGui::TreePop();
		#endif
	}
	float lime_imgui_get_tree_node_to_label_spacing(){
		#ifdef LIME_IMGUI
		return ImGui::GetTreeNodeToLabelSpacing();
		#endif
		return 0.0f;
	}
	bool lime_imgui_collapsing_header(HxString label, value p_visible, int flags){
		#ifdef LIME_IMGUI
		return ImGui::CollapsingHeader(hxs_utf8(label, nullptr), (bool*)val_data (p_visible), flags);
		#endif
		return false;
	}
	void lime_imgui_set_next_item_open(bool is_open, int cond){
		#ifdef LIME_IMGUI
		ImGui::SetNextItemOpen(is_open, cond);
		#endif
	}
	void lime_imgui_set_next_item_storage_id(int storage_id){
		#ifdef LIME_IMGUI
		ImGui::SetNextItemStorageID(storage_id);
		#endif
	}
	bool lime_imgui_tree_node_get_open(int storage_id){
		#ifdef LIME_IMGUI
		return ImGui::TreeNodeGetOpen(storage_id);
		#endif
		return false;
	}

	bool lime_imgui_selectable(HxString label, bool selected){
        #ifdef LIME_IMGUI
        return ImGui::Selectable(hxs_utf8(label, nullptr), selected);
        #endif
        return false;
	}
	bool lime_imgui_selectable_with_ptr(HxString label, value p_selected, int flags){
		#ifdef LIME_IMGUI
		return ImGui::Selectable(hxs_utf8(label, nullptr), (bool*)val_data (p_selected), flags);
		#endif
		return false;
	}

	bool lime_imgui_begin_list_box(HxString label, float sizeX, float sizeY){
		#ifdef LIME_IMGUI
		return ImGui::BeginListBox(hxs_utf8(label, nullptr), ImVec2(sizeX, sizeY));
		#endif
		return false;
	}
	void lime_imgui_end_list_box(){
		#ifdef LIME_IMGUI
		ImGui::EndListBox();
		#endif
	}
	bool lime_imgui_list_box(HxString label, value current_item, value items, int height_in_items){
		#ifdef LIME_IMGUI
		ImVector<const char*> itemsCStr;
		fillStringVectorFromHXArray(itemsCStr, items);
		return ImGui::ListBox(hxs_utf8(label, nullptr), (int*)val_data (current_item), itemsCStr.Data, itemsCStr.Size, height_in_items);
		#endif
		return false;
	}
	void lime_imgui_plot_lines(HxString label, value values, int values_count, int values_offset, HxString overlay_text, float scale_min, float scale_max, float graph_sizeX, float graph_sizeY, int stride){
		#ifdef LIME_IMGUI
		ImVector<float> valuesFloat;
		fillFloatVectorFromHXArray(valuesFloat, values);
		ImGui::PlotLines(hxs_utf8(label, nullptr), valuesFloat.Data, values_count, values_offset, hxs_utf8(overlay_text, nullptr), scale_min, scale_max, ImVec2(graph_sizeX, graph_sizeY), stride);
		#endif
	}
	void lime_imgui_plot_histogram(HxString label, value values, int values_count, int values_offset, HxString overlay_text, float scale_min, float scale_max, float graph_sizeX, float graph_sizeY, int stride){
		#ifdef LIME_IMGUI
		ImVector<float> valuesFloat;
		fillFloatVectorFromHXArray(valuesFloat, values);
		ImGui::PlotHistogram(hxs_utf8(label, nullptr), valuesFloat.Data, values_count, values_offset, hxs_utf8(overlay_text, nullptr), scale_min, scale_max, ImVec2(graph_sizeX, graph_sizeY), stride);
		#endif
	}

	bool lime_imgui_begin_menu_bar(){
		#ifdef LIME_IMGUI
		return ImGui::BeginMenuBar();
		#endif
		return false;
	}
	void lime_imgui_end_menu_bar(){
		#ifdef LIME_IMGUI
		ImGui::EndMenuBar();
		#endif
	}
	bool lime_imgui_begin_main_menu_bar(){
		#ifdef LIME_IMGUI
		return ImGui::BeginMainMenuBar();
		#endif
		return false;
	}
	void lime_imgui_end_main_menu_bar(){
		#ifdef LIME_IMGUI
		ImGui::EndMainMenuBar();
		#endif
	}
	bool lime_imgui_begin_menu(HxString label, bool enabled){
		#ifdef LIME_IMGUI
		return ImGui::BeginMenu(hxs_utf8(label, nullptr), enabled);
		#endif
		return false;
	}
	void lime_imgui_end_menu(){
		#ifdef LIME_IMGUI
		ImGui::EndMenu();
		#endif
	}
	bool lime_imgui_menu_item(HxString label, HxString shortcut, bool selected, bool enabled){
		#ifdef LIME_IMGUI
		return ImGui::MenuItem(hxs_utf8(label, nullptr), hxs_utf8(shortcut, nullptr), selected, enabled);
		#endif
		return false;
	}
	bool lime_imgui_menu_item_with_toggle(HxString label, HxString shortcut, value p_selected, bool enabled){
		#ifdef LIME_IMGUI
		return ImGui::MenuItem(hxs_utf8(label, nullptr), hxs_utf8(shortcut, nullptr), (bool*)val_data (p_selected), enabled);
		#endif
		return false;
	}
	bool lime_imgui_begin_tooltip(){
		#ifdef LIME_IMGUI
		return ImGui::BeginTooltip();
		#endif
		return false;
	}
	void lime_imgui_end_tooltip(){
		#ifdef LIME_IMGUI
		ImGui::EndTooltip();
		#endif
	}
	void lime_imgui_set_tooltip(HxString fmt){
		#ifdef LIME_IMGUI
		ImGui::SetTooltip(hxs_utf8(fmt, nullptr));
		#endif
	}
	bool lime_imgui_begin_item_tooltip(){
		#ifdef LIME_IMGUI
		return ImGui::BeginItemTooltip();
		#endif
		return false;
	}
	void lime_imgui_set_item_tooltip(HxString fmt){
		#ifdef LIME_IMGUI
		ImGui::SetItemTooltip(hxs_utf8(fmt, nullptr));
		#endif
	}

	bool lime_imgui_begin_popup(HxString str_id, int flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginPopup(hxs_utf8(str_id, nullptr), flags);
		#endif
		return false;
	}
	bool lime_imgui_begin_popup_modal(HxString name, value p_open, int flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginPopupModal(hxs_utf8(name, nullptr), (bool*)val_data (p_open), flags);
		#endif
		return false;
	}
	void lime_imgui_end_popup(){
		#ifdef LIME_IMGUI
		ImGui::EndPopup();
		#endif
	}
	void lime_imgui_open_popup(HxString str_id, int popup_flags){
		#ifdef LIME_IMGUI
		ImGui::OpenPopup(hxs_utf8(str_id, nullptr), popup_flags);
		#endif
	}
	void lime_imgui_open_popup_on_item_click(HxString str_id, int popup_flags){
		#ifdef LIME_IMGUI
		ImGui::OpenPopupOnItemClick(hxs_utf8(str_id, nullptr), popup_flags);
		#endif
	}
	void lime_imgui_close_current_popup(){
		#ifdef LIME_IMGUI
		ImGui::CloseCurrentPopup();
		#endif
	}
	bool lime_imgui_begin_popup_context_item(HxString str_id, int popup_flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginPopupContextItem(hxs_utf8(str_id, nullptr), popup_flags);
		#endif
		return false;
	}
	bool lime_imgui_begin_popup_context_window(HxString str_id, int popup_flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginPopupContextWindow(hxs_utf8(str_id, nullptr), popup_flags);
		#endif
		return false;
	}
	bool lime_imgui_begin_popup_context_void(HxString str_id, int popup_flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginPopupContextVoid(hxs_utf8(str_id, nullptr), popup_flags);
		#endif
		return false;
	}
	bool lime_imgui_is_popup_open(HxString str_id, int flags){
		#ifdef LIME_IMGUI
		return ImGui::IsPopupOpen(hxs_utf8(str_id, nullptr), flags);
		#endif
		return false;
	}

	bool lime_imgui_begin_table(HxString str_id, int columns, int flags, float outer_sizeX, float outer_sizeY, float inner_width){
		#ifdef LIME_IMGUI
		return ImGui::BeginTable(hxs_utf8(str_id, nullptr), columns, flags, ImVec2(outer_sizeX, outer_sizeY), inner_width);
		#endif
		return false;
	}
	void lime_imgui_end_table(){
		#ifdef LIME_IMGUI
		ImGui::EndTable();
		#endif
	}
	void lime_imgui_table_next_row(int row_flags, float min_row_height){
		#ifdef LIME_IMGUI
		ImGui::TableNextRow(row_flags, min_row_height);
		#endif
	}
	bool lime_imgui_table_next_column(){
		#ifdef LIME_IMGUI
		return ImGui::TableNextColumn();
		#endif
		return false;
	}
	bool lime_imgui_table_set_column_index(int column_n){
		#ifdef LIME_IMGUI
		return ImGui::TableSetColumnIndex(column_n);
		#endif
		return false;
	}
	void lime_imgui_table_setup_column(HxString label, int flags, float init_width_or_weight, int user_id){
		#ifdef LIME_IMGUI
		ImGui::TableSetupColumn(hxs_utf8(label, nullptr), flags, init_width_or_weight, user_id);
		#endif
	}
	void lime_imgui_table_setup_scroll_freeze(int cols, int rows){
		#ifdef LIME_IMGUI
		ImGui::TableSetupScrollFreeze(cols, rows);
		#endif
	}
	void lime_imgui_table_header(HxString label){
		#ifdef LIME_IMGUI
		ImGui::TableHeader(hxs_utf8(label, nullptr));
		#endif
	}
	void lime_imgui_table_headers_row(){
		#ifdef LIME_IMGUI
		ImGui::TableHeadersRow();
		#endif
	}
	void lime_imgui_table_angled_headers_row(){
		#ifdef LIME_IMGUI
		ImGui::TableAngledHeadersRow();
		#endif
	}
	double lime_imgui_table_get_sort_specs(){
		#ifdef LIME_IMGUI
		return getHandleFromPointer((void*)ImGui::TableGetSortSpecs());
		#endif
		return 0;
	}
	int lime_imgui_table_get_column_count(){
		#ifdef LIME_IMGUI
		return ImGui::TableGetColumnCount();
		#endif
		return 0;
	}
	int lime_imgui_table_get_column_index(){
		#ifdef LIME_IMGUI
		return ImGui::TableGetColumnIndex();
		#endif
		return 0;
	}
	int lime_imgui_table_get_row_index(){
		#ifdef LIME_IMGUI
		return ImGui::TableGetRowIndex();
		#endif
		return 0;
	}
	HxString lime_imgui_table_get_column_name(int column_n){
		#ifdef LIME_IMGUI
		return ImGui::TableGetColumnName(column_n);
		#endif
		return 0;
	}
	int lime_imgui_table_get_column_flags(int column_n){
		#ifdef LIME_IMGUI
		return ImGui::TableGetColumnFlags(column_n);
		#endif
		return 0;
	}
	void lime_imgui_table_set_column_enabled(int column_n, bool v){
		#ifdef LIME_IMGUI
		ImGui::TableSetColumnEnabled(column_n, v);
		#endif
	}
	int lime_imgui_table_get_hovered_column(){
		#ifdef LIME_IMGUI
		return ImGui::TableGetHoveredColumn();
		#endif
		return 0;
	}
	void lime_imgui_table_set_bg_color(int target, int color, int column_n){
		#ifdef LIME_IMGUI
		ImGui::TableSetBgColor(target, color, column_n);
		#endif
	}

	void lime_imgui_columns(int count, HxString id, bool borders){
		#ifdef LIME_IMGUI
		ImGui::Columns(count, hxs_utf8(id, nullptr), borders);
		#endif
	}
	void lime_imgui_next_column(){
		#ifdef LIME_IMGUI
		ImGui::NextColumn();
		#endif
	}
	int lime_imgui_get_column_index(){
		#ifdef LIME_IMGUI
		return ImGui::GetColumnIndex();
		#endif
		return 0;
	}
	float lime_imgui_get_column_width(int column_index){
		#ifdef LIME_IMGUI
		return ImGui::GetColumnWidth(column_index);
		#endif
		return 0;
	}
	void lime_imgui_set_column_width(int column_index, float width){
		#ifdef LIME_IMGUI
		ImGui::SetColumnWidth(column_index, width);
		#endif
	}
	float lime_imgui_get_column_offset(int column_index){
		#ifdef LIME_IMGUI
		return ImGui::GetColumnOffset(column_index);
		#endif
		return 0;
	}
	void lime_imgui_set_column_offset(int column_index, float offset_x){
		#ifdef LIME_IMGUI
		ImGui::SetColumnOffset(column_index, offset_x);
		#endif
	}
	int lime_imgui_get_columns_count(){
		#ifdef LIME_IMGUI
		return ImGui::GetColumnsCount();
		#endif
		return 0;
	}
	bool lime_imgui_begin_tab_bar(HxString str_id, int flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginTabBar(hxs_utf8(str_id, nullptr), flags);
		#endif
		return false;
	}
	void lime_imgui_end_tab_bar(){
		#ifdef LIME_IMGUI
		ImGui::EndTabBar();
		#endif
	}
	bool lime_imgui_begin_tab_item(HxString label, value p_open, int flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginTabItem(hxs_utf8(label, nullptr), (bool*)val_data(p_open), flags);
		#endif
		return false;
	}
	void lime_imgui_end_tab_item(){
		#ifdef LIME_IMGUI
		ImGui::EndTabItem();
		#endif
	}
	bool lime_imgui_tab_item_button(HxString label, int flags){
		#ifdef LIME_IMGUI
		return ImGui::TabItemButton(hxs_utf8(label, nullptr), flags);
		#endif
		return false;
	}
	void lime_imgui_set_tab_item_closed(HxString tab_or_docked_window_label){
		#ifdef LIME_IMGUI
		ImGui::SetTabItemClosed(hxs_utf8(tab_or_docked_window_label, nullptr));
		#endif
	}

	int lime_imgui_dock_space(int dockspace_id, float sizeX, float sizeY, int flags){
		#ifdef LIME_IMGUI
		return ImGui::DockSpace(dockspace_id, ImVec2(sizeX, sizeY), flags);
		#endif
		return 0;
	}
	int lime_imgui_dock_space_over_viewport(int dockspace_id, double viewportHandle, int flags){
        #ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(viewportHandle);
        return ImGui::DockSpaceOverViewport(dockspace_id, viewport, flags);
        #endif
        return 0;
}
	void lime_imgui_set_next_window_dock_id(int dock_id, int cond){
		#ifdef LIME_IMGUI
		ImGui::SetNextWindowDockID(dock_id, cond);
		#endif
	}
	int lime_imgui_get_window_dock_id(){
		#ifdef LIME_IMGUI
		return ImGui::GetWindowDockID();
		#endif
		return 0;
	}
	bool lime_imgui_is_window_docked(){
		#ifdef LIME_IMGUI
		return ImGui::IsWindowDocked();
		#endif
		return false;
	}

	bool lime_imgui_begin_drag_drop_source(int flags){
		#ifdef LIME_IMGUI
		return ImGui::BeginDragDropSource(flags);
		#endif
		return false;
	}
	bool lime_imgui_set_drag_drop_payload(HxString type, HxString data, int cond){
		#ifdef LIME_IMGUI
		return ImGui::SetDragDropPayload(type.__s, data.__s, data.length+1, cond);
		#endif
		return false;
	}
	void lime_imgui_end_drag_drop_source(){
		#ifdef LIME_IMGUI
		ImGui::EndDragDropSource();
		#endif
	}
	bool lime_imgui_begin_drag_drop_target(){
		#ifdef LIME_IMGUI
		return ImGui::BeginDragDropTarget();
		#endif
		return false;
	}
	HxString lime_imgui_accept_drag_drop_payload(HxString type, int flags){
		#ifdef LIME_IMGUI
		const ImGuiPayload* payload = ImGui::AcceptDragDropPayload(type.__s, flags);
		if (payload == nullptr) return HxString(0, 0);
		printf("eah");
		return HxString((const char*)payload->Data, payload->DataSize-1);
		#endif
		return HxString(0, 0);
	}
	void lime_imgui_end_drag_drop_target(){
		#ifdef LIME_IMGUI
		ImGui::EndDragDropTarget();
		#endif
	}
	HxString lime_imgui_get_drag_drop_payload(){
		#ifdef LIME_IMGUI
		const ImGuiPayload* payload = ImGui::GetDragDropPayload();
		if (payload == nullptr) return HxString(0, 0);
		return HxString((const char*)payload->Data, payload->DataSize-1);
		#endif
		return HxString(0, 0);
	}

	void lime_imgui_begin_disabled(bool disabled){
		#ifdef LIME_IMGUI
		ImGui::BeginDisabled(disabled);
		#endif
	}
	void lime_imgui_end_disabled(){
		#ifdef LIME_IMGUI
		ImGui::EndDisabled();
		#endif
	}
	void lime_imgui_push_clip_rect(float clip_rect_minX, float clip_rect_minY, float clip_rect_maxX, float clip_rect_maxY, bool intersect_with_current_clip_rect){
		#ifdef LIME_IMGUI
		ImGui::PushClipRect(ImVec2(clip_rect_minX, clip_rect_minY), ImVec2(clip_rect_maxX, clip_rect_maxY), intersect_with_current_clip_rect);
		#endif
	}
	void lime_imgui_pop_clip_rect(){
		#ifdef LIME_IMGUI
		ImGui::PopClipRect();
		#endif
	}
	void lime_imgui_set_item_default_focus(){
		#ifdef LIME_IMGUI
		ImGui::SetItemDefaultFocus();
		#endif
	}
	void lime_imgui_set_keyboard_focus_here(int offset){
		#ifdef LIME_IMGUI
		ImGui::SetKeyboardFocusHere(offset);
		#endif
	}
	void lime_imgui_set_nav_cursor_visible(bool visible){
		#ifdef LIME_IMGUI
		ImGui::SetNavCursorVisible(visible);
		#endif
	}
	void lime_imgui_set_next_item_allow_overlap(){
		#ifdef LIME_IMGUI
		ImGui::SetNextItemAllowOverlap();
		#endif
	}

	bool lime_imgui_is_item_hovered(int flags){
		#ifdef LIME_IMGUI
		return ImGui::IsItemHovered(flags);
		#endif
		return false;
	}
	bool lime_imgui_is_item_active(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemActive();
		#endif
		return false;
	}
	bool lime_imgui_is_item_focused(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemFocused();
		#endif
		return false;
	}
	bool lime_imgui_is_item_clicked(int mouse_button){
		#ifdef LIME_IMGUI
		return ImGui::IsItemClicked(mouse_button);
		#endif
		return false;
	}
	bool lime_imgui_is_item_visible(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemVisible();
		#endif
		return false;
	}
	bool lime_imgui_is_item_edited(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemEdited();
		#endif
		return false;
	}
	bool lime_imgui_is_item_activated(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemActivated();
		#endif
		return false;
	}
	bool lime_imgui_is_item_deactivated(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemDeactivated();
		#endif
		return false;
	}
	bool lime_imgui_is_item_deactivated_after_edit(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemDeactivatedAfterEdit();
		#endif
		return false;
	}
	bool lime_imgui_is_item_toggled_open(){
		#ifdef LIME_IMGUI
		return ImGui::IsItemToggledOpen();
		#endif
		return false;
	}
	bool lime_imgui_is_any_item_hovered(){
		#ifdef LIME_IMGUI
		return ImGui::IsAnyItemHovered();
		#endif
		return false;
	}
	bool lime_imgui_is_any_item_active(){
		#ifdef LIME_IMGUI
		return ImGui::IsAnyItemActive();
		#endif
		return false;
	}
	bool lime_imgui_is_any_item_focused(){
		#ifdef LIME_IMGUI
		return ImGui::IsAnyItemFocused();
		#endif
		return false;
	}
	int lime_imgui_get_item_id(){
		#ifdef LIME_IMGUI
		return ImGui::GetItemID();
		#endif
		return 0;
	}
	value lime_imgui_get_item_rect_min(){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetItemRectMin();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	value lime_imgui_get_item_rect_max(){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetItemRectMax();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	value lime_imgui_get_item_rect_size(){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetItemRectSize();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	int lime_imgui_get_item_flags(){
		#ifdef LIME_IMGUI
		return ImGui::GetItemFlags();
		#endif
		return 0;
	}

	double lime_imgui_get_main_viewport(){
		#ifdef LIME_IMGUI
		return getHandleFromPointer((void*)ImGui::GetMainViewport());
		#endif
		return 0;
	}

	double lime_imgui_get_background_draw_list(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return getHandleFromPointer((void*)ImGui::GetBackgroundDrawList(viewport));
		#endif
		return 0;
	}
	double lime_imgui_get_foreground_draw_list(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return getHandleFromPointer((void*)ImGui::GetForegroundDrawList(viewport));
		#endif
		return 0;
	}

	bool lime_imgui_is_rect_visible(float rect_minX, float rect_minY, float rect_maxX, float rect_maxY){
		#ifdef LIME_IMGUI
		return ImGui::IsRectVisible(ImVec2(rect_minX, rect_minY), ImVec2(rect_maxX, rect_maxY));
		#endif
		return false;
	}
	double lime_imgui_get_time(){
		#ifdef LIME_IMGUI
		return ImGui::GetTime();
		#endif
		return 0;
	}
	int lime_imgui_get_frame_count(){
		#ifdef LIME_IMGUI
		return ImGui::GetFrameCount();
		#endif
		return 0;
	}

	void lime_imgui_set_state_storage(double handle){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		ImGui::SetStateStorage(storage);
		#endif
	}
	double lime_imgui_get_state_storage(){
		#ifdef LIME_IMGUI
		return getHandleFromPointer((void*)ImGui::GetStateStorage());
		#endif
		return 0;
	}

	value lime_imgui_calc_text_size(HxString text, HxString text_end, bool hide_text_after_double_hash, float wrap_width){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::CalcTextSize(hxs_utf8(text, nullptr), hxs_utf8(text_end, nullptr), hide_text_after_double_hash, wrap_width);
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}



	bool lime_imgui_is_key_down(int key){
		#ifdef LIME_IMGUI
		return ImGui::IsKeyDown((ImGuiKey)key);
		#endif
		return false;
	}
	bool lime_imgui_is_key_pressed(int key, bool repeat){
		#ifdef LIME_IMGUI
		return ImGui::IsKeyPressed((ImGuiKey)key, repeat);
		#endif
		return false;
	}
	bool lime_imgui_is_key_released(int key){
		#ifdef LIME_IMGUI
		return ImGui::IsKeyReleased((ImGuiKey)key);
		#endif
		return false;
	}
	bool lime_imgui_is_key_chord_pressed(int key_chord){
		#ifdef LIME_IMGUI
		return ImGui::IsKeyChordPressed(key_chord);
		#endif
		return false;
	}
	int lime_imgui_get_key_pressed_amount(int key, float repeat_delay, float rate){
		#ifdef LIME_IMGUI
		return ImGui::GetKeyPressedAmount((ImGuiKey)key, repeat_delay, rate);
		#endif
		return 0;
	}
	HxString lime_imgui_get_key_name(int key){
		#ifdef LIME_IMGUI
		return ImGui::GetKeyName((ImGuiKey)key);
		#endif
		return 0;
	}
	void lime_imgui_set_next_frame_want_capture_keyboard(bool want_capture_keyboard){
		#ifdef LIME_IMGUI
		ImGui::SetNextFrameWantCaptureKeyboard(want_capture_keyboard);
		#endif
	}
	bool lime_imgui_shortcut(int key_chord, int flags){
		#ifdef LIME_IMGUI
		return ImGui::Shortcut(key_chord, flags);
		#endif
		return false;
	}
	void lime_imgui_set_next_item_shortcut(int key_chord, int flags){
		#ifdef LIME_IMGUI
		ImGui::SetNextItemShortcut(key_chord, flags);
		#endif
	}
	bool lime_imgui_set_item_key_owner(int key){
		#ifdef LIME_IMGUI
		return ImGui::SetItemKeyOwner((ImGuiKey)key);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_down(int button){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseDown(button);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_clicked(int button, bool repeat){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseClicked(button, repeat);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_released(int button){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseReleased(button);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_double_clicked(int button){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseDoubleClicked(button);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_released_with_delay(int button, float delay){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseReleasedWithDelay(button, delay);
		#endif
		return false;
	}
	int lime_imgui_get_mouse_clicked_count(int button){
		#ifdef LIME_IMGUI
		return ImGui::GetMouseClickedCount(button);
		#endif
		return 0;
	}
	bool lime_imgui_is_mouse_hovering_rect(float r_minX, float r_minY, float r_maxX, float r_maxY, bool clip){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseHoveringRect(ImVec2(r_minX, r_minY), ImVec2(r_maxX, r_maxY), clip);
		#endif
		return false;
	}
	bool lime_imgui_is_mouse_pos_valid(float posX, float posY){
		#ifdef LIME_IMGUI
		const ImVec2 vec = ImVec2(posX, posY);
		return ImGui::IsMousePosValid(&vec);
		#endif
		return false;
	}
	value lime_imgui_get_mouse_pos(){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetMousePos();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	value lime_imgui_get_mouse_pos_on_opening_current_popup(){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetMousePosOnOpeningCurrentPopup();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	bool lime_imgui_is_mouse_dragging(int button, float lock_threshold){
		#ifdef LIME_IMGUI
		return ImGui::IsMouseDragging(button, lock_threshold);
		#endif
		return false;
	}
	value lime_imgui_get_mouse_drag_delta(int button, float lock_threshold){
		#ifdef LIME_IMGUI
		ImVec2 vec = ImGui::GetMouseDragDelta(button, lock_threshold);
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	void lime_imgui_reset_mouse_drag_delta(int button){
		#ifdef LIME_IMGUI
		ImGui::ResetMouseDragDelta(button);
		#endif
	}
	int lime_imgui_get_mouse_cursor(){
		#ifdef LIME_IMGUI
		return ImGui::GetMouseCursor();
		#endif
		return 0;
	}
	void lime_imgui_set_mouse_cursor(int cursor_type){
		#ifdef LIME_IMGUI
		ImGui::SetMouseCursor(cursor_type);
		#endif
	}
	void lime_imgui_set_next_frame_want_capture_mouse(bool want_capture_mouse){
		#ifdef LIME_IMGUI
		ImGui::SetNextFrameWantCaptureMouse(want_capture_mouse);
		#endif
	}
	HxString lime_imgui_get_clipboard_text(){
		#ifdef LIME_IMGUI
		return ImGui::GetClipboardText();
		#endif
		return 0;
	}
	void lime_imgui_set_clipboard_text(HxString text){
		#ifdef LIME_IMGUI
		ImGui::SetClipboardText(hxs_utf8(text, nullptr));
		#endif
	}

	DEFINE_PRIME0 (lime_imgui_get_style);

	DEFINE_PRIME1v (lime_imgui_show_demo_window);
	DEFINE_PRIME1v (lime_imgui_show_metrics_window);
	DEFINE_PRIME1v (lime_imgui_show_debug_log_window);
	DEFINE_PRIME1v (lime_imgui_show_id_stack_tool_window);
	DEFINE_PRIME1v (lime_imgui_show_about_window);
	DEFINE_PRIME1v (lime_imgui_show_style_editor);
	DEFINE_PRIME1v (lime_imgui_show_style_selector);
	DEFINE_PRIME1v (lime_imgui_show_font_selector);
	DEFINE_PRIME0v (lime_imgui_show_user_guide);
	DEFINE_PRIME0 (lime_imgui_get_version);

	DEFINE_PRIME3 (lime_imgui_begin);
	DEFINE_PRIME0v (lime_imgui_end);

	DEFINE_PRIME5 (lime_imgui_begin_child);
	DEFINE_PRIME0v (lime_imgui_end_child);

	DEFINE_PRIME0 (lime_imgui_is_window_appearing);
	DEFINE_PRIME0 (lime_imgui_is_window_collapsed);
	DEFINE_PRIME1 (lime_imgui_is_window_focused);
	DEFINE_PRIME1 (lime_imgui_is_window_hovered);
	DEFINE_PRIME0 (lime_imgui_get_window_draw_list);
	DEFINE_PRIME0 (lime_imgui_get_window_dpi_scale);
	DEFINE_PRIME0 (lime_imgui_get_window_pos);
	DEFINE_PRIME0 (lime_imgui_get_window_size);
	DEFINE_PRIME0 (lime_imgui_get_window_width);
	DEFINE_PRIME0 (lime_imgui_get_window_height);
	DEFINE_PRIME0 (lime_imgui_get_window_viewport);

    DEFINE_PRIME5v (lime_imgui_set_next_window_pos);
    DEFINE_PRIME3v (lime_imgui_set_next_window_size);
    DEFINE_PRIME4v (lime_imgui_set_next_window_constraints);
    DEFINE_PRIME2v (lime_imgui_set_next_window_content_size);
    DEFINE_PRIME2v (lime_imgui_set_next_window_collapsed);
    DEFINE_PRIME0v (lime_imgui_set_next_window_focus);
    DEFINE_PRIME2v (lime_imgui_set_next_window_scroll);
    DEFINE_PRIME1v (lime_imgui_set_next_window_bg_alpha);
    DEFINE_PRIME1v (lime_imgui_set_next_window_viewport);
    DEFINE_PRIME3v (lime_imgui_set_window_pos);
    DEFINE_PRIME3v (lime_imgui_set_window_size);
    DEFINE_PRIME2v (lime_imgui_set_window_collapsed);
    DEFINE_PRIME0v (lime_imgui_set_window_focus);
    DEFINE_PRIME4v (lime_imgui_set_named_window_pos);
    DEFINE_PRIME4v (lime_imgui_set_named_window_size);
    DEFINE_PRIME3v (lime_imgui_set_named_window_collapsed);
    DEFINE_PRIME1v (lime_imgui_set_named_window_focus);

    DEFINE_PRIME0 (lime_imgui_get_scroll_x);
    DEFINE_PRIME0 (lime_imgui_get_scroll_y);
    DEFINE_PRIME1v (lime_imgui_set_scroll_x);
    DEFINE_PRIME1v (lime_imgui_set_scroll_y);
    DEFINE_PRIME0 (lime_imgui_get_scroll_max_x);
    DEFINE_PRIME0 (lime_imgui_get_scroll_max_y);
    DEFINE_PRIME1v (lime_imgui_set_scroll_here_x);
    DEFINE_PRIME1v (lime_imgui_set_scroll_here_y);
    DEFINE_PRIME2v (lime_imgui_set_scroll_from_pos_x);
    DEFINE_PRIME2v (lime_imgui_set_scroll_from_pos_y);
    
	DEFINE_PRIME2v (lime_imgui_push_font);
	DEFINE_PRIME0v (lime_imgui_pop_font);
	DEFINE_PRIME0 (lime_imgui_get_font);
	DEFINE_PRIME0 (lime_imgui_get_font_size);
	DEFINE_PRIME0 (lime_imgui_get_font_baked);

    DEFINE_PRIME2v (lime_imgui_push_style_color);
    DEFINE_PRIME1v (lime_imgui_pop_style_color);
    DEFINE_PRIME2v (lime_imgui_push_style_var);
    DEFINE_PRIME3v (lime_imgui_push_style_var2);
    DEFINE_PRIME1v (lime_imgui_pop_style_var);
    DEFINE_PRIME2v (lime_imgui_push_item_flag);
    DEFINE_PRIME0v (lime_imgui_pop_item_flag);

    DEFINE_PRIME1v (lime_imgui_push_item_width);
    DEFINE_PRIME0v (lime_imgui_pop_item_width);
    DEFINE_PRIME1v (lime_imgui_set_next_item_width);
    DEFINE_PRIME0 (lime_imgui_calc_item_width);
    DEFINE_PRIME1v (lime_imgui_push_text_wrap_pos);
    DEFINE_PRIME0v (lime_imgui_pop_text_wrap_pos);

    DEFINE_PRIME0 (lime_imgui_get_font_tex_uv_white_pixel);
    DEFINE_PRIME2 (lime_imgui_get_color_u32);
    //DEFINE_PRIME1 (lime_imgui_get_style_color_vec4);

    DEFINE_PRIME0 (lime_imgui_get_cursor_screen_pos);
    DEFINE_PRIME2v (lime_imgui_set_cursor_screen_pos);
    DEFINE_PRIME0 (lime_imgui_get_content_region_avail);
    DEFINE_PRIME0 (lime_imgui_get_cursor_pos);
    DEFINE_PRIME2v (lime_imgui_set_cursor_pos);
    DEFINE_PRIME0 (lime_imgui_get_cursor_start_pos);
    
    DEFINE_PRIME0v (lime_imgui_separator);
    DEFINE_PRIME2v (lime_imgui_sameline);
    DEFINE_PRIME0v (lime_imgui_newline);
    DEFINE_PRIME0v (lime_imgui_spacing);
    DEFINE_PRIME2v (lime_imgui_dummy);
    DEFINE_PRIME1v (lime_imgui_indent);
    DEFINE_PRIME1v (lime_imgui_unindent);
    DEFINE_PRIME0v (lime_imgui_begin_group);
    DEFINE_PRIME0v (lime_imgui_end_group);
    DEFINE_PRIME0v (lime_imgui_align_text_to_frame_padding);
    DEFINE_PRIME0 (lime_imgui_get_text_line_height);
    DEFINE_PRIME0 (lime_imgui_get_text_line_height_with_spacing);
    DEFINE_PRIME0 (lime_imgui_get_frame_height);
    DEFINE_PRIME0 (lime_imgui_get_frame_height_with_spacing);
    
    DEFINE_PRIME1v (lime_imgui_push_id_str);
    DEFINE_PRIME2v (lime_imgui_push_id_str2);
    DEFINE_PRIME1v (lime_imgui_push_id_int);
    DEFINE_PRIME0v (lime_imgui_pop_id);
    DEFINE_PRIME1 (lime_imgui_get_id_str);
    DEFINE_PRIME2 (lime_imgui_get_id_str2);
    DEFINE_PRIME1 (lime_imgui_get_id_int);

    DEFINE_PRIME2v (lime_imgui_text_unformatted);
    DEFINE_PRIME1v (lime_imgui_text);
    DEFINE_PRIME2v (lime_imgui_text_colored);
    DEFINE_PRIME1v (lime_imgui_text_disabled);
    DEFINE_PRIME1v (lime_imgui_text_wrapped);
    DEFINE_PRIME2v (lime_imgui_label_text);
    DEFINE_PRIME1v (lime_imgui_bullet_text);
    DEFINE_PRIME1v (lime_imgui_separator_text);

	DEFINE_PRIME3 (lime_imgui_button);
	DEFINE_PRIME1 (lime_imgui_small_button);
    DEFINE_PRIME4 (lime_imgui_invisible_button);
    DEFINE_PRIME2 (lime_imgui_arrow_button);
    DEFINE_PRIME2 (lime_imgui_checkbox);
    DEFINE_PRIME3 (lime_imgui_checkbox_flags);
    DEFINE_PRIME3 (lime_imgui_radio_button);
    DEFINE_PRIME4v (lime_imgui_progress_bar);
    DEFINE_PRIME0v (lime_imgui_bullet);
    DEFINE_PRIME1 (lime_imgui_text_link);
    DEFINE_PRIME2 (lime_imgui_text_link_open_url);
    
	DEFINE_PRIME7v (lime_imgui_image);
	DEFINE_PRIME9v (lime_imgui_image_with_bg);
	DEFINE_PRIME10 (lime_imgui_image_button);
    
	DEFINE_PRIME3 (lime_imgui_begin_combo);
	DEFINE_PRIME0v (lime_imgui_end_combo);
    DEFINE_PRIME4 (lime_imgui_combo);
    //IMGUI_API bool          Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int popup_max_height_in_items = -1);      // Separate items with \0 within a string, end item-list with \0\0. e.g. "One\0Two\0Three\0"
    //IMGUI_API bool          Combo(const char* label, int* current_item, const char* (*getter)(void* user_data, int idx), void* user_data, int items_count, int popup_max_height_in_items = -1);

    DEFINE_PRIME7 (lime_imgui_drag_float);
    DEFINE_PRIME7 (lime_imgui_drag_float2);
    DEFINE_PRIME7 (lime_imgui_drag_float3);
    DEFINE_PRIME7 (lime_imgui_drag_float4);
    DEFINE_PRIME9 (lime_imgui_drag_float_range2);
    DEFINE_PRIME7 (lime_imgui_drag_int);
    DEFINE_PRIME7 (lime_imgui_drag_int2);
    DEFINE_PRIME7 (lime_imgui_drag_int3);
    DEFINE_PRIME7 (lime_imgui_drag_int4);
    DEFINE_PRIME9 (lime_imgui_drag_int_range2);
    //IMGUI_API bool          DragScalar(const char* label, ImGuiDataType data_type, void* p_data, float v_speed = 1.0f, const void* p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0);
    //IMGUI_API bool          DragScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, float v_speed = 1.0f, const void* p_min = NULL, const void* p_max = NULL, const char* format = NULL, ImGuiSliderFlags flags = 0);

    DEFINE_PRIME6 (lime_imgui_slider_float);
    DEFINE_PRIME6 (lime_imgui_slider_float2);
    DEFINE_PRIME6 (lime_imgui_slider_float3);
    DEFINE_PRIME6 (lime_imgui_slider_float4);
    DEFINE_PRIME6 (lime_imgui_slider_angle);
    DEFINE_PRIME6 (lime_imgui_slider_int);
    DEFINE_PRIME6 (lime_imgui_slider_int2);
    DEFINE_PRIME6 (lime_imgui_slider_int3);
    DEFINE_PRIME6 (lime_imgui_slider_int4);
    //IMGUI_API bool          SliderScalar(const char* label, ImGuiDataType data_type, void* p_data, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);
    //IMGUI_API bool          SliderScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);
    DEFINE_PRIME8 (lime_imgui_vslider_float);
    DEFINE_PRIME8 (lime_imgui_vslider_int);
    //IMGUI_API bool          VSliderScalar(const char* label, const ImVec2& size, ImGuiDataType data_type, void* p_data, const void* p_min, const void* p_max, const char* format = NULL, ImGuiSliderFlags flags = 0);

    DEFINE_PRIME4 (lime_imgui_input_text);
    DEFINE_PRIME6 (lime_imgui_input_multiline);
    DEFINE_PRIME5 (lime_imgui_input_text_with_hint);
    DEFINE_PRIME6 (lime_imgui_input_float);
    DEFINE_PRIME4 (lime_imgui_input_float2);
    DEFINE_PRIME4 (lime_imgui_input_float3);
    DEFINE_PRIME4 (lime_imgui_input_float4);
    DEFINE_PRIME5 (lime_imgui_input_int);
    DEFINE_PRIME3 (lime_imgui_input_int2);
    DEFINE_PRIME3 (lime_imgui_input_int3);
    DEFINE_PRIME3 (lime_imgui_input_int4);
    //IMGUI_API bool          InputDouble(const char* label, double* v, double step = 0.0, double step_fast = 0.0, const char* format = "%.6f", ImGuiInputTextFlags flags = 0);
    //IMGUI_API bool          InputScalar(const char* label, ImGuiDataType data_type, void* p_data, const void* p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0);
    //IMGUI_API bool          InputScalarN(const char* label, ImGuiDataType data_type, void* p_data, int components, const void* p_step = NULL, const void* p_step_fast = NULL, const char* format = NULL, ImGuiInputTextFlags flags = 0);

    DEFINE_PRIME3 (lime_imgui_color_edit3);
    DEFINE_PRIME3 (lime_imgui_color_edit4);
    DEFINE_PRIME3 (lime_imgui_color_picker3);
    DEFINE_PRIME3 (lime_imgui_color_picker4);
    DEFINE_PRIME5 (lime_imgui_color_button);
	DEFINE_PRIME1v (lime_imgui_set_color_edit_options);

	DEFINE_PRIME2 (lime_imgui_tree_node);
	DEFINE_PRIME3 (lime_imgui_tree_node_ex);
	DEFINE_PRIME1v (lime_imgui_tree_push);
	DEFINE_PRIME0v (lime_imgui_tree_pop);
	DEFINE_PRIME0 (lime_imgui_get_tree_node_to_label_spacing);
	DEFINE_PRIME3 (lime_imgui_collapsing_header);
	DEFINE_PRIME2v (lime_imgui_set_next_item_open);
	DEFINE_PRIME1v (lime_imgui_set_next_item_storage_id);
	DEFINE_PRIME1 (lime_imgui_tree_node_get_open);

	DEFINE_PRIME2 (lime_imgui_selectable);
	DEFINE_PRIME3 (lime_imgui_selectable_with_ptr);

    //IMGUI_API ImGuiMultiSelectIO*   BeginMultiSelect(ImGuiMultiSelectFlags flags, int selection_size = -1, int items_count = -1);
    //IMGUI_API ImGuiMultiSelectIO*   EndMultiSelect();
    //IMGUI_API void                  SetNextItemSelectionUserData(ImGuiSelectionUserData selection_user_data);
    //IMGUI_API bool                  IsItemToggledSelection();                                   // Was the last item selection state toggled? Useful if you need the per-item information _before_ reaching EndMultiSelect(). We only returns toggle _event_ in order to handle clipping correctly.

	DEFINE_PRIME3 (lime_imgui_begin_list_box);
	DEFINE_PRIME0v (lime_imgui_end_list_box);
	DEFINE_PRIME4 (lime_imgui_list_box);
	
	DEFINE_PRIME10v (lime_imgui_plot_lines);
	DEFINE_PRIME10v (lime_imgui_plot_histogram);

	DEFINE_PRIME0 (lime_imgui_begin_menu_bar);
	DEFINE_PRIME0v (lime_imgui_end_menu_bar);
	DEFINE_PRIME0 (lime_imgui_begin_main_menu_bar);
	DEFINE_PRIME0v (lime_imgui_end_main_menu_bar);
	DEFINE_PRIME2 (lime_imgui_begin_menu);
	DEFINE_PRIME0v (lime_imgui_end_menu);
	DEFINE_PRIME4 (lime_imgui_menu_item);
	DEFINE_PRIME4 (lime_imgui_menu_item_with_toggle);
	
	DEFINE_PRIME0 (lime_imgui_begin_tooltip);
	DEFINE_PRIME0v (lime_imgui_end_tooltip);
	DEFINE_PRIME1v (lime_imgui_set_tooltip);

	DEFINE_PRIME0 (lime_imgui_begin_item_tooltip);
	DEFINE_PRIME1v (lime_imgui_set_item_tooltip);

	DEFINE_PRIME2 (lime_imgui_begin_popup);
	DEFINE_PRIME3 (lime_imgui_begin_popup_modal);
	DEFINE_PRIME0v (lime_imgui_end_popup);

	DEFINE_PRIME2v (lime_imgui_open_popup);
	DEFINE_PRIME2v (lime_imgui_open_popup_on_item_click);
	DEFINE_PRIME0v (lime_imgui_close_current_popup);

	DEFINE_PRIME2 (lime_imgui_begin_popup_context_item);
	DEFINE_PRIME2 (lime_imgui_begin_popup_context_window);
	DEFINE_PRIME2 (lime_imgui_begin_popup_context_void);
	
	DEFINE_PRIME2 (lime_imgui_is_popup_open);

	DEFINE_PRIME6 (lime_imgui_begin_table);
	DEFINE_PRIME0v (lime_imgui_end_table);
	DEFINE_PRIME2v (lime_imgui_table_next_row);
	DEFINE_PRIME0 (lime_imgui_table_next_column);
	DEFINE_PRIME1 (lime_imgui_table_set_column_index);

	DEFINE_PRIME4v (lime_imgui_table_setup_column);
	DEFINE_PRIME2v (lime_imgui_table_setup_scroll_freeze);
	DEFINE_PRIME1v (lime_imgui_table_header);
	DEFINE_PRIME0v (lime_imgui_table_headers_row);
	DEFINE_PRIME0v (lime_imgui_table_angled_headers_row);
	
	DEFINE_PRIME0 (lime_imgui_table_get_sort_specs);
	DEFINE_PRIME0 (lime_imgui_table_get_column_count);
	DEFINE_PRIME0 (lime_imgui_table_get_column_index);
	DEFINE_PRIME0 (lime_imgui_table_get_row_index);
	DEFINE_PRIME1 (lime_imgui_table_get_column_name);
	DEFINE_PRIME1 (lime_imgui_table_get_column_flags);
	DEFINE_PRIME2v (lime_imgui_table_set_column_enabled);
	DEFINE_PRIME0 (lime_imgui_table_get_hovered_column);
	DEFINE_PRIME3v (lime_imgui_table_set_bg_color);

	DEFINE_PRIME3v (lime_imgui_columns);
	DEFINE_PRIME0v (lime_imgui_next_column);
	DEFINE_PRIME0 (lime_imgui_get_column_index);
	DEFINE_PRIME1 (lime_imgui_get_column_width);
	DEFINE_PRIME2v (lime_imgui_set_column_width);
	DEFINE_PRIME1 (lime_imgui_get_column_offset);
	DEFINE_PRIME2v (lime_imgui_set_column_offset);
	DEFINE_PRIME0 (lime_imgui_get_columns_count);
	
	DEFINE_PRIME2 (lime_imgui_begin_tab_bar);
	DEFINE_PRIME0v (lime_imgui_end_tab_bar);
	DEFINE_PRIME3 (lime_imgui_begin_tab_item);
	DEFINE_PRIME0v (lime_imgui_end_tab_item);
	DEFINE_PRIME2 (lime_imgui_tab_item_button);
	DEFINE_PRIME1v (lime_imgui_set_tab_item_closed);

	DEFINE_PRIME4 (lime_imgui_dock_space);
	DEFINE_PRIME3 (lime_imgui_dock_space_over_viewport);
	DEFINE_PRIME2v (lime_imgui_set_next_window_dock_id);
	DEFINE_PRIME0 (lime_imgui_get_window_dock_id);
	DEFINE_PRIME0 (lime_imgui_is_window_docked);
	
	//IMGUI_API void          LogToTTY(int auto_open_depth = -1);                                 // start logging to tty (stdout)
    //IMGUI_API void          LogToFile(int auto_open_depth = -1, const char* filename = NULL);   // start logging to file
    //IMGUI_API void          LogToClipboard(int auto_open_depth = -1);                           // start logging to OS clipboard
    //IMGUI_API void          LogFinish();                                                        // stop logging (close file, etc.)
    //IMGUI_API void          LogButtons();                                                       // helper to display buttons for logging to tty/file/clipboard
    //IMGUI_API void          LogText(const char* fmt, ...) IM_FMTARGS(1);                        // pass text data straight to log (without being displayed)
    //IMGUI_API void          LogTextV(const char* fmt, va_list args) IM_FMTLIST(1);

	DEFINE_PRIME1 (lime_imgui_begin_drag_drop_source);
	DEFINE_PRIME3 (lime_imgui_set_drag_drop_payload);
	DEFINE_PRIME0v (lime_imgui_end_drag_drop_source);
	DEFINE_PRIME0 (lime_imgui_begin_drag_drop_target);
	DEFINE_PRIME2 (lime_imgui_accept_drag_drop_payload);
	DEFINE_PRIME0v (lime_imgui_end_drag_drop_target);
	DEFINE_PRIME0 (lime_imgui_get_drag_drop_payload);

	DEFINE_PRIME1v (lime_imgui_begin_disabled);
	DEFINE_PRIME0v (lime_imgui_end_disabled);

	DEFINE_PRIME5v (lime_imgui_push_clip_rect);
	DEFINE_PRIME0v (lime_imgui_pop_clip_rect);

	DEFINE_PRIME0v (lime_imgui_set_item_default_focus);
	DEFINE_PRIME1v (lime_imgui_set_keyboard_focus_here);

	DEFINE_PRIME1v (lime_imgui_set_nav_cursor_visible);

	DEFINE_PRIME0v (lime_imgui_set_next_item_allow_overlap);
    
	DEFINE_PRIME1 (lime_imgui_is_item_hovered);
	DEFINE_PRIME0 (lime_imgui_is_item_active);
	DEFINE_PRIME0 (lime_imgui_is_item_focused);
	DEFINE_PRIME1 (lime_imgui_is_item_clicked);
	DEFINE_PRIME0 (lime_imgui_is_item_visible);
	DEFINE_PRIME0 (lime_imgui_is_item_edited);
	DEFINE_PRIME0 (lime_imgui_is_item_activated);
	DEFINE_PRIME0 (lime_imgui_is_item_deactivated);
	DEFINE_PRIME0 (lime_imgui_is_item_deactivated_after_edit);
	DEFINE_PRIME0 (lime_imgui_is_item_toggled_open);
	DEFINE_PRIME0 (lime_imgui_is_any_item_hovered);
	DEFINE_PRIME0 (lime_imgui_is_any_item_active);
	DEFINE_PRIME0 (lime_imgui_is_any_item_focused);
	DEFINE_PRIME0 (lime_imgui_get_item_id);
	DEFINE_PRIME0 (lime_imgui_get_item_rect_min);
	DEFINE_PRIME0 (lime_imgui_get_item_rect_max);
	DEFINE_PRIME0 (lime_imgui_get_item_rect_size);
	DEFINE_PRIME0 (lime_imgui_get_item_flags);
    
	DEFINE_PRIME0 (lime_imgui_get_main_viewport);

	DEFINE_PRIME1 (lime_imgui_get_background_draw_list);
	DEFINE_PRIME1 (lime_imgui_get_foreground_draw_list);
    
	DEFINE_PRIME4 (lime_imgui_is_rect_visible);
	DEFINE_PRIME0 (lime_imgui_get_time);
	DEFINE_PRIME0 (lime_imgui_get_frame_count);
    //IMGUI_API ImDrawListSharedData* GetDrawListSharedData();                                    // you may use this when creating your own ImDrawList instances.
    //IMGUI_API const char*   GetStyleColorName(ImGuiCol idx);                                    // get a string corresponding to the enum value (for display, saving, etc.).
    DEFINE_PRIME1v (lime_imgui_set_state_storage);
	DEFINE_PRIME0 (lime_imgui_get_state_storage);

	DEFINE_PRIME4 (lime_imgui_calc_text_size);

    DEFINE_PRIME1 (lime_imgui_is_key_down);
	DEFINE_PRIME2 (lime_imgui_is_key_pressed);
	DEFINE_PRIME1 (lime_imgui_is_key_released);
	DEFINE_PRIME1 (lime_imgui_is_key_chord_pressed);
	DEFINE_PRIME3 (lime_imgui_get_key_pressed_amount);
	DEFINE_PRIME1 (lime_imgui_get_key_name);
	DEFINE_PRIME1v (lime_imgui_set_next_frame_want_capture_keyboard);

	DEFINE_PRIME2 (lime_imgui_shortcut);
	DEFINE_PRIME2v (lime_imgui_set_next_item_shortcut);

	DEFINE_PRIME1 (lime_imgui_set_item_key_owner);

	DEFINE_PRIME1 (lime_imgui_is_mouse_down);
	DEFINE_PRIME2 (lime_imgui_is_mouse_clicked);
	DEFINE_PRIME1 (lime_imgui_is_mouse_released);
	DEFINE_PRIME1 (lime_imgui_is_mouse_double_clicked);
	DEFINE_PRIME2 (lime_imgui_is_mouse_released_with_delay);
	DEFINE_PRIME1 (lime_imgui_get_mouse_clicked_count);
	DEFINE_PRIME5 (lime_imgui_is_mouse_hovering_rect);
	DEFINE_PRIME2 (lime_imgui_is_mouse_pos_valid);
	DEFINE_PRIME0 (lime_imgui_get_mouse_pos);
	DEFINE_PRIME0 (lime_imgui_get_mouse_pos_on_opening_current_popup);
	DEFINE_PRIME2 (lime_imgui_is_mouse_dragging);
	DEFINE_PRIME2 (lime_imgui_get_mouse_drag_delta);
	DEFINE_PRIME1v (lime_imgui_reset_mouse_drag_delta);
	DEFINE_PRIME0 (lime_imgui_get_mouse_cursor);
	DEFINE_PRIME1v (lime_imgui_set_mouse_cursor);
	DEFINE_PRIME1v (lime_imgui_set_next_frame_want_capture_mouse);

	DEFINE_PRIME0 (lime_imgui_get_clipboard_text);
	DEFINE_PRIME1v (lime_imgui_set_clipboard_text);
    
	//ImDrawList

	void lime_imgui_draw_list_push_clip_rect(double handle, float clip_rect_minX, float clip_rect_minY, float clip_rect_maxX, float clip_rect_maxY, bool intersect_with_current_clip_rect){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PushClipRect(ImVec2(clip_rect_minX, clip_rect_minY), ImVec2(clip_rect_maxX, clip_rect_maxY), intersect_with_current_clip_rect);
		#endif
	}
	void lime_imgui_draw_list_push_clip_rect_full_screen(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PushClipRectFullScreen();
		#endif
	}
	void lime_imgui_draw_list_pop_clip_rect(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PopClipRect();
		#endif
	}
	void lime_imgui_draw_list_push_texture(double handle, int tex_ref){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PushTexture(tex_ref);
		#endif
	}
	void lime_imgui_draw_list_pop_texture(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PopTexture();
		#endif
	}
	value lime_imgui_draw_list_get_clip_rect_min(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		ImVec2 vec = drawList->GetClipRectMin();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	value lime_imgui_draw_list_get_clip_rect_max(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		ImVec2 vec = drawList->GetClipRectMax();
		return Vector2(vec.x, vec.y).Value();
		#endif
		return Vector2(0.0, 0.0).Value();
	}
	void lime_imgui_draw_list_add_line(double handle, value points, int col, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddLine(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))), 
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			col, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_line_h(double handle, float min_x, float max_x, float y, int col, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddLineH(min_x, max_x, y, col, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_line_v(double handle, float x, float min_y, float max_y, int col, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddLineV(x, min_y, max_y, col, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_rect(double handle, value points, int col, float rounding, float thickness, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddRect(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			col, rounding, thickness, flags);
		#endif
	}
	void lime_imgui_draw_list_add_rect_filled(double handle, value points, int col, float rounding, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddRectFilled(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			col, rounding, flags);
		#endif
	}
	void lime_imgui_draw_list_add_rect_filled_multi_color(double handle, value points, int col_upr_left, int col_upr_right, int col_bot_right, int col_bot_left){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddRectFilledMultiColor(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))),
			col_upr_left, col_upr_right, col_bot_right, col_bot_left);
		#endif
	}
	void lime_imgui_draw_list_add_quad(double handle, value points, int col, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddQuad(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			ImVec2(val_float(val_array_i(points, 6)), val_float(val_array_i (points, 7))), 
			col, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_quad_filled(double handle, value points, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddQuadFilled(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			ImVec2(val_float(val_array_i(points, 6)), val_float(val_array_i (points, 7))),
			col);
		#endif
	}
	void lime_imgui_draw_list_add_triangle(double handle, value points, int col, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddTriangle(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			col, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_triangle_filled(double handle, value points, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddTriangleFilled(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			col);
		#endif
	}
	void lime_imgui_draw_list_add_circle(double handle, float centerX, float centerY, float radius, int col, int num_segments, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddCircle(ImVec2(centerX, centerY), radius, col, num_segments, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_circle_filled(double handle, float centerX, float centerY, float radius, int col, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddCircleFilled(ImVec2(centerX, centerY), radius, col, num_segments);
		#endif
	}
	void lime_imgui_draw_list_add_ngon(double handle, float centerX, float centerY, float radius, int col, int num_segments, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddNgon(ImVec2(centerX, centerY), radius, col, num_segments, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_ngon_filled(double handle, float centerX, float centerY, float radius, int col, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddNgonFilled(ImVec2(centerX, centerY), radius, col, num_segments);
		#endif
	}
	void lime_imgui_draw_list_add_ellipse(double handle, float centerX, float centerY, float radiusX, float radiusY, int col, float rot, int num_segments, float thickness){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddEllipse(ImVec2(centerX, centerY), ImVec2(radiusX, radiusY), col, rot, num_segments, thickness);
		#endif
	}
	void lime_imgui_draw_list_add_ellipse_filled(double handle, float centerX, float centerY, float radiusX, float radiusY, int col, float rot, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddEllipseFilled(ImVec2(centerX, centerY), ImVec2(radiusX, radiusY), col, rot, num_segments);
		#endif
	}
	void lime_imgui_draw_list_add_text(double handle, float posX, float posY, int col, HxString text_begin, HxString text_end){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddText(ImVec2(posX, posY), col, hxs_utf8(text_begin, nullptr), hxs_utf8(text_end, nullptr));
		#endif
	}
	/*void lime_imgui_draw_list_add_text(double handle, value font, float font_size, float posX, float posY, int col, HxString text_begin, HxString text_end, float wrap_width, int cpu_fine_clip_rect){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddText(font, font_size, ImVec2(posX, posY), col, hxs_utf8(text_begin, nullptr), hxs_utf8(text_end, nullptr), wrap_width, cpu_fine_clip_rect);
		#endif
	}*/
	void lime_imgui_draw_list_add_bezier_cubic(double handle, value points, int col, float thickness, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddBezierCubic(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			ImVec2(val_float(val_array_i(points, 6)), val_float(val_array_i (points, 7))),
			col, thickness, num_segments);
		#endif
	}
	void lime_imgui_draw_list_add_bezier_quadratic(double handle, value points, int col, float thickness, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddBezierQuadratic(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			col, thickness, num_segments);
		#endif
	}

	void lime_imgui_draw_list_add_polyline(double handle, value points, int num_points, int col, float thickness, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		ImVector<ImVec2> pointsVec2;
		fillImVec2VectorFromHXArray(pointsVec2, points);
		drawList->AddPolyline(pointsVec2.Data, num_points, col, thickness, flags);
		#endif
	}
	void lime_imgui_draw_list_add_convex_poly_filled(double handle, value points, int num_points, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		ImVector<ImVec2> pointsVec2;
		fillImVec2VectorFromHXArray(pointsVec2, points);
		drawList->AddConvexPolyFilled(pointsVec2.Data, num_points, col);
		#endif
	}
	void lime_imgui_draw_list_add_concave_poly_filled(double handle, value points, int num_points, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		ImVector<ImVec2> pointsVec2;
		fillImVec2VectorFromHXArray(pointsVec2, points);
		drawList->AddConcavePolyFilled(pointsVec2.Data, num_points, col);
		#endif
	}

	void lime_imgui_draw_list_add_image(double handle, int tex_ref, value points, value uvPoints, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddImage(tex_ref, 
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(uvPoints, 0)), val_float(val_array_i (uvPoints, 1))), 
			ImVec2(val_float(val_array_i(uvPoints, 2)), val_float(val_array_i (uvPoints, 3))),
			col);
		#endif
	}
	void lime_imgui_draw_list_add_image_quad(double handle, int tex_ref, value points, value uvPoints, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddImageQuad(tex_ref,
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			ImVec2(val_float(val_array_i(points, 6)), val_float(val_array_i (points, 7))),
			ImVec2(val_float(val_array_i(uvPoints, 0)), val_float(val_array_i (uvPoints, 1))),
			ImVec2(val_float(val_array_i(uvPoints, 2)), val_float(val_array_i (uvPoints, 3))), 
			ImVec2(val_float(val_array_i(uvPoints, 4)), val_float(val_array_i (uvPoints, 5))), 
			ImVec2(val_float(val_array_i(uvPoints, 6)), val_float(val_array_i (uvPoints, 7))),
			col);
		#endif
	}
	void lime_imgui_draw_list_add_image_rounded(double handle, int tex_ref, value points, value uvPoints, int col, float rounding, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddImageRounded(tex_ref,
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(uvPoints, 0)), val_float(val_array_i (uvPoints, 1))), 
			ImVec2(val_float(val_array_i(uvPoints, 2)), val_float(val_array_i (uvPoints, 3))),
			col, rounding, flags);
		#endif
	}
	void lime_imgui_draw_list_path_clear(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathClear();
		#endif
	}
	void lime_imgui_draw_list_path_line_to(double handle, float posX, float posY){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathLineTo(ImVec2(posX, posY));
		#endif
	}
	void lime_imgui_draw_list_path_line_to_merge_duplicate(double handle, float posX, float posY){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathLineToMergeDuplicate(ImVec2(posX, posY));
		#endif
	}
	void lime_imgui_draw_list_path_fill_convex(double handle, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathFillConvex(col);
		#endif
	}
	void lime_imgui_draw_list_path_fill_concave(double handle, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathFillConcave(col);
		#endif
	}
	void lime_imgui_draw_list_path_stroke(double handle, int col, float thickness, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathStroke(col, thickness, flags);
		#endif
	}
	void lime_imgui_draw_list_path_arc_to(double handle, float centerX, float centerY, float radius, float a_min, float a_max, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathArcTo(ImVec2(centerX, centerY), radius, a_min, a_max, num_segments);
		#endif
	}
	void lime_imgui_draw_list_path_arc_to_fast(double handle, float centerX, float centerY, float radius, int a_min_of_12, int a_max_of_12){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathArcToFast(ImVec2(centerX, centerY), radius, a_min_of_12, a_max_of_12);
		#endif
	}
	void lime_imgui_draw_list_path_elliptical_arc_to(double handle, float centerX, float centerY, float radiusX, float radiusY, float rot, float a_min, float a_max, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathEllipticalArcTo(ImVec2(centerX, centerY), ImVec2(radiusX, radiusY), rot, a_min, a_max, num_segments);
		#endif
	}
	void lime_imgui_draw_list_path_bezier_cubic_curve_to(double handle, value points, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathBezierCubicCurveTo(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			num_segments);
		#endif
	}
	void lime_imgui_draw_list_path_bezier_quadratic_curve_to(double handle, value points, int num_segments){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathBezierQuadraticCurveTo(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			num_segments);
		#endif
	}
	void lime_imgui_draw_list_path_rect(double handle, float rect_minX, float rect_minY, float rect_maxX, float rect_maxY, float rounding, int flags){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PathRect(ImVec2(rect_minX, rect_minY), ImVec2(rect_maxX, rect_maxY), rounding, flags);
		#endif
	}
	void lime_imgui_draw_list_add_draw_cmd(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->AddDrawCmd();
		#endif
	}
	/*double lime_imgui_draw_list_clone_output(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		return getHandleFromPointer(drawList->CloneOutput());
		#endif
		return 0.0;
	}*/
	void lime_imgui_draw_list_channels_split(double handle, int count){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->ChannelsSplit(count);
		#endif
	}
	void lime_imgui_draw_list_channels_merge(double handle){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->ChannelsMerge();
		#endif
	}
	void lime_imgui_draw_list_channels_set_current(double handle, int n){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->ChannelsSetCurrent(n);
		#endif
	}
	void lime_imgui_draw_list_prim_reserve(double handle, int idx_count, int vtx_count){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimReserve(idx_count, vtx_count);
		#endif
	}
	void lime_imgui_draw_list_prim_unreserve(double handle, int idx_count, int vtx_count){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimUnreserve(idx_count, vtx_count);
		#endif
	}
	void lime_imgui_draw_list_prim_rect(double handle, value points, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimRect(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			col);
		#endif
	}
	void lime_imgui_draw_list_prim_rect_u_v(double handle, value points, value uvPoints, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimRectUV(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(uvPoints, 0)), val_float(val_array_i (uvPoints, 1))), 
			ImVec2(val_float(val_array_i(uvPoints, 2)), val_float(val_array_i (uvPoints, 3))),
			col);
		#endif
	}
	void lime_imgui_draw_list_prim_quad_u_v(double handle, value points, value uvPoints, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimQuadUV(
			ImVec2(val_float(val_array_i(points, 0)), val_float(val_array_i (points, 1))),
			ImVec2(val_float(val_array_i(points, 2)), val_float(val_array_i (points, 3))), 
			ImVec2(val_float(val_array_i(points, 4)), val_float(val_array_i (points, 5))), 
			ImVec2(val_float(val_array_i(points, 6)), val_float(val_array_i (points, 7))),
			ImVec2(val_float(val_array_i(uvPoints, 0)), val_float(val_array_i (uvPoints, 1))),
			ImVec2(val_float(val_array_i(uvPoints, 2)), val_float(val_array_i (uvPoints, 3))), 
			ImVec2(val_float(val_array_i(uvPoints, 4)), val_float(val_array_i (uvPoints, 5))), 
			ImVec2(val_float(val_array_i(uvPoints, 6)), val_float(val_array_i (uvPoints, 7))),
			col);
		#endif
	}
	void lime_imgui_draw_list_prim_write_vtx(double handle, float posX, float posY, float uvX, float uvY, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimWriteVtx(ImVec2(posX, posY), ImVec2(uvX, uvY), col);
		#endif
	}
	void lime_imgui_draw_list_prim_write_idx(double handle, int idx){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimWriteIdx(idx);
		#endif
	}
	void lime_imgui_draw_list_prim_vtx(double handle, float posX, float posY, float uvX, float uvY, int col){
		#ifdef LIME_IMGUI
		ImDrawList* drawList = (ImDrawList*)getPointerFromHandle(handle);
		drawList->PrimVtx(ImVec2(posX, posY), ImVec2(uvX, uvY), col);
		#endif
	}

	DEFINE_PRIME6v (lime_imgui_draw_list_push_clip_rect);
	DEFINE_PRIME1v (lime_imgui_draw_list_push_clip_rect_full_screen);
	DEFINE_PRIME1v (lime_imgui_draw_list_pop_clip_rect);
	DEFINE_PRIME2v (lime_imgui_draw_list_push_texture);
	DEFINE_PRIME1v (lime_imgui_draw_list_pop_texture);
	DEFINE_PRIME1 (lime_imgui_draw_list_get_clip_rect_min);
	DEFINE_PRIME1 (lime_imgui_draw_list_get_clip_rect_max);
	DEFINE_PRIME4v (lime_imgui_draw_list_add_line);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_line_h);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_line_v);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_rect);
	DEFINE_PRIME5v (lime_imgui_draw_list_add_rect_filled);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_rect_filled_multi_color);
	DEFINE_PRIME4v (lime_imgui_draw_list_add_quad);
	DEFINE_PRIME3v (lime_imgui_draw_list_add_quad_filled);
	DEFINE_PRIME4v (lime_imgui_draw_list_add_triangle);
	DEFINE_PRIME3v (lime_imgui_draw_list_add_triangle_filled);
	DEFINE_PRIME7v (lime_imgui_draw_list_add_circle);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_circle_filled);
	DEFINE_PRIME7v (lime_imgui_draw_list_add_ngon);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_ngon_filled);
	DEFINE_PRIME9v (lime_imgui_draw_list_add_ellipse);
	DEFINE_PRIME8v (lime_imgui_draw_list_add_ellipse_filled);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_text);
	//DEFINE_PRIME10v (lime_imgui_draw_list_add_text);
	DEFINE_PRIME5v (lime_imgui_draw_list_add_bezier_cubic);
	DEFINE_PRIME5v (lime_imgui_draw_list_add_bezier_quadratic);
	DEFINE_PRIME6v (lime_imgui_draw_list_add_polyline);
	DEFINE_PRIME4v (lime_imgui_draw_list_add_convex_poly_filled);
	DEFINE_PRIME4v (lime_imgui_draw_list_add_concave_poly_filled);
	DEFINE_PRIME5v (lime_imgui_draw_list_add_image);
	DEFINE_PRIME5v (lime_imgui_draw_list_add_image_quad);
	DEFINE_PRIME7v (lime_imgui_draw_list_add_image_rounded);
	DEFINE_PRIME1v (lime_imgui_draw_list_path_clear);
	DEFINE_PRIME3v (lime_imgui_draw_list_path_line_to);
	DEFINE_PRIME3v (lime_imgui_draw_list_path_line_to_merge_duplicate);
	DEFINE_PRIME2v (lime_imgui_draw_list_path_fill_convex);
	DEFINE_PRIME2v (lime_imgui_draw_list_path_fill_concave);
	DEFINE_PRIME4v (lime_imgui_draw_list_path_stroke);
	DEFINE_PRIME7v (lime_imgui_draw_list_path_arc_to);
	DEFINE_PRIME6v (lime_imgui_draw_list_path_arc_to_fast);
	DEFINE_PRIME9v (lime_imgui_draw_list_path_elliptical_arc_to);
	DEFINE_PRIME3v (lime_imgui_draw_list_path_bezier_cubic_curve_to);
	DEFINE_PRIME3v (lime_imgui_draw_list_path_bezier_quadratic_curve_to);
	DEFINE_PRIME7v (lime_imgui_draw_list_path_rect);
	DEFINE_PRIME1v (lime_imgui_draw_list_add_draw_cmd);
	//DEFINE_PRIME1 (lime_imgui_draw_list_clone_output);
	DEFINE_PRIME2v (lime_imgui_draw_list_channels_split);
	DEFINE_PRIME1v (lime_imgui_draw_list_channels_merge);
	DEFINE_PRIME2v (lime_imgui_draw_list_channels_set_current);
	DEFINE_PRIME3v (lime_imgui_draw_list_prim_reserve);
	DEFINE_PRIME3v (lime_imgui_draw_list_prim_unreserve);
	DEFINE_PRIME3v (lime_imgui_draw_list_prim_rect);
	DEFINE_PRIME4v (lime_imgui_draw_list_prim_rect_u_v);
	DEFINE_PRIME4v (lime_imgui_draw_list_prim_quad_u_v);
	DEFINE_PRIME6v (lime_imgui_draw_list_prim_write_vtx);
	DEFINE_PRIME2v (lime_imgui_draw_list_prim_write_idx);
	DEFINE_PRIME6v (lime_imgui_draw_list_prim_vtx);

	//ImGuiIO/////////////////////////////////

	int lime_imgui_io_get_config_flags(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigFlags;
		#endif
		return 0;
	}
	int lime_imgui_io_set_config_flags(int ConfigFlags){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigFlags = ConfigFlags;
		#endif
		return 0;
	}
	int lime_imgui_io_get_backend_flags(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.BackendFlags;
		#endif
		return 0;
	}
	int lime_imgui_io_set_backend_flags(int BackendFlags){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.BackendFlags = BackendFlags;
		#endif
		return 0;
	}
	float lime_imgui_io_get_display_size_x(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplaySize.x;
		#endif
		return 0;
	}
	float lime_imgui_io_set_display_size_x(float DisplaySizeX){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplaySize.x = DisplaySizeX;
		#endif
		return 0;
	}
	float lime_imgui_io_get_display_size_y(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplaySize.y;
		#endif
		return 0;
	}
	float lime_imgui_io_set_display_size_y(float DisplaySizeY){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplaySize.y = DisplaySizeY;
		#endif
		return 0;
	}
	float lime_imgui_io_get_display_framebuffer_scale_x(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplayFramebufferScale.x;
		#endif
		return 0;
	}
	float lime_imgui_io_set_display_framebuffer_scale_x(float DisplayFramebufferScaleX){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplayFramebufferScale.x = DisplayFramebufferScaleX;
		#endif
		return 0;
	}
	float lime_imgui_io_get_display_framebuffer_scale_y(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplayFramebufferScale.y;
		#endif
		return 0;
	}
	float lime_imgui_io_set_display_framebuffer_scale_y(float DisplayFramebufferScaleY){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DisplayFramebufferScale.y = DisplayFramebufferScaleY;
		#endif
		return 0;
	}
	float lime_imgui_io_get_delta_time(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DeltaTime;
		#endif
		return 0;
	}
	float lime_imgui_io_set_delta_time(float DeltaTime){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.DeltaTime = DeltaTime;
		#endif
		return 0;
	}
	float lime_imgui_io_get_ini_saving_rate(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.IniSavingRate;
		#endif
		return 0;
	}
	float lime_imgui_io_set_ini_saving_rate(float IniSavingRate){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.IniSavingRate = IniSavingRate;
		#endif
		return 0;
	}
	HxString lime_imgui_io_get_ini_filename(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.IniFilename;
		#endif
		return 0;
	}
	HxString lime_imgui_io_set_ini_filename(HxString IniFilename){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.IniFilename = hxs_utf8(IniFilename, nullptr);
		#endif
		return 0;
	}
	HxString lime_imgui_io_get_log_filename(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.LogFilename;
		#endif
		return 0;
	}
	HxString lime_imgui_io_set_log_filename(HxString LogFilename){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.LogFilename = hxs_utf8(LogFilename, nullptr);
		#endif
		return 0;
	}
	double lime_imgui_io_get_fonts(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return getHandleFromPointer((void*)io.Fonts);
		#endif
		return 0;
	}
	/*value lime_imgui_io_set_fonts(value Fonts){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.Fonts = Fonts;
		#endif
		return 0;
	}*/
	double lime_imgui_io_get_font_default(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return getHandleFromPointer((void*)io.FontDefault);
		#endif
		return 0;
	}
	double lime_imgui_io_set_font_default(double handle){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		ImFont* font = (ImFont*)getPointerFromHandle(handle);
		io.FontDefault = font;
		return getHandleFromPointer((void*)io.FontDefault);
		#endif
		return 0;
	}
	bool lime_imgui_io_get_font_allow_user_scaling(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.FontAllowUserScaling;
		#endif
		return false;
	}
	bool lime_imgui_io_set_font_allow_user_scaling(bool FontAllowUserScaling){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.FontAllowUserScaling = FontAllowUserScaling;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_swap_gamepad_buttons(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavSwapGamepadButtons;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_swap_gamepad_buttons(bool ConfigNavSwapGamepadButtons){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavSwapGamepadButtons = ConfigNavSwapGamepadButtons;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_move_set_mouse_pos(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavMoveSetMousePos;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_move_set_mouse_pos(bool ConfigNavMoveSetMousePos){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavMoveSetMousePos = ConfigNavMoveSetMousePos;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_capture_keyboard(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCaptureKeyboard;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_capture_keyboard(bool ConfigNavCaptureKeyboard){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCaptureKeyboard = ConfigNavCaptureKeyboard;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_escape_clear_focus_item(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavEscapeClearFocusItem;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_escape_clear_focus_item(bool ConfigNavEscapeClearFocusItem){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavEscapeClearFocusItem = ConfigNavEscapeClearFocusItem;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_escape_clear_focus_window(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavEscapeClearFocusWindow;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_escape_clear_focus_window(bool ConfigNavEscapeClearFocusWindow){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavEscapeClearFocusWindow = ConfigNavEscapeClearFocusWindow;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_cursor_visible_auto(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCursorVisibleAuto;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_cursor_visible_auto(bool ConfigNavCursorVisibleAuto){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCursorVisibleAuto = ConfigNavCursorVisibleAuto;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_nav_cursor_visible_always(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCursorVisibleAlways;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_nav_cursor_visible_always(bool ConfigNavCursorVisibleAlways){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigNavCursorVisibleAlways = ConfigNavCursorVisibleAlways;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_docking_no_split(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingNoSplit;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_docking_no_split(bool ConfigDockingNoSplit){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingNoSplit = ConfigDockingNoSplit;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_docking_no_docking_over(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingNoDockingOver;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_docking_no_docking_over(bool ConfigDockingNoDockingOver){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingNoDockingOver = ConfigDockingNoDockingOver;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_docking_with_shift(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingWithShift;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_docking_with_shift(bool ConfigDockingWithShift){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingWithShift = ConfigDockingWithShift;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_docking_always_tab_bar(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingAlwaysTabBar;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_docking_always_tab_bar(bool ConfigDockingAlwaysTabBar){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingAlwaysTabBar = ConfigDockingAlwaysTabBar;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_docking_transparent_payload(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingTransparentPayload;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_docking_transparent_payload(bool ConfigDockingTransparentPayload){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDockingTransparentPayload = ConfigDockingTransparentPayload;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_viewports_no_auto_merge(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoAutoMerge;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_viewports_no_auto_merge(bool ConfigViewportsNoAutoMerge){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoAutoMerge = ConfigViewportsNoAutoMerge;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_viewports_no_task_bar_icon(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoTaskBarIcon;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_viewports_no_task_bar_icon(bool ConfigViewportsNoTaskBarIcon){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoTaskBarIcon = ConfigViewportsNoTaskBarIcon;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_viewports_no_decoration(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoDecoration;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_viewports_no_decoration(bool ConfigViewportsNoDecoration){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoDecoration = ConfigViewportsNoDecoration;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_viewports_no_default_parent(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoDefaultParent;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_viewports_no_default_parent(bool ConfigViewportsNoDefaultParent){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsNoDefaultParent = ConfigViewportsNoDefaultParent;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_viewports_platform_focus_sets_im_gui_focus(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsPlatformFocusSetsImGuiFocus;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_viewports_platform_focus_sets_im_gui_focus(bool ConfigViewportsPlatformFocusSetsImGuiFocus){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigViewportsPlatformFocusSetsImGuiFocus = ConfigViewportsPlatformFocusSetsImGuiFocus;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_dpi_scale_fonts(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDpiScaleFonts;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_dpi_scale_fonts(bool ConfigDpiScaleFonts){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDpiScaleFonts = ConfigDpiScaleFonts;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_dpi_scale_viewports(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDpiScaleViewports;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_dpi_scale_viewports(bool ConfigDpiScaleViewports){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDpiScaleViewports = ConfigDpiScaleViewports;
		#endif
		return false;
	}
	bool lime_imgui_io_get_mouse_draw_cursor(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDrawCursor;
		#endif
		return false;
	}
	bool lime_imgui_io_set_mouse_draw_cursor(bool MouseDrawCursor){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDrawCursor = MouseDrawCursor;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_mac_o_s_x_behaviors(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigMacOSXBehaviors;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_mac_o_s_x_behaviors(bool ConfigMacOSXBehaviors){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigMacOSXBehaviors = ConfigMacOSXBehaviors;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_input_text_cursor_blink(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigInputTextCursorBlink;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_input_text_cursor_blink(bool ConfigInputTextCursorBlink){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigInputTextCursorBlink = ConfigInputTextCursorBlink;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_input_text_enter_keep_active(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigInputTextEnterKeepActive;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_input_text_enter_keep_active(bool ConfigInputTextEnterKeepActive){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigInputTextEnterKeepActive = ConfigInputTextEnterKeepActive;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_drag_click_to_input_text(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDragClickToInputText;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_drag_click_to_input_text(bool ConfigDragClickToInputText){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDragClickToInputText = ConfigDragClickToInputText;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_windows_resize_from_edges(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsResizeFromEdges;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_windows_resize_from_edges(bool ConfigWindowsResizeFromEdges){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsResizeFromEdges = ConfigWindowsResizeFromEdges;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_windows_move_from_title_bar_only(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsMoveFromTitleBarOnly;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_windows_move_from_title_bar_only(bool ConfigWindowsMoveFromTitleBarOnly){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsMoveFromTitleBarOnly = ConfigWindowsMoveFromTitleBarOnly;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_windows_copy_contents_with_ctrl_c(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsCopyContentsWithCtrlC;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_windows_copy_contents_with_ctrl_c(bool ConfigWindowsCopyContentsWithCtrlC){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigWindowsCopyContentsWithCtrlC = ConfigWindowsCopyContentsWithCtrlC;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_scrollbar_scroll_by_page(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigScrollbarScrollByPage;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_scrollbar_scroll_by_page(bool ConfigScrollbarScrollByPage){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigScrollbarScrollByPage = ConfigScrollbarScrollByPage;
		#endif
		return false;
	}
	float lime_imgui_io_get_config_memory_compact_timer(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigMemoryCompactTimer;
		#endif
		return 0;
	}
	float lime_imgui_io_set_config_memory_compact_timer(float ConfigMemoryCompactTimer){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigMemoryCompactTimer = ConfigMemoryCompactTimer;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_double_click_time(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDoubleClickTime;
		#endif
		return 0;
	}
	float lime_imgui_io_set_mouse_double_click_time(float MouseDoubleClickTime){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDoubleClickTime = MouseDoubleClickTime;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_double_click_max_dist(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDoubleClickMaxDist;
		#endif
		return 0;
	}
	float lime_imgui_io_set_mouse_double_click_max_dist(float MouseDoubleClickMaxDist){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDoubleClickMaxDist = MouseDoubleClickMaxDist;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_drag_threshold(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDragThreshold;
		#endif
		return 0;
	}
	float lime_imgui_io_set_mouse_drag_threshold(float MouseDragThreshold){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDragThreshold = MouseDragThreshold;
		#endif
		return 0;
	}
	float lime_imgui_io_get_key_repeat_delay(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyRepeatDelay;
		#endif
		return 0;
	}
	float lime_imgui_io_set_key_repeat_delay(float KeyRepeatDelay){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyRepeatDelay = KeyRepeatDelay;
		#endif
		return 0;
	}
	float lime_imgui_io_get_key_repeat_rate(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyRepeatRate;
		#endif
		return 0;
	}
	float lime_imgui_io_set_key_repeat_rate(float KeyRepeatRate){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyRepeatRate = KeyRepeatRate;
		#endif
		return 0;
	}
	bool lime_imgui_io_get_config_error_recovery(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecovery;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_error_recovery(bool ConfigErrorRecovery){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecovery = ConfigErrorRecovery;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_error_recovery_enable_assert(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableAssert;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_error_recovery_enable_assert(bool ConfigErrorRecoveryEnableAssert){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableAssert = ConfigErrorRecoveryEnableAssert;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_error_recovery_enable_debug_log(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableDebugLog;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_error_recovery_enable_debug_log(bool ConfigErrorRecoveryEnableDebugLog){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableDebugLog = ConfigErrorRecoveryEnableDebugLog;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_error_recovery_enable_tooltip(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableTooltip;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_error_recovery_enable_tooltip(bool ConfigErrorRecoveryEnableTooltip){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigErrorRecoveryEnableTooltip = ConfigErrorRecoveryEnableTooltip;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_is_debugger_present(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIsDebuggerPresent;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_is_debugger_present(bool ConfigDebugIsDebuggerPresent){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIsDebuggerPresent = ConfigDebugIsDebuggerPresent;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_highlight_id_conflicts(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugHighlightIdConflicts;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_highlight_id_conflicts(bool ConfigDebugHighlightIdConflicts){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugHighlightIdConflicts = ConfigDebugHighlightIdConflicts;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_highlight_id_conflicts_show_item_picker(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugHighlightIdConflictsShowItemPicker;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_highlight_id_conflicts_show_item_picker(bool ConfigDebugHighlightIdConflictsShowItemPicker){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugHighlightIdConflictsShowItemPicker = ConfigDebugHighlightIdConflictsShowItemPicker;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_begin_return_value_once(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugBeginReturnValueOnce;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_begin_return_value_once(bool ConfigDebugBeginReturnValueOnce){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugBeginReturnValueOnce = ConfigDebugBeginReturnValueOnce;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_begin_return_value_loop(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugBeginReturnValueLoop;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_begin_return_value_loop(bool ConfigDebugBeginReturnValueLoop){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugBeginReturnValueLoop = ConfigDebugBeginReturnValueLoop;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_ignore_focus_loss(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIgnoreFocusLoss;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_ignore_focus_loss(bool ConfigDebugIgnoreFocusLoss){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIgnoreFocusLoss = ConfigDebugIgnoreFocusLoss;
		#endif
		return false;
	}
	bool lime_imgui_io_get_config_debug_ini_settings(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIniSettings;
		#endif
		return false;
	}
	bool lime_imgui_io_set_config_debug_ini_settings(bool ConfigDebugIniSettings){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.ConfigDebugIniSettings = ConfigDebugIniSettings;
		#endif
		return false;
	}
	bool lime_imgui_io_get_want_capture_mouse(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantCaptureMouse;
		#endif
		return false;
	}
	bool lime_imgui_io_set_want_capture_mouse(bool WantCaptureMouse){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantCaptureMouse = WantCaptureMouse;
		#endif
		return false;
	}
	bool lime_imgui_io_get_want_capture_keyboard(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantCaptureKeyboard;
		#endif
		return false;
	}
	bool lime_imgui_io_set_want_capture_keyboard(bool WantCaptureKeyboard){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantCaptureKeyboard = WantCaptureKeyboard;
		#endif
		return false;
	}
	bool lime_imgui_io_get_want_text_input(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantTextInput;
		#endif
		return false;
	}
	bool lime_imgui_io_set_want_text_input(bool WantTextInput){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantTextInput = WantTextInput;
		#endif
		return false;
	}
	bool lime_imgui_io_get_want_set_mouse_pos(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantSetMousePos;
		#endif
		return false;
	}
	bool lime_imgui_io_set_want_set_mouse_pos(bool WantSetMousePos){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantSetMousePos = WantSetMousePos;
		#endif
		return false;
	}
	bool lime_imgui_io_get_want_save_ini_settings(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantSaveIniSettings;
		#endif
		return false;
	}
	bool lime_imgui_io_set_want_save_ini_settings(bool WantSaveIniSettings){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.WantSaveIniSettings = WantSaveIniSettings;
		#endif
		return false;
	}
	bool lime_imgui_io_get_nav_active(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.NavActive;
		#endif
		return false;
	}
	bool lime_imgui_io_set_nav_active(bool NavActive){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.NavActive = NavActive;
		#endif
		return false;
	}
	bool lime_imgui_io_get_nav_visible(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.NavVisible;
		#endif
		return false;
	}
	bool lime_imgui_io_set_nav_visible(bool NavVisible){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.NavVisible = NavVisible;
		#endif
		return false;
	}
	float lime_imgui_io_get_framerate(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.Framerate;
		#endif
		return 0;
	}
	float lime_imgui_io_set_framerate(float Framerate){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.Framerate = Framerate;
		#endif
		return 0;
	}
	int lime_imgui_io_get_metrics_render_vertices(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderVertices;
		#endif
		return 0;
	}
	int lime_imgui_io_set_metrics_render_vertices(int MetricsRenderVertices){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderVertices = MetricsRenderVertices;
		#endif
		return 0;
	}
	int lime_imgui_io_get_metrics_render_indices(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderIndices;
		#endif
		return 0;
	}
	int lime_imgui_io_set_metrics_render_indices(int MetricsRenderIndices){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderIndices = MetricsRenderIndices;
		#endif
		return 0;
	}
	int lime_imgui_io_get_metrics_render_windows(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderWindows;
		#endif
		return 0;
	}
	int lime_imgui_io_set_metrics_render_windows(int MetricsRenderWindows){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsRenderWindows = MetricsRenderWindows;
		#endif
		return 0;
	}
	int lime_imgui_io_get_metrics_active_windows(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsActiveWindows;
		#endif
		return 0;
	}
	int lime_imgui_io_set_metrics_active_windows(int MetricsActiveWindows){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MetricsActiveWindows = MetricsActiveWindows;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_delta_x(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDelta.x;
		#endif
		return 0;
	}
	float lime_imgui_io_set_mouse_delta_x(float MouseDeltaX){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDelta.x = MouseDeltaX;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_delta_y(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDelta.y;
		#endif
		return 0;
	}
	float lime_imgui_io_set_mouse_delta_y(float MouseDeltaY){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDelta.y = MouseDeltaY;
		#endif
		return 0;
	}

	float lime_imgui_io_get_mouse_pos_x(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MousePos.x;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_pos_y(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MousePos.y;
		#endif
		return 0;
	}
	bool lime_imgui_io_get_mouse_down_0(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDown[0];
		#endif
		return false;
	}
	bool lime_imgui_io_get_mouse_down_1(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDown[1];
		#endif
		return false;
	}
	bool lime_imgui_io_get_mouse_down_2(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDown[2];
		#endif
		return false;
	}
	bool lime_imgui_io_get_mouse_down_3(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDown[3];
		#endif
		return false;
	}
	bool lime_imgui_io_get_mouse_down_4(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseDown[4];
		#endif
		return false;
	}
	float lime_imgui_io_get_mouse_wheel(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseWheel;
		#endif
		return 0;
	}
	float lime_imgui_io_get_mouse_wheel_h(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseWheelH;
		#endif
		return 0;
	}
	int lime_imgui_io_get_mouse_source(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.MouseSource;
		#endif
		return 0;
	}
	bool lime_imgui_io_get_key_ctrl(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyCtrl;
		#endif
		return false;
	}
	bool lime_imgui_io_get_key_shift(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyShift;
		#endif
		return false;
	}
	bool lime_imgui_io_get_key_alt(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeyAlt;
		#endif
		return false;
	}
	bool lime_imgui_io_get_key_super(){
		#ifdef LIME_IMGUI
		ImGuiIO& io = ImGui::GetIO();
		return io.KeySuper;
		#endif
		return false;
	}

	DEFINE_PRIME0 (lime_imgui_io_get_config_flags);
	DEFINE_PRIME1 (lime_imgui_io_set_config_flags);
	DEFINE_PRIME0 (lime_imgui_io_get_backend_flags);
	DEFINE_PRIME1 (lime_imgui_io_set_backend_flags);
	DEFINE_PRIME0 (lime_imgui_io_get_display_size_x);
	DEFINE_PRIME1 (lime_imgui_io_set_display_size_x);
	DEFINE_PRIME0 (lime_imgui_io_get_display_size_y);
	DEFINE_PRIME1 (lime_imgui_io_set_display_size_y);
	DEFINE_PRIME0 (lime_imgui_io_get_display_framebuffer_scale_x);
	DEFINE_PRIME1 (lime_imgui_io_set_display_framebuffer_scale_x);
	DEFINE_PRIME0 (lime_imgui_io_get_display_framebuffer_scale_y);
	DEFINE_PRIME1 (lime_imgui_io_set_display_framebuffer_scale_y);
	DEFINE_PRIME0 (lime_imgui_io_get_delta_time);
	DEFINE_PRIME1 (lime_imgui_io_set_delta_time);
	DEFINE_PRIME0 (lime_imgui_io_get_ini_saving_rate);
	DEFINE_PRIME1 (lime_imgui_io_set_ini_saving_rate);
	DEFINE_PRIME0 (lime_imgui_io_get_ini_filename);
	DEFINE_PRIME1 (lime_imgui_io_set_ini_filename);
	DEFINE_PRIME0 (lime_imgui_io_get_log_filename);
	DEFINE_PRIME1 (lime_imgui_io_set_log_filename);
	DEFINE_PRIME0 (lime_imgui_io_get_fonts);
	//DEFINE_PRIME1 (lime_imgui_io_set_fonts);
	DEFINE_PRIME0 (lime_imgui_io_get_font_default);
	DEFINE_PRIME1 (lime_imgui_io_set_font_default);
	DEFINE_PRIME0 (lime_imgui_io_get_font_allow_user_scaling);
	DEFINE_PRIME1 (lime_imgui_io_set_font_allow_user_scaling);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_swap_gamepad_buttons);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_swap_gamepad_buttons);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_move_set_mouse_pos);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_move_set_mouse_pos);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_capture_keyboard);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_capture_keyboard);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_escape_clear_focus_item);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_escape_clear_focus_item);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_escape_clear_focus_window);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_escape_clear_focus_window);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_cursor_visible_auto);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_cursor_visible_auto);
	DEFINE_PRIME0 (lime_imgui_io_get_config_nav_cursor_visible_always);
	DEFINE_PRIME1 (lime_imgui_io_set_config_nav_cursor_visible_always);
	DEFINE_PRIME0 (lime_imgui_io_get_config_docking_no_split);
	DEFINE_PRIME1 (lime_imgui_io_set_config_docking_no_split);
	DEFINE_PRIME0 (lime_imgui_io_get_config_docking_no_docking_over);
	DEFINE_PRIME1 (lime_imgui_io_set_config_docking_no_docking_over);
	DEFINE_PRIME0 (lime_imgui_io_get_config_docking_with_shift);
	DEFINE_PRIME1 (lime_imgui_io_set_config_docking_with_shift);
	DEFINE_PRIME0 (lime_imgui_io_get_config_docking_always_tab_bar);
	DEFINE_PRIME1 (lime_imgui_io_set_config_docking_always_tab_bar);
	DEFINE_PRIME0 (lime_imgui_io_get_config_docking_transparent_payload);
	DEFINE_PRIME1 (lime_imgui_io_set_config_docking_transparent_payload);
	DEFINE_PRIME0 (lime_imgui_io_get_config_viewports_no_auto_merge);
	DEFINE_PRIME1 (lime_imgui_io_set_config_viewports_no_auto_merge);
	DEFINE_PRIME0 (lime_imgui_io_get_config_viewports_no_task_bar_icon);
	DEFINE_PRIME1 (lime_imgui_io_set_config_viewports_no_task_bar_icon);
	DEFINE_PRIME0 (lime_imgui_io_get_config_viewports_no_decoration);
	DEFINE_PRIME1 (lime_imgui_io_set_config_viewports_no_decoration);
	DEFINE_PRIME0 (lime_imgui_io_get_config_viewports_no_default_parent);
	DEFINE_PRIME1 (lime_imgui_io_set_config_viewports_no_default_parent);
	DEFINE_PRIME0 (lime_imgui_io_get_config_viewports_platform_focus_sets_im_gui_focus);
	DEFINE_PRIME1 (lime_imgui_io_set_config_viewports_platform_focus_sets_im_gui_focus);
	DEFINE_PRIME0 (lime_imgui_io_get_config_dpi_scale_fonts);
	DEFINE_PRIME1 (lime_imgui_io_set_config_dpi_scale_fonts);
	DEFINE_PRIME0 (lime_imgui_io_get_config_dpi_scale_viewports);
	DEFINE_PRIME1 (lime_imgui_io_set_config_dpi_scale_viewports);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_draw_cursor);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_draw_cursor);
	DEFINE_PRIME0 (lime_imgui_io_get_config_mac_o_s_x_behaviors);
	DEFINE_PRIME1 (lime_imgui_io_set_config_mac_o_s_x_behaviors);
	DEFINE_PRIME0 (lime_imgui_io_get_config_input_text_cursor_blink);
	DEFINE_PRIME1 (lime_imgui_io_set_config_input_text_cursor_blink);
	DEFINE_PRIME0 (lime_imgui_io_get_config_input_text_enter_keep_active);
	DEFINE_PRIME1 (lime_imgui_io_set_config_input_text_enter_keep_active);
	DEFINE_PRIME0 (lime_imgui_io_get_config_drag_click_to_input_text);
	DEFINE_PRIME1 (lime_imgui_io_set_config_drag_click_to_input_text);
	DEFINE_PRIME0 (lime_imgui_io_get_config_windows_resize_from_edges);
	DEFINE_PRIME1 (lime_imgui_io_set_config_windows_resize_from_edges);
	DEFINE_PRIME0 (lime_imgui_io_get_config_windows_move_from_title_bar_only);
	DEFINE_PRIME1 (lime_imgui_io_set_config_windows_move_from_title_bar_only);
	DEFINE_PRIME0 (lime_imgui_io_get_config_windows_copy_contents_with_ctrl_c);
	DEFINE_PRIME1 (lime_imgui_io_set_config_windows_copy_contents_with_ctrl_c);
	DEFINE_PRIME0 (lime_imgui_io_get_config_scrollbar_scroll_by_page);
	DEFINE_PRIME1 (lime_imgui_io_set_config_scrollbar_scroll_by_page);
	DEFINE_PRIME0 (lime_imgui_io_get_config_memory_compact_timer);
	DEFINE_PRIME1 (lime_imgui_io_set_config_memory_compact_timer);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_double_click_time);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_double_click_time);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_double_click_max_dist);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_double_click_max_dist);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_drag_threshold);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_drag_threshold);
	DEFINE_PRIME0 (lime_imgui_io_get_key_repeat_delay);
	DEFINE_PRIME1 (lime_imgui_io_set_key_repeat_delay);
	DEFINE_PRIME0 (lime_imgui_io_get_key_repeat_rate);
	DEFINE_PRIME1 (lime_imgui_io_set_key_repeat_rate);
	DEFINE_PRIME0 (lime_imgui_io_get_config_error_recovery);
	DEFINE_PRIME1 (lime_imgui_io_set_config_error_recovery);
	DEFINE_PRIME0 (lime_imgui_io_get_config_error_recovery_enable_assert);
	DEFINE_PRIME1 (lime_imgui_io_set_config_error_recovery_enable_assert);
	DEFINE_PRIME0 (lime_imgui_io_get_config_error_recovery_enable_debug_log);
	DEFINE_PRIME1 (lime_imgui_io_set_config_error_recovery_enable_debug_log);
	DEFINE_PRIME0 (lime_imgui_io_get_config_error_recovery_enable_tooltip);
	DEFINE_PRIME1 (lime_imgui_io_set_config_error_recovery_enable_tooltip);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_is_debugger_present);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_is_debugger_present);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_highlight_id_conflicts);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_highlight_id_conflicts);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_highlight_id_conflicts_show_item_picker);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_highlight_id_conflicts_show_item_picker);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_begin_return_value_once);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_begin_return_value_once);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_begin_return_value_loop);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_begin_return_value_loop);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_ignore_focus_loss);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_ignore_focus_loss);
	DEFINE_PRIME0 (lime_imgui_io_get_config_debug_ini_settings);
	DEFINE_PRIME1 (lime_imgui_io_set_config_debug_ini_settings);
	DEFINE_PRIME0 (lime_imgui_io_get_want_capture_mouse);
	DEFINE_PRIME1 (lime_imgui_io_set_want_capture_mouse);
	DEFINE_PRIME0 (lime_imgui_io_get_want_capture_keyboard);
	DEFINE_PRIME1 (lime_imgui_io_set_want_capture_keyboard);
	DEFINE_PRIME0 (lime_imgui_io_get_want_text_input);
	DEFINE_PRIME1 (lime_imgui_io_set_want_text_input);
	DEFINE_PRIME0 (lime_imgui_io_get_want_set_mouse_pos);
	DEFINE_PRIME1 (lime_imgui_io_set_want_set_mouse_pos);
	DEFINE_PRIME0 (lime_imgui_io_get_want_save_ini_settings);
	DEFINE_PRIME1 (lime_imgui_io_set_want_save_ini_settings);
	DEFINE_PRIME0 (lime_imgui_io_get_nav_active);
	DEFINE_PRIME1 (lime_imgui_io_set_nav_active);
	DEFINE_PRIME0 (lime_imgui_io_get_nav_visible);
	DEFINE_PRIME1 (lime_imgui_io_set_nav_visible);
	DEFINE_PRIME0 (lime_imgui_io_get_framerate);
	DEFINE_PRIME1 (lime_imgui_io_set_framerate);
	DEFINE_PRIME0 (lime_imgui_io_get_metrics_render_vertices);
	DEFINE_PRIME1 (lime_imgui_io_set_metrics_render_vertices);
	DEFINE_PRIME0 (lime_imgui_io_get_metrics_render_indices);
	DEFINE_PRIME1 (lime_imgui_io_set_metrics_render_indices);
	DEFINE_PRIME0 (lime_imgui_io_get_metrics_render_windows);
	DEFINE_PRIME1 (lime_imgui_io_set_metrics_render_windows);
	DEFINE_PRIME0 (lime_imgui_io_get_metrics_active_windows);
	DEFINE_PRIME1 (lime_imgui_io_set_metrics_active_windows);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_delta_x);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_delta_x);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_delta_y);
	DEFINE_PRIME1 (lime_imgui_io_set_mouse_delta_y);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_pos_x);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_pos_y);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_down_0);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_down_1);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_down_2);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_down_3);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_down_4);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_wheel);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_wheel_h);
	DEFINE_PRIME0 (lime_imgui_io_get_mouse_source);
	DEFINE_PRIME0 (lime_imgui_io_get_key_ctrl);
	DEFINE_PRIME0 (lime_imgui_io_get_key_shift);
	DEFINE_PRIME0 (lime_imgui_io_get_key_alt);
	DEFINE_PRIME0 (lime_imgui_io_get_key_super);

	//ImFontAtlas

	#ifdef LIME_IMGUI
	void getFontConfig(value font_cfg, ImFontConfig& output) {
		if (val_is_null(font_cfg)) return;

		//not sure why this doesnt work right now
		

		output.MergeMode = val_bool(val_field(font_cfg, val_id("mergeMode")));
		output.PixelSnapH = val_bool(val_field(font_cfg, val_id("pixelSnapH")));
		output.OversampleH = val_int(val_field(font_cfg, val_id("oversampleH")));
		output.OversampleV = val_int(val_field(font_cfg, val_id("oversampleV")));
		output.EllipsisChar = val_int(val_field(font_cfg, val_id("ellipsisChar")));
		output.SizePixels = val_number(val_field(font_cfg, val_id("sizePixels")));
		//output.glyphRanges = val_number(val_field(font_cfg, val_id("glyphRanges")));
		//output.glyphExcludeRanges = val_number(val_field(font_cfg, val_id("glyphExcludeRanges")));
		output.GlyphOffset.x = val_number(val_field(font_cfg, val_id("glyphOffsetX")));
		output.GlyphOffset.x = val_number(val_field(font_cfg, val_id("glyphOffsetY")));
		output.GlyphMinAdvanceX = val_number(val_field(font_cfg, val_id("glyphMinAdvanceX")));
		output.GlyphMaxAdvanceX = val_number(val_field(font_cfg, val_id("glyphMaxAdvanceX")));
		output.GlyphExtraAdvanceX = val_int(val_field(font_cfg, val_id("glyphExtraAdvanceX")));
		output.FontNo = val_int(val_field(font_cfg, val_id("fontNo")));
		output.FontLoaderFlags = val_int(val_field(font_cfg, val_id("fontLoaderFlags")));
		output.RasterizerMultiply = val_number(val_field(font_cfg, val_id("rasterizerMultiply")));
		output.RasterizerDensity = val_number(val_field(font_cfg, val_id("rasterizerDensity")));
		output.ExtraSizeScale = val_number(val_field(font_cfg, val_id("extraSizeScale")));
	}
	#endif

	double lime_imgui_font_atlas_add_font(double handle, value font_cfg){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFontConfig cfg;
		getFontConfig(font_cfg, cfg);
		return getHandleFromPointer((void*)fontAtlas->AddFont(&cfg));
		#endif
		return 0;
	}
	double lime_imgui_font_atlas_add_font_default(double handle, value font_cfg){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFontConfig cfg;
		getFontConfig(font_cfg, cfg);
		return getHandleFromPointer((void*)fontAtlas->AddFontDefault(&cfg));
		#endif
		return 0;
	}
	double lime_imgui_font_atlas_add_font_default_vector(double handle, value font_cfg){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFontConfig cfg;
		getFontConfig(font_cfg, cfg);
		return getHandleFromPointer((void*)fontAtlas->AddFontDefaultVector(&cfg));
		#endif
		return 0;
	}
	double lime_imgui_font_atlas_add_font_default_bitmap(double handle, value font_cfg){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFontConfig cfg;
		getFontConfig(font_cfg, cfg);
		return getHandleFromPointer((void*)fontAtlas->AddFontDefaultBitmap(&cfg));
		#endif
		return 0;
	}
	double lime_imgui_font_atlas_add_font_from_file_ttf(double handle, HxString filename, float size_pixels, value font_cfg){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFontConfig cfg;
		getFontConfig(font_cfg, cfg);
		return getHandleFromPointer((void*)fontAtlas->AddFontFromFileTTF(hxs_utf8(filename, nullptr), size_pixels, &cfg));
		#endif
		return 0;
	}
	void lime_imgui_font_atlas_remove_font(double handle, double fontHandle){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		ImFont* font = (ImFont*)getPointerFromHandle(fontHandle);
		fontAtlas->RemoveFont(font);
		#endif
	}

	void lime_imgui_font_atlas_clear(double handle){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		fontAtlas->Clear();
		#endif
	}
	void lime_imgui_font_atlas_compact_cache(double handle){
		#ifdef LIME_IMGUI
		ImFontAtlas* fontAtlas = (ImFontAtlas*)getPointerFromHandle(handle);
		fontAtlas->CompactCache();
		#endif
	}

	DEFINE_PRIME2 (lime_imgui_font_atlas_add_font);
	DEFINE_PRIME2 (lime_imgui_font_atlas_add_font_default);
	DEFINE_PRIME2 (lime_imgui_font_atlas_add_font_default_vector);
	DEFINE_PRIME2 (lime_imgui_font_atlas_add_font_default_bitmap);
	DEFINE_PRIME4 (lime_imgui_font_atlas_add_font_from_file_ttf);
	DEFINE_PRIME2v (lime_imgui_font_atlas_remove_font);
	DEFINE_PRIME1v (lime_imgui_font_atlas_clear);
	DEFINE_PRIME1v (lime_imgui_font_atlas_compact_cache);

	//ImFontBaked

	void lime_imgui_font_baked_clear_output_data(double handle){
		#ifdef LIME_IMGUI
		ImFontBaked* fontBaked = (ImFontBaked*)getPointerFromHandle(handle);
		fontBaked->ClearOutputData();
		#endif
	}
	double lime_imgui_font_baked_find_glyph(double handle, int c){
		#ifdef LIME_IMGUI
		ImFontBaked* fontBaked = (ImFontBaked*)getPointerFromHandle(handle);
		return getHandleFromPointer((void*)fontBaked->FindGlyph(c));
		#endif
		return 0;
	}
	double lime_imgui_font_baked_find_glyph_no_fallback(double handle, int c){
		#ifdef LIME_IMGUI
		ImFontBaked* fontBaked = (ImFontBaked*)getPointerFromHandle(handle);
		return getHandleFromPointer((void*)fontBaked->FindGlyphNoFallback(c));
		#endif
		return 0;
	}
	float lime_imgui_font_baked_get_char_advance(double handle, int c){
		#ifdef LIME_IMGUI
		ImFontBaked* fontBaked = (ImFontBaked*)getPointerFromHandle(handle);
		return fontBaked->GetCharAdvance(c);
		#endif
		return 0;
	}
	bool lime_imgui_font_baked_is_glyph_loaded(double handle, int c){
		#ifdef LIME_IMGUI
		ImFontBaked* fontBaked = (ImFontBaked*)getPointerFromHandle(handle);
		return fontBaked->IsGlyphLoaded(c);
		#endif
		return false;
	}

	DEFINE_PRIME1v (lime_imgui_font_baked_clear_output_data);
	DEFINE_PRIME2 (lime_imgui_font_baked_find_glyph);
	DEFINE_PRIME2 (lime_imgui_font_baked_find_glyph_no_fallback);
	DEFINE_PRIME2 (lime_imgui_font_baked_get_char_advance);
	DEFINE_PRIME2 (lime_imgui_font_baked_is_glyph_loaded);

	//ImFont

	bool lime_imgui_font_is_glyph_in_font(double handle, int c){
		#ifdef LIME_IMGUI
		ImFont* font = (ImFont*)getPointerFromHandle(handle);
		return font->IsGlyphInFont((ImWchar)c);
		#endif
		return false;
	}
	bool lime_imgui_font_is_loaded(double handle){
		#ifdef LIME_IMGUI
		ImFont* font = (ImFont*)getPointerFromHandle(handle);
		return font->IsLoaded();
		#endif
		return false;
	}
	HxString lime_imgui_font_get_debug_name(double handle){
		#ifdef LIME_IMGUI
		ImFont* font = (ImFont*)getPointerFromHandle(handle);
		return font->GetDebugName();
		#endif
		return 0;
	}

	DEFINE_PRIME2 (lime_imgui_font_is_glyph_in_font);
	DEFINE_PRIME1 (lime_imgui_font_is_loaded);
	DEFINE_PRIME1 (lime_imgui_font_get_debug_name);

	//ImFontGlyph

	int lime_imgui_font_glyph_get_colored(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Colored;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_set_colored(double handle, int Colored){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Colored = Colored;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_get_visible(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Visible;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_set_visible(double handle, int Visible){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Visible = Visible;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_get_source_idx(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->SourceIdx;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_set_source_idx(double handle, int SourceIdx){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->SourceIdx = SourceIdx;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_get_codepoint(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Codepoint;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_set_codepoint(double handle, int Codepoint){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Codepoint = Codepoint;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_advance_x(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->AdvanceX;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_advance_x(double handle, float AdvanceX){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->AdvanceX = AdvanceX;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_x_0(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->X0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_x_0(double handle, float X0){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->X0 = X0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_y_0(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Y0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_y_0(double handle, float Y0){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Y0 = Y0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_x_1(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->X1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_x_1(double handle, float X1){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->X1 = X1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_y_1(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Y1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_y_1(double handle, float Y1){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->Y1 = Y1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_u_0(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->U0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_u_0(double handle, float U0){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->U0 = U0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_v_0(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->V0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_v_0(double handle, float V0){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->V0 = V0;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_u_1(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->U1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_u_1(double handle, float U1){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->U1 = U1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_get_v_1(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->V1;
		#endif
		return 0;
	}
	float lime_imgui_font_glyph_set_v_1(double handle, float V1){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->V1 = V1;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_get_pack_id(double handle){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->PackId;
		#endif
		return 0;
	}
	int lime_imgui_font_glyph_set_pack_id(double handle, int PackId){
		#ifdef LIME_IMGUI
		ImFontGlyph* glyph = (ImFontGlyph*)getPointerFromHandle(handle);
		return glyph->PackId = PackId;
		#endif
		return 0;
	}

	DEFINE_PRIME1 (lime_imgui_font_glyph_get_colored);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_colored);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_visible);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_visible);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_source_idx);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_source_idx);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_codepoint);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_codepoint);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_advance_x);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_advance_x);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_x_0);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_x_0);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_y_0);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_y_0);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_x_1);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_x_1);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_y_1);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_y_1);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_u_0);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_u_0);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_v_0);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_v_0);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_u_1);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_u_1);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_v_1);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_v_1);
	DEFINE_PRIME1 (lime_imgui_font_glyph_get_pack_id);
	DEFINE_PRIME2 (lime_imgui_font_glyph_set_pack_id);

	//ImGuiStyle

	float lime_imgui_style_get_font_size_base(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontSizeBase;
		#endif
		return 0;
	}
	float lime_imgui_style_set_font_size_base(double handle, float FontSizeBase){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontSizeBase = FontSizeBase;
		#endif
		return 0;
	}
	float lime_imgui_style_get_font_scale_main(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontScaleMain;
		#endif
		return 0;
	}
	float lime_imgui_style_set_font_scale_main(double handle, float FontScaleMain){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontScaleMain = FontScaleMain;
		#endif
		return 0;
	}
	float lime_imgui_style_get_font_scale_dpi(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontScaleDpi;
		#endif
		return 0;
	}
	float lime_imgui_style_set_font_scale_dpi(double handle, float FontScaleDpi){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FontScaleDpi = FontScaleDpi;
		#endif
		return 0;
	}
	float lime_imgui_style_get_alpha(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->Alpha;
		#endif
		return 0;
	}
	float lime_imgui_style_set_alpha(double handle, float Alpha){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->Alpha = Alpha;
		#endif
		return 0;
	}
	float lime_imgui_style_get_disabled_alpha(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisabledAlpha;
		#endif
		return 0;
	}
	float lime_imgui_style_set_disabled_alpha(double handle, float DisabledAlpha){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisabledAlpha = DisabledAlpha;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_padding_x(double handle, float WindowPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowPadding.x = WindowPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_padding_y(double handle, float WindowPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowPadding.y = WindowPaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_rounding(double handle, float WindowRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowRounding = WindowRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_border_size(double handle, float WindowBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowBorderSize = WindowBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_border_hover_padding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowBorderHoverPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_border_hover_padding(double handle, float WindowBorderHoverPadding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowBorderHoverPadding = WindowBorderHoverPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_min_size_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMinSize.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_min_size_x(double handle, float WindowMinSizeX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMinSize.x = WindowMinSizeX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_min_size_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMinSize.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_min_size_y(double handle, float WindowMinSizeY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMinSize.y = WindowMinSizeY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_title_align_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowTitleAlign.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_title_align_x(double handle, float WindowTitleAlignX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowTitleAlign.x = WindowTitleAlignX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_window_title_align_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowTitleAlign.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_window_title_align_y(double handle, float WindowTitleAlignY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowTitleAlign.y = WindowTitleAlignY;
		#endif
		return 0;
	}
	int lime_imgui_style_get_window_menu_button_position(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMenuButtonPosition;
		#endif
		return 0;
	}
	int lime_imgui_style_set_window_menu_button_position(double handle, int WindowMenuButtonPosition){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->WindowMenuButtonPosition = (ImGuiDir)WindowMenuButtonPosition;
		#endif
		return 0;
	}
	float lime_imgui_style_get_child_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ChildRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_child_rounding(double handle, float ChildRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ChildRounding = ChildRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_child_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ChildBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_child_border_size(double handle, float ChildBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ChildBorderSize = ChildBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_popup_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->PopupRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_popup_rounding(double handle, float PopupRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->PopupRounding = PopupRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_popup_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->PopupBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_popup_border_size(double handle, float PopupBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->PopupBorderSize = PopupBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_frame_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FramePadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_frame_padding_x(double handle, float FramePaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FramePadding.x = FramePaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_frame_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FramePadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_frame_padding_y(double handle, float FramePaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FramePadding.y = FramePaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_frame_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FrameRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_frame_rounding(double handle, float FrameRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FrameRounding = FrameRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_frame_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FrameBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_frame_border_size(double handle, float FrameBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->FrameBorderSize = FrameBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_item_spacing_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemSpacing.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_item_spacing_x(double handle, float ItemSpacingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemSpacing.x = ItemSpacingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_item_spacing_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemSpacing.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_item_spacing_y(double handle, float ItemSpacingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemSpacing.y = ItemSpacingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_item_inner_spacing_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemInnerSpacing.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_item_inner_spacing_x(double handle, float ItemInnerSpacingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemInnerSpacing.x = ItemInnerSpacingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_item_inner_spacing_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemInnerSpacing.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_item_inner_spacing_y(double handle, float ItemInnerSpacingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ItemInnerSpacing.y = ItemInnerSpacingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_cell_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CellPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_cell_padding_x(double handle, float CellPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CellPadding.x = CellPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_cell_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CellPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_cell_padding_y(double handle, float CellPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CellPadding.y = CellPaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_touch_extra_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TouchExtraPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_touch_extra_padding_x(double handle, float TouchExtraPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TouchExtraPadding.x = TouchExtraPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_touch_extra_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TouchExtraPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_touch_extra_padding_y(double handle, float TouchExtraPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TouchExtraPadding.y = TouchExtraPaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_indent_spacing(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->IndentSpacing;
		#endif
		return 0;
	}
	float lime_imgui_style_set_indent_spacing(double handle, float IndentSpacing){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->IndentSpacing = IndentSpacing;
		#endif
		return 0;
	}
	float lime_imgui_style_get_columns_min_spacing(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColumnsMinSpacing;
		#endif
		return 0;
	}
	float lime_imgui_style_set_columns_min_spacing(double handle, float ColumnsMinSpacing){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColumnsMinSpacing = ColumnsMinSpacing;
		#endif
		return 0;
	}
	float lime_imgui_style_get_scrollbar_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_scrollbar_size(double handle, float ScrollbarSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarSize = ScrollbarSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_scrollbar_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_scrollbar_rounding(double handle, float ScrollbarRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarRounding = ScrollbarRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_scrollbar_padding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_scrollbar_padding(double handle, float ScrollbarPadding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ScrollbarPadding = ScrollbarPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_grab_min_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->GrabMinSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_grab_min_size(double handle, float GrabMinSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->GrabMinSize = GrabMinSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_grab_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->GrabRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_grab_rounding(double handle, float GrabRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->GrabRounding = GrabRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_log_slider_deadzone(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->LogSliderDeadzone;
		#endif
		return 0;
	}
	float lime_imgui_style_set_log_slider_deadzone(double handle, float LogSliderDeadzone){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->LogSliderDeadzone = LogSliderDeadzone;
		#endif
		return 0;
	}
	float lime_imgui_style_get_image_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ImageRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_image_rounding(double handle, float ImageRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ImageRounding = ImageRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_image_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ImageBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_image_border_size(double handle, float ImageBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ImageBorderSize = ImageBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_rounding(double handle, float TabRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabRounding = TabRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_border_size(double handle, float TabBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBorderSize = TabBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_min_width_base(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabMinWidthBase;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_min_width_base(double handle, float TabMinWidthBase){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabMinWidthBase = TabMinWidthBase;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_min_width_shrink(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabMinWidthShrink;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_min_width_shrink(double handle, float TabMinWidthShrink){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabMinWidthShrink = TabMinWidthShrink;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_close_button_min_width_selected(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabCloseButtonMinWidthSelected;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_close_button_min_width_selected(double handle, float TabCloseButtonMinWidthSelected){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabCloseButtonMinWidthSelected = TabCloseButtonMinWidthSelected;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_close_button_min_width_unselected(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabCloseButtonMinWidthUnselected;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_close_button_min_width_unselected(double handle, float TabCloseButtonMinWidthUnselected){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabCloseButtonMinWidthUnselected = TabCloseButtonMinWidthUnselected;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_bar_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBarBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_bar_border_size(double handle, float TabBarBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBarBorderSize = TabBarBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tab_bar_overline_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBarOverlineSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tab_bar_overline_size(double handle, float TabBarOverlineSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TabBarOverlineSize = TabBarOverlineSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_table_angled_headers_angle(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersAngle;
		#endif
		return 0;
	}
	float lime_imgui_style_set_table_angled_headers_angle(double handle, float TableAngledHeadersAngle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersAngle = TableAngledHeadersAngle;
		#endif
		return 0;
	}
	float lime_imgui_style_get_table_angled_headers_text_align_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersTextAlign.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_table_angled_headers_text_align_x(double handle, float TableAngledHeadersTextAlignX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersTextAlign.x = TableAngledHeadersTextAlignX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_table_angled_headers_text_align_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersTextAlign.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_table_angled_headers_text_align_y(double handle, float TableAngledHeadersTextAlignY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TableAngledHeadersTextAlign.y = TableAngledHeadersTextAlignY;
		#endif
		return 0;
	}
	int lime_imgui_style_get_tree_lines_flags(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesFlags;
		#endif
		return 0;
	}
	int lime_imgui_style_set_tree_lines_flags(double handle, int TreeLinesFlags){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesFlags = TreeLinesFlags;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tree_lines_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tree_lines_size(double handle, float TreeLinesSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesSize = TreeLinesSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_tree_lines_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_tree_lines_rounding(double handle, float TreeLinesRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->TreeLinesRounding = TreeLinesRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_drag_drop_target_rounding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_drag_drop_target_rounding(double handle, float DragDropTargetRounding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetRounding = DragDropTargetRounding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_drag_drop_target_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_drag_drop_target_border_size(double handle, float DragDropTargetBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetBorderSize = DragDropTargetBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_drag_drop_target_padding(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_set_drag_drop_target_padding(double handle, float DragDropTargetPadding){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DragDropTargetPadding = DragDropTargetPadding;
		#endif
		return 0;
	}
	float lime_imgui_style_get_color_marker_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColorMarkerSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_color_marker_size(double handle, float ColorMarkerSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColorMarkerSize = ColorMarkerSize;
		#endif
		return 0;
	}
	int lime_imgui_style_get_color_button_position(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColorButtonPosition;
		#endif
		return 0;
	}
	int lime_imgui_style_set_color_button_position(double handle, int ColorButtonPosition){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ColorButtonPosition = (ImGuiDir)ColorButtonPosition;
		#endif
		return 0;
	}
	float lime_imgui_style_get_button_text_align_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ButtonTextAlign.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_button_text_align_x(double handle, float ButtonTextAlignX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ButtonTextAlign.x = ButtonTextAlignX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_button_text_align_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ButtonTextAlign.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_button_text_align_y(double handle, float ButtonTextAlignY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->ButtonTextAlign.y = ButtonTextAlignY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_selectable_text_align_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SelectableTextAlign.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_selectable_text_align_x(double handle, float SelectableTextAlignX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SelectableTextAlign.x = SelectableTextAlignX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_selectable_text_align_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SelectableTextAlign.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_selectable_text_align_y(double handle, float SelectableTextAlignY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SelectableTextAlign.y = SelectableTextAlignY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_size(double handle, float SeparatorSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorSize = SeparatorSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_text_border_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_text_border_size(double handle, float SeparatorTextBorderSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextBorderSize = SeparatorTextBorderSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_text_align_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextAlign.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_text_align_x(double handle, float SeparatorTextAlignX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextAlign.x = SeparatorTextAlignX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_text_align_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextAlign.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_text_align_y(double handle, float SeparatorTextAlignY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextAlign.y = SeparatorTextAlignY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_text_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_text_padding_x(double handle, float SeparatorTextPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextPadding.x = SeparatorTextPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_separator_text_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_separator_text_padding_y(double handle, float SeparatorTextPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->SeparatorTextPadding.y = SeparatorTextPaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_display_window_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplayWindowPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_display_window_padding_x(double handle, float DisplayWindowPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplayWindowPadding.x = DisplayWindowPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_display_window_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplayWindowPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_display_window_padding_y(double handle, float DisplayWindowPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplayWindowPadding.y = DisplayWindowPaddingY;
		#endif
		return 0;
	}
	float lime_imgui_style_get_display_safe_area_padding_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplaySafeAreaPadding.x;
		#endif
		return 0;
	}
	float lime_imgui_style_set_display_safe_area_padding_x(double handle, float DisplaySafeAreaPaddingX){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplaySafeAreaPadding.x = DisplaySafeAreaPaddingX;
		#endif
		return 0;
	}
	float lime_imgui_style_get_display_safe_area_padding_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplaySafeAreaPadding.y;
		#endif
		return 0;
	}
	float lime_imgui_style_set_display_safe_area_padding_y(double handle, float DisplaySafeAreaPaddingY){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DisplaySafeAreaPadding.y = DisplaySafeAreaPaddingY;
		#endif
		return 0;
	}
	bool lime_imgui_style_get_docking_node_has_close_button(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DockingNodeHasCloseButton;
		#endif
		return false;
	}
	bool lime_imgui_style_set_docking_node_has_close_button(double handle, bool DockingNodeHasCloseButton){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DockingNodeHasCloseButton = DockingNodeHasCloseButton;
		#endif
		return false;
	}
	float lime_imgui_style_get_docking_separator_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DockingSeparatorSize;
		#endif
		return 0;
	}
	float lime_imgui_style_set_docking_separator_size(double handle, float DockingSeparatorSize){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->DockingSeparatorSize = DockingSeparatorSize;
		#endif
		return 0;
	}
	float lime_imgui_style_get_mouse_cursor_scale(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->MouseCursorScale;
		#endif
		return 0;
	}
	float lime_imgui_style_set_mouse_cursor_scale(double handle, float MouseCursorScale){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->MouseCursorScale = MouseCursorScale;
		#endif
		return 0;
	}
	bool lime_imgui_style_get_anti_aliased_lines(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedLines;
		#endif
		return false;
	}
	bool lime_imgui_style_set_anti_aliased_lines(double handle, bool AntiAliasedLines){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedLines = AntiAliasedLines;
		#endif
		return false;
	}
	bool lime_imgui_style_get_anti_aliased_lines_use_tex(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedLinesUseTex;
		#endif
		return false;
	}
	bool lime_imgui_style_set_anti_aliased_lines_use_tex(double handle, bool AntiAliasedLinesUseTex){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedLinesUseTex = AntiAliasedLinesUseTex;
		#endif
		return false;
	}
	bool lime_imgui_style_get_anti_aliased_fill(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedFill;
		#endif
		return false;
	}
	bool lime_imgui_style_set_anti_aliased_fill(double handle, bool AntiAliasedFill){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->AntiAliasedFill = AntiAliasedFill;
		#endif
		return false;
	}
	float lime_imgui_style_get_curve_tessellation_tol(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CurveTessellationTol;
		#endif
		return 0;
	}
	float lime_imgui_style_set_curve_tessellation_tol(double handle, float CurveTessellationTol){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CurveTessellationTol = CurveTessellationTol;
		#endif
		return 0;
	}
	float lime_imgui_style_get_circle_tessellation_max_error(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CircleTessellationMaxError;
		#endif
		return 0;
	}
	float lime_imgui_style_set_circle_tessellation_max_error(double handle, float CircleTessellationMaxError){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->CircleTessellationMaxError = CircleTessellationMaxError;
		#endif
		return 0;
	}

	#ifdef LIME_IMGUI
	value createVec4FromImVec4(ImVec4 color) {
		value v = alloc_empty_object ();
		alloc_field (v, val_id ("x"), alloc_float (color.x));
		alloc_field (v, val_id ("y"), alloc_float (color.y));
		alloc_field (v, val_id ("z"), alloc_float (color.z));
		alloc_field (v, val_id ("w"), alloc_float (color.w));
		return v;
	}
	#endif

	value lime_imgui_style_get_colors(double handle, int index){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return createVec4FromImVec4(style->Colors[index]);
		#endif
		return alloc_empty_object ();
	}
	value lime_imgui_style_set_colors(double handle, int index, value col){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		style->Colors[index].x = val_float(val_field(col, val_id("x")));
		style->Colors[index].y = val_float(val_field(col, val_id("y")));
		style->Colors[index].z = val_float(val_field(col, val_id("z")));
		style->Colors[index].w = val_float(val_field(col, val_id("w")));
		return createVec4FromImVec4(style->Colors[index]);
		#endif
		return alloc_empty_object();
	}

	float lime_imgui_style_get_hover_stationary_delay(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverStationaryDelay;
		#endif
		return 0;
	}
	float lime_imgui_style_set_hover_stationary_delay(double handle, float HoverStationaryDelay){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverStationaryDelay = HoverStationaryDelay;
		#endif
		return 0;
	}
	float lime_imgui_style_get_hover_delay_short(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverDelayShort;
		#endif
		return 0;
	}
	float lime_imgui_style_set_hover_delay_short(double handle, float HoverDelayShort){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverDelayShort = HoverDelayShort;
		#endif
		return 0;
	}
	float lime_imgui_style_get_hover_delay_normal(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverDelayNormal;
		#endif
		return 0;
	}
	float lime_imgui_style_set_hover_delay_normal(double handle, float HoverDelayNormal){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverDelayNormal = HoverDelayNormal;
		#endif
		return 0;
	}
	int lime_imgui_style_get_hover_flags_for_tooltip_mouse(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverFlagsForTooltipMouse;
		#endif
		return 0;
	}
	int lime_imgui_style_set_hover_flags_for_tooltip_mouse(double handle, int HoverFlagsForTooltipMouse){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverFlagsForTooltipMouse = HoverFlagsForTooltipMouse;
		#endif
		return 0;
	}
	int lime_imgui_style_get_hover_flags_for_tooltip_nav(double handle){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverFlagsForTooltipNav;
		#endif
		return 0;
	}
	int lime_imgui_style_set_hover_flags_for_tooltip_nav(double handle, int HoverFlagsForTooltipNav){
		#ifdef LIME_IMGUI
		ImGuiStyle* style = (ImGuiStyle*)getPointerFromHandle(handle);
		return style->HoverFlagsForTooltipNav = HoverFlagsForTooltipNav;
		#endif
		return 0;
	}

	DEFINE_PRIME1 (lime_imgui_style_get_font_size_base);
	DEFINE_PRIME2 (lime_imgui_style_set_font_size_base);
	DEFINE_PRIME1 (lime_imgui_style_get_font_scale_main);
	DEFINE_PRIME2 (lime_imgui_style_set_font_scale_main);
	DEFINE_PRIME1 (lime_imgui_style_get_font_scale_dpi);
	DEFINE_PRIME2 (lime_imgui_style_set_font_scale_dpi);
	DEFINE_PRIME1 (lime_imgui_style_get_alpha);
	DEFINE_PRIME2 (lime_imgui_style_set_alpha);
	DEFINE_PRIME1 (lime_imgui_style_get_disabled_alpha);
	DEFINE_PRIME2 (lime_imgui_style_set_disabled_alpha);
	DEFINE_PRIME1 (lime_imgui_style_get_window_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_window_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_window_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_window_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_window_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_window_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_window_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_window_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_window_border_hover_padding);
	DEFINE_PRIME2 (lime_imgui_style_set_window_border_hover_padding);
	DEFINE_PRIME1 (lime_imgui_style_get_window_min_size_x);
	DEFINE_PRIME2 (lime_imgui_style_set_window_min_size_x);
	DEFINE_PRIME1 (lime_imgui_style_get_window_min_size_y);
	DEFINE_PRIME2 (lime_imgui_style_set_window_min_size_y);
	DEFINE_PRIME1 (lime_imgui_style_get_window_title_align_x);
	DEFINE_PRIME2 (lime_imgui_style_set_window_title_align_x);
	DEFINE_PRIME1 (lime_imgui_style_get_window_title_align_y);
	DEFINE_PRIME2 (lime_imgui_style_set_window_title_align_y);
	DEFINE_PRIME1 (lime_imgui_style_get_window_menu_button_position);
	DEFINE_PRIME2 (lime_imgui_style_set_window_menu_button_position);
	DEFINE_PRIME1 (lime_imgui_style_get_child_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_child_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_child_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_child_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_popup_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_popup_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_popup_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_popup_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_frame_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_frame_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_frame_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_frame_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_frame_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_frame_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_frame_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_frame_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_item_spacing_x);
	DEFINE_PRIME2 (lime_imgui_style_set_item_spacing_x);
	DEFINE_PRIME1 (lime_imgui_style_get_item_spacing_y);
	DEFINE_PRIME2 (lime_imgui_style_set_item_spacing_y);
	DEFINE_PRIME1 (lime_imgui_style_get_item_inner_spacing_x);
	DEFINE_PRIME2 (lime_imgui_style_set_item_inner_spacing_x);
	DEFINE_PRIME1 (lime_imgui_style_get_item_inner_spacing_y);
	DEFINE_PRIME2 (lime_imgui_style_set_item_inner_spacing_y);
	DEFINE_PRIME1 (lime_imgui_style_get_cell_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_cell_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_cell_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_cell_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_touch_extra_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_touch_extra_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_touch_extra_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_touch_extra_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_indent_spacing);
	DEFINE_PRIME2 (lime_imgui_style_set_indent_spacing);
	DEFINE_PRIME1 (lime_imgui_style_get_columns_min_spacing);
	DEFINE_PRIME2 (lime_imgui_style_set_columns_min_spacing);
	DEFINE_PRIME1 (lime_imgui_style_get_scrollbar_size);
	DEFINE_PRIME2 (lime_imgui_style_set_scrollbar_size);
	DEFINE_PRIME1 (lime_imgui_style_get_scrollbar_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_scrollbar_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_scrollbar_padding);
	DEFINE_PRIME2 (lime_imgui_style_set_scrollbar_padding);
	DEFINE_PRIME1 (lime_imgui_style_get_grab_min_size);
	DEFINE_PRIME2 (lime_imgui_style_set_grab_min_size);
	DEFINE_PRIME1 (lime_imgui_style_get_grab_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_grab_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_log_slider_deadzone);
	DEFINE_PRIME2 (lime_imgui_style_set_log_slider_deadzone);
	DEFINE_PRIME1 (lime_imgui_style_get_image_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_image_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_image_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_image_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_min_width_base);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_min_width_base);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_min_width_shrink);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_min_width_shrink);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_close_button_min_width_selected);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_close_button_min_width_selected);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_close_button_min_width_unselected);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_close_button_min_width_unselected);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_bar_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_bar_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_tab_bar_overline_size);
	DEFINE_PRIME2 (lime_imgui_style_set_tab_bar_overline_size);
	DEFINE_PRIME1 (lime_imgui_style_get_table_angled_headers_angle);
	DEFINE_PRIME2 (lime_imgui_style_set_table_angled_headers_angle);
	DEFINE_PRIME1 (lime_imgui_style_get_table_angled_headers_text_align_x);
	DEFINE_PRIME2 (lime_imgui_style_set_table_angled_headers_text_align_x);
	DEFINE_PRIME1 (lime_imgui_style_get_table_angled_headers_text_align_y);
	DEFINE_PRIME2 (lime_imgui_style_set_table_angled_headers_text_align_y);
	DEFINE_PRIME1 (lime_imgui_style_get_tree_lines_flags);
	DEFINE_PRIME2 (lime_imgui_style_set_tree_lines_flags);
	DEFINE_PRIME1 (lime_imgui_style_get_tree_lines_size);
	DEFINE_PRIME2 (lime_imgui_style_set_tree_lines_size);
	DEFINE_PRIME1 (lime_imgui_style_get_tree_lines_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_tree_lines_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_drag_drop_target_rounding);
	DEFINE_PRIME2 (lime_imgui_style_set_drag_drop_target_rounding);
	DEFINE_PRIME1 (lime_imgui_style_get_drag_drop_target_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_drag_drop_target_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_drag_drop_target_padding);
	DEFINE_PRIME2 (lime_imgui_style_set_drag_drop_target_padding);
	DEFINE_PRIME1 (lime_imgui_style_get_color_marker_size);
	DEFINE_PRIME2 (lime_imgui_style_set_color_marker_size);
	DEFINE_PRIME1 (lime_imgui_style_get_color_button_position);
	DEFINE_PRIME2 (lime_imgui_style_set_color_button_position);
	DEFINE_PRIME1 (lime_imgui_style_get_button_text_align_x);
	DEFINE_PRIME2 (lime_imgui_style_set_button_text_align_x);
	DEFINE_PRIME1 (lime_imgui_style_get_button_text_align_y);
	DEFINE_PRIME2 (lime_imgui_style_set_button_text_align_y);
	DEFINE_PRIME1 (lime_imgui_style_get_selectable_text_align_x);
	DEFINE_PRIME2 (lime_imgui_style_set_selectable_text_align_x);
	DEFINE_PRIME1 (lime_imgui_style_get_selectable_text_align_y);
	DEFINE_PRIME2 (lime_imgui_style_set_selectable_text_align_y);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_size);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_size);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_text_border_size);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_text_border_size);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_text_align_x);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_text_align_x);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_text_align_y);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_text_align_y);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_text_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_text_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_separator_text_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_separator_text_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_display_window_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_display_window_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_display_window_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_display_window_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_display_safe_area_padding_x);
	DEFINE_PRIME2 (lime_imgui_style_set_display_safe_area_padding_x);
	DEFINE_PRIME1 (lime_imgui_style_get_display_safe_area_padding_y);
	DEFINE_PRIME2 (lime_imgui_style_set_display_safe_area_padding_y);
	DEFINE_PRIME1 (lime_imgui_style_get_docking_node_has_close_button);
	DEFINE_PRIME2 (lime_imgui_style_set_docking_node_has_close_button);
	DEFINE_PRIME1 (lime_imgui_style_get_docking_separator_size);
	DEFINE_PRIME2 (lime_imgui_style_set_docking_separator_size);
	DEFINE_PRIME1 (lime_imgui_style_get_mouse_cursor_scale);
	DEFINE_PRIME2 (lime_imgui_style_set_mouse_cursor_scale);
	DEFINE_PRIME1 (lime_imgui_style_get_anti_aliased_lines);
	DEFINE_PRIME2 (lime_imgui_style_set_anti_aliased_lines);
	DEFINE_PRIME1 (lime_imgui_style_get_anti_aliased_lines_use_tex);
	DEFINE_PRIME2 (lime_imgui_style_set_anti_aliased_lines_use_tex);
	DEFINE_PRIME1 (lime_imgui_style_get_anti_aliased_fill);
	DEFINE_PRIME2 (lime_imgui_style_set_anti_aliased_fill);
	DEFINE_PRIME1 (lime_imgui_style_get_curve_tessellation_tol);
	DEFINE_PRIME2 (lime_imgui_style_set_curve_tessellation_tol);
	DEFINE_PRIME1 (lime_imgui_style_get_circle_tessellation_max_error);
	DEFINE_PRIME2 (lime_imgui_style_set_circle_tessellation_max_error);
	DEFINE_PRIME2 (lime_imgui_style_get_colors);
	DEFINE_PRIME3 (lime_imgui_style_set_colors);
	DEFINE_PRIME1 (lime_imgui_style_get_hover_stationary_delay);
	DEFINE_PRIME2 (lime_imgui_style_set_hover_stationary_delay);
	DEFINE_PRIME1 (lime_imgui_style_get_hover_delay_short);
	DEFINE_PRIME2 (lime_imgui_style_set_hover_delay_short);
	DEFINE_PRIME1 (lime_imgui_style_get_hover_delay_normal);
	DEFINE_PRIME2 (lime_imgui_style_set_hover_delay_normal);
	DEFINE_PRIME1 (lime_imgui_style_get_hover_flags_for_tooltip_mouse);
	DEFINE_PRIME2 (lime_imgui_style_set_hover_flags_for_tooltip_mouse);
	DEFINE_PRIME1 (lime_imgui_style_get_hover_flags_for_tooltip_nav);
	DEFINE_PRIME2 (lime_imgui_style_set_hover_flags_for_tooltip_nav);

	//ImGuiInputTextCallbackData

	int lime_imgui_input_text_callback_data_get_event_flag(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->EventFlag;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_flags(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->Flags;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_id(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->ID;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_event_key(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->EventKey;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_event_char(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->EventChar;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_set_event_char(double handle, int EventChar){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->EventChar = EventChar;
		#endif
		return 0;
	}
	bool lime_imgui_input_text_callback_data_get_event_activated(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->EventActivated;
		#endif
		return false;
	}
	int lime_imgui_input_text_callback_data_get_buf_text_len(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->BufTextLen;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_set_buf_text_len(double handle, int BufTextLen){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->BufTextLen = BufTextLen;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_buf_size(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->BufSize;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_cursor_pos(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->CursorPos;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_set_cursor_pos(double handle, int CursorPos){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->CursorPos = CursorPos;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_selection_start(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->SelectionStart;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_set_selection_start(double handle, int SelectionStart){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->SelectionStart = SelectionStart;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_get_selection_end(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->SelectionEnd;
		#endif
		return 0;
	}
	int lime_imgui_input_text_callback_data_set_selection_end(double handle, int SelectionEnd){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->SelectionEnd = SelectionEnd;
		#endif
		return 0;
	}

	void lime_imgui_input_text_callback_data_delete_chars(double handle, int pos, int bytes_count){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		data->DeleteChars(pos, bytes_count);
		#endif
	}
	void lime_imgui_input_text_callback_data_insert_chars(double handle, int pos, HxString text){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		data->InsertChars(pos, hxs_utf8(text, nullptr));
		#endif
	}
	void lime_imgui_input_text_callback_data_select_all(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		data->SelectAll();
		#endif
	}
	void lime_imgui_input_text_callback_data_set_selection(double handle, int s, int e){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		data->SetSelection(s, e);
		#endif
	}
	void lime_imgui_input_text_callback_data_clear_selection(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		data->ClearSelection();
		#endif
	}
	bool lime_imgui_input_text_callback_data_has_selection(double handle){
		#ifdef LIME_IMGUI
		ImGuiInputTextCallbackData* data = (ImGuiInputTextCallbackData*)getPointerFromHandle(handle);
		return data->HasSelection();
		#endif
		return false;
	}

	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_event_flag);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_flags);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_id);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_event_key);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_event_char);
	DEFINE_PRIME2 (lime_imgui_input_text_callback_data_set_event_char);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_event_activated);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_buf_text_len);
	DEFINE_PRIME2 (lime_imgui_input_text_callback_data_set_buf_text_len);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_buf_size);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_cursor_pos);
	DEFINE_PRIME2 (lime_imgui_input_text_callback_data_set_cursor_pos);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_selection_start);
	DEFINE_PRIME2 (lime_imgui_input_text_callback_data_set_selection_start);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_get_selection_end);
	DEFINE_PRIME2 (lime_imgui_input_text_callback_data_set_selection_end);

	DEFINE_PRIME3v (lime_imgui_input_text_callback_data_delete_chars);
	DEFINE_PRIME3v (lime_imgui_input_text_callback_data_insert_chars);
	DEFINE_PRIME1v (lime_imgui_input_text_callback_data_select_all);
	DEFINE_PRIME3v (lime_imgui_input_text_callback_data_set_selection);
	DEFINE_PRIME1v (lime_imgui_input_text_callback_data_clear_selection);
	DEFINE_PRIME1 (lime_imgui_input_text_callback_data_has_selection);

	//ImGuiViewport

	int lime_imgui_viewport_get_id(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->ID;
		#endif
		return 0;
	}
	int lime_imgui_viewport_set_id(double handle, int ID){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->ID = ID;
		#endif
		return 0;
	}
	int lime_imgui_viewport_get_flags(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Flags;
		#endif
		return 0;
	}
	int lime_imgui_viewport_set_flags(double handle, int Flags){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Flags = Flags;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_pos_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Pos.x;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_pos_x(double handle, float PosX){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Pos.x = PosX;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_pos_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Pos.y;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_pos_y(double handle, float PosY){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Pos.y = PosY;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_size_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Size.x;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_size_x(double handle, float SizeX){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Size.x = SizeX;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_size_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Size.y;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_size_y(double handle, float SizeY){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->Size.y = SizeY;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_framebuffer_scale_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->FramebufferScale.x;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_framebuffer_scale_x(double handle, float FramebufferScaleX){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->FramebufferScale.x = FramebufferScaleX;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_framebuffer_scale_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->FramebufferScale.y;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_framebuffer_scale_y(double handle, float FramebufferScaleY){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->FramebufferScale.y = FramebufferScaleY;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_work_pos_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkPos.x;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_work_pos_x(double handle, float WorkPosX){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkPos.x = WorkPosX;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_work_pos_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkPos.y;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_work_pos_y(double handle, float WorkPosY){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkPos.y = WorkPosY;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_work_size_x(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkSize.x;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_work_size_x(double handle, float WorkSizeX){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkSize.x = WorkSizeX;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_work_size_y(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkSize.y;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_work_size_y(double handle, float WorkSizeY){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->WorkSize.y = WorkSizeY;
		#endif
		return 0;
	}
	float lime_imgui_viewport_get_dpi_scale(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->DpiScale;
		#endif
		return 0;
	}
	float lime_imgui_viewport_set_dpi_scale(double handle, float DpiScale){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->DpiScale = DpiScale;
		#endif
		return 0;
	}
	int lime_imgui_viewport_get_parent_viewport_id(double handle){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->ParentViewportId;
		#endif
		return 0;
	}
	int lime_imgui_viewport_set_parent_viewport_id(double handle, int ParentViewportId){
		#ifdef LIME_IMGUI
		ImGuiViewport* viewport = (ImGuiViewport*)getPointerFromHandle(handle);
		return viewport->ParentViewportId = ParentViewportId;
		#endif
		return 0;
	}

	DEFINE_PRIME1 (lime_imgui_viewport_get_id);
	DEFINE_PRIME2 (lime_imgui_viewport_set_id);
	DEFINE_PRIME1 (lime_imgui_viewport_get_flags);
	DEFINE_PRIME2 (lime_imgui_viewport_set_flags);
	DEFINE_PRIME1 (lime_imgui_viewport_get_pos_x);
	DEFINE_PRIME2 (lime_imgui_viewport_set_pos_x);
	DEFINE_PRIME1 (lime_imgui_viewport_get_pos_y);
	DEFINE_PRIME2 (lime_imgui_viewport_set_pos_y);
	DEFINE_PRIME1 (lime_imgui_viewport_get_size_x);
	DEFINE_PRIME2 (lime_imgui_viewport_set_size_x);
	DEFINE_PRIME1 (lime_imgui_viewport_get_size_y);
	DEFINE_PRIME2 (lime_imgui_viewport_set_size_y);
	DEFINE_PRIME1 (lime_imgui_viewport_get_framebuffer_scale_x);
	DEFINE_PRIME2 (lime_imgui_viewport_set_framebuffer_scale_x);
	DEFINE_PRIME1 (lime_imgui_viewport_get_framebuffer_scale_y);
	DEFINE_PRIME2 (lime_imgui_viewport_set_framebuffer_scale_y);
	DEFINE_PRIME1 (lime_imgui_viewport_get_work_pos_x);
	DEFINE_PRIME2 (lime_imgui_viewport_set_work_pos_x);
	DEFINE_PRIME1 (lime_imgui_viewport_get_work_pos_y);
	DEFINE_PRIME2 (lime_imgui_viewport_set_work_pos_y);
	DEFINE_PRIME1 (lime_imgui_viewport_get_work_size_x);
	DEFINE_PRIME2 (lime_imgui_viewport_set_work_size_x);
	DEFINE_PRIME1 (lime_imgui_viewport_get_work_size_y);
	DEFINE_PRIME2 (lime_imgui_viewport_set_work_size_y);
	DEFINE_PRIME1 (lime_imgui_viewport_get_dpi_scale);
	DEFINE_PRIME2 (lime_imgui_viewport_set_dpi_scale);
	DEFINE_PRIME1 (lime_imgui_viewport_get_parent_viewport_id);
	DEFINE_PRIME2 (lime_imgui_viewport_set_parent_viewport_id);

	//ImGuiStorage

	void lime_imgui_storage_clear(double handle){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		storage->Clear();
		#endif
	}
	int lime_imgui_storage_get_int(double handle, int key, int default_val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		return storage->GetInt(key, default_val);
		#endif
		return 0;
	}
	void lime_imgui_storage_set_int(double handle, int key, int val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		storage->SetInt(key, val);
		#endif
	}
	bool lime_imgui_storage_get_bool(double handle, int key, bool default_val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		return storage->GetBool(key, default_val);
		#endif
		return false;
	}
	void lime_imgui_storage_set_bool(double handle, int key, bool val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		storage->SetBool(key, val);
		#endif
	}
	float lime_imgui_storage_get_float(double handle, int key, float default_val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		return storage->GetFloat(key, default_val);
		#endif
		return 0;
	}
	void lime_imgui_storage_set_float(double handle, int key, float val){
		#ifdef LIME_IMGUI
		ImGuiStorage* storage = (ImGuiStorage*)getPointerFromHandle(handle);
		storage->SetFloat(key, val);
		#endif
	}

	DEFINE_PRIME1v (lime_imgui_storage_clear);
	DEFINE_PRIME3 (lime_imgui_storage_get_int);
	DEFINE_PRIME3v (lime_imgui_storage_set_int);
	DEFINE_PRIME3 (lime_imgui_storage_get_bool);
	DEFINE_PRIME3v (lime_imgui_storage_set_bool);
	DEFINE_PRIME3 (lime_imgui_storage_get_float);
	DEFINE_PRIME3v (lime_imgui_storage_set_float);

	//ImGuiTableSortSpecs

	double lime_imgui_table_sort_specs_get_specs(double handle, int index){
		#ifdef LIME_IMGUI
		ImGuiTableSortSpecs* tableSortSpecs = (ImGuiTableSortSpecs*)getPointerFromHandle(handle);
		if (index > 0 && index < tableSortSpecs->SpecsCount)
		{
			return getHandleFromPointer((void*)&tableSortSpecs->Specs[index]);
		}
		#endif
		return 0.0;
	}

	int lime_imgui_table_sort_specs_get_specs_count(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableSortSpecs* tableSortSpecs = (ImGuiTableSortSpecs*)getPointerFromHandle(handle);
		return tableSortSpecs->SpecsCount;
		#endif
		return 0;
	}
	int lime_imgui_table_sort_specs_set_specs_count(double handle, int SpecsCount){
		#ifdef LIME_IMGUI
		ImGuiTableSortSpecs* tableSortSpecs = (ImGuiTableSortSpecs*)getPointerFromHandle(handle);
		return tableSortSpecs->SpecsCount = SpecsCount;
		#endif
		return 0;
	}
	bool lime_imgui_table_sort_specs_get_specs_dirty(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableSortSpecs* tableSortSpecs = (ImGuiTableSortSpecs*)getPointerFromHandle(handle);
		return tableSortSpecs->SpecsDirty;
		#endif
		return false;
	}
	bool lime_imgui_table_sort_specs_set_specs_dirty(double handle, bool SpecsDirty){
		#ifdef LIME_IMGUI
		ImGuiTableSortSpecs* tableSortSpecs = (ImGuiTableSortSpecs*)getPointerFromHandle(handle);
		return tableSortSpecs->SpecsDirty = SpecsDirty;
		#endif
		return false;
	}

	DEFINE_PRIME2 (lime_imgui_table_sort_specs_get_specs);
	DEFINE_PRIME1 (lime_imgui_table_sort_specs_get_specs_count);
	DEFINE_PRIME2 (lime_imgui_table_sort_specs_set_specs_count);
	DEFINE_PRIME1 (lime_imgui_table_sort_specs_get_specs_dirty);
	DEFINE_PRIME2 (lime_imgui_table_sort_specs_set_specs_dirty);

	//ImGuiTableColumnSortSpecs

	int lime_imgui_table_column_sort_specs_get_column_user_id(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableColumnSortSpecs* columnSortSpecs = (ImGuiTableColumnSortSpecs*)getPointerFromHandle(handle);
		return columnSortSpecs->ColumnUserID;
		#endif
		return 0;
	}
	int lime_imgui_table_column_sort_specs_get_column_index(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableColumnSortSpecs* columnSortSpecs = (ImGuiTableColumnSortSpecs*)getPointerFromHandle(handle);
		return columnSortSpecs->ColumnIndex;
		#endif
		return 0;
	}
	int lime_imgui_table_column_sort_specs_get_sort_order(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableColumnSortSpecs* columnSortSpecs = (ImGuiTableColumnSortSpecs*)getPointerFromHandle(handle);
		return columnSortSpecs->SortOrder;
		#endif
		return 0;
	}
	int lime_imgui_table_column_sort_specs_get_sort_direction(double handle){
		#ifdef LIME_IMGUI
		ImGuiTableColumnSortSpecs* columnSortSpecs = (ImGuiTableColumnSortSpecs*)getPointerFromHandle(handle);
		return columnSortSpecs->SortDirection;
		#endif
		return 0;
	}

	DEFINE_PRIME1 (lime_imgui_table_column_sort_specs_get_column_user_id);
	DEFINE_PRIME1 (lime_imgui_table_column_sort_specs_get_column_index);
	DEFINE_PRIME1 (lime_imgui_table_column_sort_specs_get_sort_order);
	DEFINE_PRIME1 (lime_imgui_table_column_sort_specs_get_sort_direction);

	//custom (using internal funcs)

	bool lime_imgui_is_any_window_multi_viewport () {
		#ifdef LIME_IMGUI
		ImGuiContext& g = *ImGui::GetCurrentContext();
		for (ImGuiWindow* window : g.Windows) {
			if (window->ViewportOwned) {
				return true;
			}
		}
		#endif
		return false;
	}
	void lime_imgui_clear_all_window_settings () {
		#ifdef LIME_IMGUI
		ImGuiContext& g = *ImGui::GetCurrentContext();
		for (ImGuiWindow* window : g.Windows) {
			ImGui::ClearWindowSettings(window->Name);
		}
		#endif
	}
	void lime_imgui_bring_named_window_to_display_front (HxString name) {
		#ifdef LIME_IMGUI
		ImGuiWindow* window = ImGui::FindWindowByName(hxs_utf8(name, nullptr));
		if (window) {
			ImGui::BringWindowToDisplayFront(window);
		}
		#endif
	}
	DEFINE_PRIME0 (lime_imgui_is_any_window_multi_viewport);
	DEFINE_PRIME0v (lime_imgui_clear_all_window_settings);
	DEFINE_PRIME1v (lime_imgui_bring_named_window_to_display_front);
}


extern "C" int lime_imgui_register_prims () {

	return 0;

}
