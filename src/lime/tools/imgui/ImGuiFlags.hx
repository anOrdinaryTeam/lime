package lime.tools.imgui;

// Flags for ImGui::Begin()
// (Those are per-window flags. There are shared flags in ImGuiIO: io.ConfigWindowsResizeFromEdges and io.ConfigWindowsMoveFromTitleBarOnly)
enum abstract ImGuiWindowFlags(Int) from Int to Int
{
    var None                   = 0;
    var NoTitleBar             = 1 << 0;   // Disable title-bar
    var NoResize               = 1 << 1;   // Disable user resizing with the lower-right grip
    var NoMove                 = 1 << 2;   // Disable user moving the window
    var NoScrollbar            = 1 << 3;   // Disable scrollbars (window can still scroll with mouse or programmatically)
    var NoScrollWithMouse      = 1 << 4;   // Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    var NoCollapse             = 1 << 5;   // Disable user collapsing window by double-clicking on it. Also referred to as Window Menu Button (e.g. within a docking node).
    var AlwaysAutoResize       = 1 << 6;   // Resize every window to its content every frame
    var NoBackground           = 1 << 7;   // Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
    var NoSavedSettings        = 1 << 8;   // Never load/save settings in .ini file
    var NoMouseInputs          = 1 << 9;   // Disable catching mouse, hovering test with pass through.
    var MenuBar                = 1 << 10;  // Has a menu-bar
    var HorizontalScrollbar    = 1 << 11;  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    var NoFocusOnAppearing     = 1 << 12;  // Disable taking focus when transitioning from hidden to visible state
    var NoBringToFrontOnFocus  = 1 << 13;  // Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
    var AlwaysVerticalScrollbar= 1 << 14;  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
    var AlwaysHorizontalScrollbar=1<< 15;  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    var NoNavInputs            = 1 << 16;  // No keyboard/gamepad navigation within the window
    var NoNavFocus             = 1 << 17;  // No focusing toward this window with keyboard/gamepad navigation (e.g. skipped by Ctrl+Tab)
    var UnsavedDocument        = 1 << 18;  // Display a dot next to the title. When used in a tab/docking context, tab is selected when clicking the X + closure is not assumed (will wait for user to stop submitting the tab). Otherwise closure is assumed when pressing the X, so if you keep submitting the tab may reappear at end of tab bar.
    var NoDocking              = 1 << 19;  // Disable docking of this window
    var NoNav                  = NoNavInputs | NoNavFocus;
    var NoDecoration           = NoTitleBar | NoResize | NoScrollbar | NoCollapse;
    var NoInputs               = NoMouseInputs | NoNavInputs | NoNavFocus;
}

// Flags for ImGui::BeginChild()
// (Legacy: bit 0 must always correspond to ImGuiChildFlags_Borders to be backward compatible with old API using 'bool border = false'.)
// About using AutoResizeX/AutoResizeY flags:
// - May be combined with SetNextWindowSizeConstraints() to set a min/max size for each axis (see "Demo->Child->Auto-resize with Constraints").
// - Size measurement for a given axis is only performed when the child window is within visible boundaries, or is just appearing.
//   - This allows BeginChild() to return false when not within boundaries (e.g. when scrolling), which is more optimal. BUT it won't update its auto-size while clipped.
//     While not perfect, it is a better default behavior as the always-on performance gain is more valuable than the occasional "resizing after becoming visible again" glitch.
//   - You may also use ImGuiChildFlags_AlwaysAutoResize to force an update even when child window is not in view.
//     HOWEVER PLEASE UNDERSTAND THAT DOING SO WILL PREVENT BeginChild() FROM EVER RETURNING FALSE, disabling benefits of coarse clipping.
enum abstract ImGuiChildFlags(Int) from Int to Int
{
    var None                    = 0;
    var Borders                 = 1 << 0;   // Show an outer border and enable WindowPadding. (IMPORTANT: this is always == 1 == true for legacy reason)
    var AlwaysUseWindowPadding  = 1 << 1;   // Pad with style.WindowPadding even if no border are drawn (no padding by default for non-bordered child windows because it makes more sense)
    var ResizeX                 = 1 << 2;   // Allow resize from right border (layout direction). Enable .ini saving (unless NoSavedSettings passed to window flags)
    var ResizeY                 = 1 << 3;   // Allow resize from bottom border (layout direction). "
    var AutoResizeX             = 1 << 4;   // Enable auto-resizing width. Read "IMPORTANT: Size measurement" details above.
    var AutoResizeY             = 1 << 5;   // Enable auto-resizing height. Read "IMPORTANT: Size measurement" details above.
    var AlwaysAutoResize        = 1 << 6;   // Combined with AutoResizeX/AutoResizeY. Always measure size even when child is hidden, always return true, always disable clipping optimization! NOT RECOMMENDED.
    var FrameStyle              = 1 << 7;   // Style the child window like a framed item: use FrameBg, FrameRounding, FrameBorderSize, FramePadding instead of ChildBg, ChildRounding, ChildBorderSize, WindowPadding.
    var NavFlattened            = 1 << 8;   // [BETA] Share focus scope, allow keyboard/gamepad navigation to cross over parent border to this child or between sibling child windows.
}

// Flags for ImGui::PushItemFlag()
// (Those are shared by all submitted items)
enum abstract ImGuiItemFlags(Int) from Int to Int
{
    var None                     = 0;        // (Default)
    var NoTabStop                = 1 << 0;   // false    // Disable keyboard tabbing. This is a "lighter" version of ImGuiItemFlags_NoNav.
    var NoNav                    = 1 << 1;   // false    // Disable any form of focusing (keyboard/gamepad directional navigation and SetKeyboardFocusHere() calls).
    var NoNavDefaultFocus        = 1 << 2;   // false    // Disable item being a candidate for default focus (e.g. used by title bar items).
    var ButtonRepeat             = 1 << 3;   // false    // Any button-like behavior will have repeat mode enabled (based on io.KeyRepeatDelay and io.KeyRepeatRate values). Note that you can also call IsItemActive() after any button to tell if it is being held.
    var AutoClosePopups          = 1 << 4;   // true     // MenuItem()/Selectable() automatically close their parent popup window.
    var AllowDuplicateId         = 1 << 5;   // false    // Allow submitting an item with the same identifier as an item already submitted this frame without triggering a warning tooltip if io.ConfigDebugHighlightIdConflicts is set.
    var Disabled                 = 1 << 6;   // false    // [Internal] Disable interactions. DOES NOT affect visuals. This is used by BeginDisabled()/EndDisabled() and only provided here so you can read back via GetItemFlags().
}

// Flags for ImGui::InputText()
// (Those are per-item flags. There are shared flags in ImGuiIO: io.ConfigInputTextCursorBlink and io.ConfigInputTextEnterKeepActive)
enum abstract ImGuiInputTextFlags(Int) from Int to Int
{
    // Basic filters (also see ImGuiInputTextFlags_CallbackCharFilter)
    var None                = 0;
    var CharsDecimal        = 1 << 0;   // Allow 0123456789.+-*/
    var CharsHexadecimal    = 1 << 1;   // Allow 0123456789ABCDEFabcdef
    var CharsScientific     = 1 << 2;   // Allow 0123456789.+-*/eE (Scientific notation input)
    var CharsUppercase      = 1 << 3;   // Turn a..z into A..Z
    var CharsNoBlank        = 1 << 4;   // Filter out spaces, tabs

    // Inputs
    var AllowTabInput       = 1 << 5;   // Pressing TAB input a '\t' character into the text field
    var EnterReturnsTrue    = 1 << 6;   // Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider using IsItemDeactivatedAfterEdit() instead!
    var EscapeClearsAll     = 1 << 7;   // Escape key clears content if not empty, and deactivate otherwise (contrast to default behavior of Escape to revert)
    var CtrlEnterForNewLine = 1 << 8;   // In multi-line mode: validate with Enter, add new line with Ctrl+Enter (default is opposite: validate with Ctrl+Enter, add line with Enter). Note that Shift+Enter always enter a new line either way.

    // Other options
    var ReadOnly            = 1 << 9;   // Read-only mode
    var Password            = 1 << 10;  // Password mode, display all characters as '*', disable copy
    var AlwaysOverwrite     = 1 << 11;  // Overwrite mode
    var AutoSelectAll       = 1 << 12;  // Select entire text when first taking mouse focus
    var ParseEmptyRefVal    = 1 << 13;  // InputFloat(), InputInt(), InputScalar() etc. only: parse empty string as zero value.
    var DisplayEmptyRefVal  = 1 << 14;  // InputFloat(), InputInt(), InputScalar() etc. only: when value is zero, do not display it. Generally used with ImGuiInputTextFlags_ParseEmptyRefVal.
    var NoHorizontalScroll  = 1 << 15;  // Disable following the cursor horizontally
    var NoUndoRedo          = 1 << 16;  // Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().

    // Elide display / Alignment
    var ElideLeft           = 1 << 17;  // When text doesn't fit, elide left side to ensure right side stays visible. Useful for path/filenames. Single-line only!

    // Callback features
    var CallbackCompletion  = 1 << 18;  // Callback on pressing TAB (for completion handling)
    var CallbackHistory     = 1 << 19;  // Callback on pressing Up/Down arrows (for history handling)
    var CallbackAlways      = 1 << 20;  // Callback on each iteration. User code may query cursor position, modify text buffer.
    var CallbackCharFilter  = 1 << 21;  // Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
    var CallbackResize      = 1 << 22;  // Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
    var CallbackEdit        = 1 << 23;  // Callback on any edit. Note that InputText() already returns true on edit + you can always use IsItemEdited(). The callback is useful to manipulate the underlying buffer while focus is active.

    // Multi-line Word-Wrapping [BETA]
    // - Not well tested yet. Please report any incorrect cursor movement, selection behavior etc. bug to https://github.com/ocornut/imgui/issues/3237.
    // - Wrapping style is not ideal. Wrapping of long words/sections (e.g. words larger than total available width) may be particularly unpleasing.
    // - Wrapping width needs to always account for the possibility of a vertical scrollbar.
    // - It is much slower than regular text fields.
    //   Ballpark estimate of cost on my 2019 desktop PC: for a 100 KB text buffer: +~0.3 ms (Optimized) / +~1.0 ms (Debug build).
    //   The CPU cost is very roughly proportional to text length, so a 10 KB buffer should cost about ten times less.
    var WordWrap            = 1 << 24;  // InputTextMultiline(): word-wrap lines that are too long.

    // Obsolete names
    //ImGuiInputTextFlags_AlwaysInsertMode  = ImGuiInputTextFlags_AlwaysOverwrite   // [renamed in 1.82] name was not matching behavior
}

// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
enum abstract ImGuiTreeNodeFlags(Int) from Int to Int
{
    var None                 = 0;
    var Selected             = 1 << 0;   // Draw as selected
    var Framed               = 1 << 1;   // Draw frame with background (e.g. for CollapsingHeader)
    var AllowOverlap         = 1 << 2;   // Hit testing will allow subsequent widgets to overlap this one. Require previous frame HoveredId to match before being usable. Shortcut to calling SetNextItemAllowOverlap().
    var NoTreePushOnOpen     = 1 << 3;   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
    var NoAutoOpenOnLog      = 1 << 4;   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
    var DefaultOpen          = 1 << 5;   // Default node to be open
    var OpenOnDoubleClick    = 1 << 6;   // Open on double-click instead of simple click (default for multi-select unless any _OpenOnXXX behavior is set explicitly). Both behaviors may be combined.
    var OpenOnArrow          = 1 << 7;   // Open when clicking on the arrow part (default for multi-select unless any _OpenOnXXX behavior is set explicitly). Both behaviors may be combined.
    var Leaf                 = 1 << 8;   // No collapsing, no arrow (use as a convenience for leaf nodes). Note: will always open a tree/id scope and return true. If you never use that scope, add ImGuiTreeNodeFlags_NoTreePushOnOpen.
    var Bullet               = 1 << 9;   // Display a bullet instead of arrow. IMPORTANT: node can still be marked open/close if you don't set the _Leaf flag!
    var FramePadding         = 1 << 10;  // Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding() before the node.
    var SpanAvailWidth       = 1 << 11;  // Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line without using AllowOverlap mode.
    var SpanFullWidth        = 1 << 12;  // Extend hit box to the left-most and right-most edges (cover the indent area).
    var SpanLabelWidth       = 1 << 13;  // Narrow hit box + narrow hovering highlight, will only cover the label text.
    var SpanAllColumns       = 1 << 14;  // Frame will span all columns of its container table (label will still fit in current column)
    var LabelSpanAllColumns  = 1 << 15;  // Label will span all columns of its container table
    //ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 16;  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
    var NavLeftJumpsToParent = 1 << 17;  // Nav: left arrow moves back to parent. This is processed in TreePop() when there's an unfulfilled Left nav request remaining.
    var CollapsingHeader     = Framed | NoTreePushOnOpen | NoAutoOpenOnLog;

    // [EXPERIMENTAL] Draw lines connecting TreeNode hierarchy. Discuss in GitHub issue #2920.
    // Default value is pulled from style.TreeLinesFlags. May be overridden in TreeNode calls.
    var DrawLinesNone        = 1 << 18;  // No lines drawn
    var DrawLinesFull        = 1 << 19;  // Horizontal lines to child nodes. Vertical line drawn down to TreePop() position: cover full contents. Faster (for large trees).
    var DrawLinesToNodes     = 1 << 20;  // Horizontal lines to child nodes. Vertical line drawn down to bottom-most child node. Slower (for large trees).
}

// Flags for OpenPopup*(), BeginPopupContext*(), IsPopupOpen() functions.
// - IMPORTANT: If you ever used the left mouse button with BeginPopupContextXXX() helpers before 1.92.6: Read "API BREAKING CHANGES" 2026/01/07 (1.92.6) entry in imgui.cpp or GitHub topic #9157.
// - Multiple buttons currently cannot be combined/or-ed in those functions (we could allow it later).
enum abstract ImGuiPopupFlags(Int) from Int to Int
{
    var None                    = 0;
    var MouseButtonLeft         = 1 << 2;   // For BeginPopupContext*(): open on Left Mouse release. Only one button allowed!
    var MouseButtonRight        = 2 << 2;   // For BeginPopupContext*(): open on Right Mouse release. Only one button allowed! (default)
    var MouseButtonMiddle       = 3 << 2;   // For BeginPopupContext*(): open on Middle Mouse release. Only one button allowed!
    var NoReopen                = 1 << 5;   // For OpenPopup*(), BeginPopupContext*(): don't reopen same popup if already open (won't reposition, won't reinitialize navigation)
    //ImGuiPopupFlags_NoReopenAlwaysNavInit = 1 << 6;   // For OpenPopup*(), BeginPopupContext*(): focus and initialize navigation even when not reopening.
    var NoOpenOverExistingPopup = 1 << 7;   // For OpenPopup*(), BeginPopupContext*(): don't open if there's already a popup at the same level of the popup stack
    var NoOpenOverItems         = 1 << 8;   // For BeginPopupContextWindow(): don't return true when hovering items, only when hovering empty space
    var AnyPopupId              = 1 << 10;  // For IsPopupOpen(): ignore the ImGuiID parameter and test for any popup.
    var AnyPopupLevel           = 1 << 11;  // For IsPopupOpen(): search/test at any level of the popup stack (default test in the current level)
    var AnyPopup                = AnyPopupId | AnyPopupLevel;
    var MouseButtonShift_       = 2;        // [Internal]
    var MouseButtonMask_        = 0x0C;     // [Internal]
    var InvalidMask_            = 0x03;     // [Internal] Reserve legacy bits 0-1 to detect incorrectly passing 1 or 2 to the function.
}

// Flags for ImGui::Selectable()
enum abstract ImGuiSelectableFlags(Int) from Int to Int
{
    var None               = 0;
    var NoAutoClosePopups  = 1 << 0;   // Clicking this doesn't close parent popup window (overrides ImGuiItemFlags_AutoClosePopups)
    var SpanAllColumns     = 1 << 1;   // Frame will span all columns of its container table (text will still fit in current column)
    var AllowDoubleClick   = 1 << 2;   // Generate press events on double clicks too
    var Disabled           = 1 << 3;   // Cannot be selected, display grayed out text
    var AllowOverlap       = 1 << 4;   // Hit testing will allow subsequent widgets to overlap this one. Require previous frame HoveredId to match before being usable. Shortcut to calling SetNextItemAllowOverlap().
    var Highlight          = 1 << 5;   // Make the item be displayed as if it is hovered
    var SelectOnNav        = 1 << 6;   // Auto-select when moved into, unless Ctrl is held. Automatic when in a BeginMultiSelect() block.
}

// Flags for ImGui::BeginCombo()
enum abstract ImGuiComboFlags(Int) from Int to Int
{
    var None                    = 0;
    var PopupAlignLeft          = 1 << 0;   // Align the popup toward the left by default
    var HeightSmall             = 1 << 1;   // Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
    var HeightRegular           = 1 << 2;   // Max ~8 items visible (default)
    var HeightLarge             = 1 << 3;   // Max ~20 items visible
    var HeightLargest           = 1 << 4;   // As many fitting items as possible
    var NoArrowButton           = 1 << 5;   // Display on the preview box without the square arrow button
    var NoPreview               = 1 << 6;   // Display only a square arrow button
    var WidthFitPreview         = 1 << 7;   // Width dynamically calculated from preview contents
    var HeightMask_             = HeightSmall | HeightRegular | HeightLarge | HeightLargest;
}

// Flags for ImGui::BeginTabBar()
enum abstract ImGuiTabBarFlags(Int) from Int to Int
{
    var None                           = 0;
    var Reorderable                    = 1 << 0;   // Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
    var AutoSelectNewTabs              = 1 << 1;   // Automatically select new tabs when they appear
    var TabListPopupButton             = 1 << 2;   // Disable buttons to open the tab list popup
    var NoCloseWithMiddleMouseButton   = 1 << 3;   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You may handle this behavior manually on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
    var NoTabListScrollingButtons      = 1 << 4;   // Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
    var NoTooltip                      = 1 << 5;   // Disable tooltips when hovering a tab
    var DrawSelectedOverline           = 1 << 6;   // Draw selected overline markers over selected tab

    // Fitting/Resize policy
    var FittingPolicyMixed             = 1 << 7;   // Shrink down tabs when they don't fit, until width is style.TabMinWidthShrink, then enable scrolling. Setting TabMinWidthShrink to FLT_MAX makes this behave like ImGuiTabBarFlags_FittingPolicyScroll.
    var FittingPolicyShrink            = 1 << 8;   // Shrink down tabs when they don't fit
    var FittingPolicyScroll            = 1 << 9;   // Enable scrolling buttons when tabs don't fit
    var FittingPolicyMask_             = FittingPolicyMixed | FittingPolicyShrink | FittingPolicyScroll;
    var FittingPolicyDefault_          = FittingPolicyMixed;
}

// Flags for ImGui::BeginTabItem()
enum abstract ImGuiTabItemFlags(Int) from Int to Int
{
    var None                          = 0;
    var UnsavedDocument               = 1 << 0;   // Display a dot next to the title + set ImGuiTabItemFlags_NoAssumedClosure.
    var SetSelected                   = 1 << 1;   // Trigger flag to programmatically make the tab selected when calling BeginTabItem()
    var NoCloseWithMiddleMouseButton  = 1 << 2;   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You may handle this behavior manually on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
    var NoPushId                      = 1 << 3;   // Don't call PushID()/PopID() on BeginTabItem()/EndTabItem()
    var NoTooltip                     = 1 << 4;   // Disable tooltip for the given tab
    var NoReorder                     = 1 << 5;   // Disable reordering this tab or having another tab cross over this tab
    var Leading                       = 1 << 6;   // Enforce the tab position to the left of the tab bar (after the tab list popup button)
    var Trailing                      = 1 << 7;   // Enforce the tab position to the right of the tab bar (before the scrolling buttons)
    var NoAssumedClosure              = 1 << 8;   // Tab is selected when trying to close + closure is not immediately assumed (will wait for user to stop submitting the tab). Otherwise closure is assumed when pressing the X, so if you keep submitting the tab may reappear at end of tab bar.
}

// Flags for ImGui::IsWindowFocused()
enum abstract ImGuiFocusedFlags(Int) from Int to Int
{
    var None                          = 0;
    var ChildWindows                  = 1 << 0;   // Return true if any children of the window is focused
    var RootWindow                    = 1 << 1;   // Test from root window (top most parent of the current hierarchy)
    var AnyWindow                     = 1 << 2;   // Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
    var NoPopupHierarchy              = 1 << 3;   // Do not consider popup hierarchy (do not treat popup emitter as parent of popup) (when used with _ChildWindows or _RootWindow)
    var DockHierarchy                 = 1 << 4;   // Consider docking hierarchy (treat dockspace host as parent of docked window) (when used with _ChildWindows or _RootWindow)
    var RootAndChildWindows           = RootWindow | ChildWindows;
}

// Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
// Note: if you are trying to check whether your mouse should be dispatched to Dear ImGui or to your app, you should use 'io.WantCaptureMouse' instead! Please read the FAQ!
// Note: windows with the ImGuiWindowFlags_NoInputs flag are ignored by IsWindowHovered() calls.
enum abstract ImGuiHoveredFlags(Int) from Int to Int
{
    var None                          = 0;        // Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
    var ChildWindows                  = 1 << 0;   // IsWindowHovered() only: Return true if any children of the window is hovered
    var RootWindow                    = 1 << 1;   // IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
    var AnyWindow                     = 1 << 2;   // IsWindowHovered() only: Return true if any window is hovered
    var NoPopupHierarchy              = 1 << 3;   // IsWindowHovered() only: Do not consider popup hierarchy (do not treat popup emitter as parent of popup) (when used with _ChildWindows or _RootWindow)
    var DockHierarchy                 = 1 << 4;   // IsWindowHovered() only: Consider docking hierarchy (treat dockspace host as parent of docked window) (when used with _ChildWindows or _RootWindow)
    var AllowWhenBlockedByPopup       = 1 << 5;   // Return true even if a popup window is normally blocking access to this item/window
    //ImGuiHoveredFlags_AllowWhenBlockedByModal     = 1 << 6;   // Return true even if a modal popup window is normally blocking access to this item/window. FIXME-TODO: Unavailable yet.
    var AllowWhenBlockedByActiveItem  = 1 << 7;   // Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
    var AllowWhenOverlappedByItem     = 1 << 8;   // IsItemHovered() only: Return true even if the item uses AllowOverlap mode and is overlapped by another hoverable item.
    var AllowWhenOverlappedByWindow   = 1 << 9;   // IsItemHovered() only: Return true even if the position is obstructed or overlapped by another window.
    var AllowWhenDisabled             = 1 << 10;  // IsItemHovered() only: Return true even if the item is disabled
    var NoNavOverride                 = 1 << 11;  // IsItemHovered() only: Disable using keyboard/gamepad navigation state when active, always query mouse
    var AllowWhenOverlapped           = AllowWhenOverlappedByItem | AllowWhenOverlappedByWindow;
    var RectOnly                      = AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped;
    var RootAndChildWindows           = RootWindow | ChildWindows;

    // Tooltips mode
    // - typically used in IsItemHovered() + SetTooltip() sequence.
    // - this is a shortcut to pull flags from 'style.HoverFlagsForTooltipMouse' or 'style.HoverFlagsForTooltipNav' where you can reconfigure desired behavior.
    //   e.g. 'HoverFlagsForTooltipMouse' defaults to 'ImGuiHoveredFlags_Stationary | ImGuiHoveredFlags_DelayShort | ImGuiHoveredFlags_AllowWhenDisabled'.
    // - for frequently actioned or hovered items providing a tooltip, you want may to use ImGuiHoveredFlags_ForTooltip (stationary + delay) so the tooltip doesn't show too often.
    // - for items which main purpose is to be hovered, or items with low affordance, or in less consistent apps, prefer no delay or shorter delay.
    var ForTooltip                    = 1 << 12;  // Shortcut for standard flags when using IsItemHovered() + SetTooltip() sequence.

    // (Advanced) Mouse Hovering delays.
    // - generally you can use ImGuiHoveredFlags_ForTooltip to use application-standardized flags.
    // - use those if you need specific overrides.
    var Stationary                    = 1 << 13;  // Require mouse to be stationary for style.HoverStationaryDelay (~0.15 sec) _at least one time_. After this, can move on same item/window. Using the stationary test tends to reduces the need for a long delay.
    var DelayNone                     = 1 << 14;  // IsItemHovered() only: Return true immediately (default). As this is the default you generally ignore this.
    var DelayShort                    = 1 << 15;  // IsItemHovered() only: Return true after style.HoverDelayShort elapsed (~0.15 sec) (shared between items) + requires mouse to be stationary for style.HoverStationaryDelay (once per item).
    var DelayNormal                   = 1 << 16;  // IsItemHovered() only: Return true after style.HoverDelayNormal elapsed (~0.40 sec) (shared between items) + requires mouse to be stationary for style.HoverStationaryDelay (once per item).
    var NoSharedDelay                 = 1 << 17;  // IsItemHovered() only: Disable shared delay system where moving from one item to the next keeps the previous timer for a short time (standard for tooltips with long delays)
}

// Flags for ImGui::DockSpace(), shared/inherited by child nodes.
// (Some flags can be applied to individual nodes directly)
// FIXME-DOCK: Also see ImGuiDockNodeFlagsPrivate_ which may involve using the WIP and internal DockBuilder api.
enum abstract ImGuiDockNodeFlags(Int) from Int to Int
{
    var None                         = 0;
    var KeepAliveOnly                = 1 << 0;   //       // Don't display the dockspace node but keep it alive. Windows docked into this dockspace node won't be undocked.
    //ImGuiDockNodeFlags_NoCentralNode              = 1 << 1;   //       // Disable Central Node (the node which can stay empty)
    var NoDockingOverCentralNode     = 1 << 2;   //       // Disable docking over the Central Node, which will be always kept empty.
    var PassthruCentralNode          = 1 << 3;   //       // Enable passthru dockspace: 1) DockSpace() will render a ImGuiCol_WindowBg background covering everything excepted the Central Node when empty. Meaning the host window should probably use SetNextWindowBgAlpha(0.0f) prior to Begin() when using this. 2) When Central Node is empty: let inputs pass-through + won't display a DockingEmptyBg background. See demo for details.
    var NoDockingSplit               = 1 << 4;   //       // Disable other windows/nodes from splitting this node.
    var NoResize                     = 1 << 5;   // Saved // Disable resizing node using the splitter/separators. Useful with programmatically setup dockspaces.
    var AutoHideTabBar               = 1 << 6;   //       // Tab bar will automatically hide when there is a single window in the dock node.
    var NoUndocking                  = 1 << 7;   //       // Disable undocking this node.
}

// Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
enum abstract ImGuiDragDropFlags(Int) from Int to Int
{
    var None                         = 0;
    // BeginDragDropSource() flags
    var SourceNoPreviewTooltip       = 1 << 0;   // Disable preview tooltip. By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disables this behavior.
    var SourceNoDisableHover         = 1 << 1;   // By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disables this behavior so you can still call IsItemHovered() on the source item.
    var SourceNoHoldToOpenOthers     = 1 << 2;   // Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
    var SourceAllowNullID            = 1 << 3;   // Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
    var SourceExtern                 = 1 << 4;   // External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
    var PayloadAutoExpire            = 1 << 5;   // Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
    var PayloadNoCrossContext        = 1 << 6;   // Hint to specify that the payload may not be copied outside current dear imgui context.
    var PayloadNoCrossProcess        = 1 << 7;   // Hint to specify that the payload may not be copied outside current process.
    // AcceptDragDropPayload() flags
    var AcceptBeforeDelivery         = 1 << 10;  // AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
    var AcceptNoDrawDefaultRect      = 1 << 11;  // Do not draw the default highlight rectangle when hovering over target.
    var AcceptNoPreviewTooltip       = 1 << 12;  // Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
    var AcceptDrawAsHovered          = 1 << 13;  // Accepting item will render as if hovered. Useful for e.g. a Button() used as a drop target.
    var AcceptPeekOnly               = AcceptBeforeDelivery | AcceptNoDrawDefaultRect; // For peeking ahead and inspecting the payload before delivery.
}

// Flags for Shortcut(), SetNextItemShortcut(),
// (and for upcoming extended versions of IsKeyPressed(), IsMouseClicked(), Shortcut(), SetKeyOwner(), SetItemKeyOwner() that are still in imgui_internal.h)
// Don't mistake with ImGuiInputTextFlags! (which is for ImGui::InputText() function)
enum abstract ImGuiInputFlags(Int) from Int to Int
{
    var None                    = 0;
    var Repeat                  = 1 << 0;   // Enable repeat. Return true on successive repeats. Default for legacy IsKeyPressed(). NOT Default for legacy IsMouseClicked(). MUST BE == 1.

    // Flags for Shortcut(), SetNextItemShortcut()
    // - Routing policies: RouteGlobal+OverActive >> RouteActive or RouteFocused (if owner is active item) >> RouteGlobal+OverFocused >> RouteFocused (if in focused window stack) >> RouteGlobal.
    // - Default policy is RouteFocused. Can select only 1 policy among all available.
    var RouteActive             = 1 << 10;  // Route to active item only.
    var RouteFocused            = 1 << 11;  // Route to windows in the focus stack (DEFAULT). Deep-most focused window takes inputs. Active item takes inputs over deep-most focused window.
    var RouteGlobal             = 1 << 12;  // Global route (unless a focused window or active item registered the route).
    var RouteAlways             = 1 << 13;  // Do not register route, poll keys directly.
    // - Routing options
    var RouteOverFocused        = 1 << 14;  // Option: global route: higher priority than focused route (unless active item in focused route).
    var RouteOverActive         = 1 << 15;  // Option: global route: higher priority than active item. Unlikely you need to use that: will interfere with every active items, e.g. Ctrl+A registered by InputText will be overridden by this. May not be fully honored as user/internal code is likely to always assume they can access keys when active.
    var RouteUnlessBgFocused    = 1 << 16;  // Option: global route: will not be applied if underlying background/void is focused (== no Dear ImGui windows are focused). Useful for overlay applications.
    var RouteFromRootWindow     = 1 << 17;  // Option: route evaluated from the point of view of root window rather than current window.

    // Flags for SetNextItemShortcut()
    var Tooltip                 = 1 << 18;  // Automatically display a tooltip when hovering item [BETA] Unsure of right api (opt-in/opt-out)
}

// Configuration flags stored in io.ConfigFlags. Set by user/application.
// Note that nowadays most of our configuration options are in other ImGuiIO fields, e.g. io.ConfigWindowsMoveFromTitleBarOnly.
enum abstract ImGuiConfigFlags(Int) from Int to Int
{
    var None                   = 0;
    var NavEnableKeyboard      = 1 << 0;   // Master keyboard navigation enable flag. Enable full Tabbing + directional arrows + Space/Enter to activate. Note: some features such as basic Tabbing and CtrL+Tab are enabled by regardless of this flag (and may be disabled via other means, see #4828, #9218).
    var NavEnableGamepad       = 1 << 1;   // Master gamepad navigation enable flag. Backend also needs to set ImGuiBackendFlags_HasGamepad.
    var NoMouse                = 1 << 4;   // Instruct dear imgui to disable mouse inputs and interactions.
    var NoMouseCursorChange    = 1 << 5;   // Instruct backend to not alter mouse cursor shape and visibility. Use if the backend cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.
    var NoKeyboard             = 1 << 6;   // Instruct dear imgui to disable keyboard inputs and interactions. This is done by ignoring keyboard events and clearing existing states.

    // [BETA] Docking
    var DockingEnable          = 1 << 7;   // Docking enable flags.

    // [BETA] Viewports
    // When using viewports it is recommended that your default value for ImGuiCol_WindowBg is opaque (Alpha=1.0) so transition to a viewport won't be noticeable.
    var ViewportsEnable        = 1 << 10;  // Viewport enable flags (require both ImGuiBackendFlags_PlatformHasViewports + ImGuiBackendFlags_RendererHasViewports set by the respective backends)

    // [Unused] User storage (to allow your backend/engine to communicate to code that may be shared between multiple projects. Those flags are NOT used by core Dear ImGui)
    var IsSRGB                 = 1 << 20;  // Application is SRGB-aware.
    var IsTouchScreen          = 1 << 21;  // Application is using a touch screen instead of a mouse.
}

// Backend capabilities flags stored in io.BackendFlags. Set by imgui_impl_xxx or custom backend.
enum abstract ImGuiBackendFlags(Int) from Int to Int
{
    var None                  = 0;
    var HasGamepad            = 1 << 0;   // Backend Platform supports gamepad and currently has one connected.
    var HasMouseCursors       = 1 << 1;   // Backend Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
    var HasSetMousePos        = 1 << 2;   // Backend Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if io.ConfigNavMoveSetMousePos is set).
    var RendererHasVtxOffset  = 1 << 3;   // Backend Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.
    var RendererHasTextures   = 1 << 4;   // Backend Renderer supports ImTextureData requests to create/update/destroy textures. This enables incremental texture updates and texture reloads. See https://github.com/ocornut/imgui/blob/master/docs/BACKENDS.md for instructions on how to upgrade your custom backend.

    // [BETA] Multi-Viewports
    var RendererHasViewports  = 1 << 10;  // Backend Renderer supports multiple viewports.
    var PlatformHasViewports  = 1 << 11;  // Backend Platform supports multiple viewports.
    var HasMouseHoveredViewport=1 << 12;  // Backend Platform supports calling io.AddMouseViewportEvent() with the viewport under the mouse. IF POSSIBLE, ignore viewports with the ImGuiViewportFlags_NoInputs flag (Win32 backend, GLFW 3.30+ backend can do this, SDL backend cannot). If this cannot be done, Dear ImGui needs to use a flawed heuristic to find the viewport under.
    var HasParentViewport     = 1 << 13;  // Backend Platform supports honoring viewport->ParentViewport/ParentViewportId value, by applying the corresponding parent/child relationship at the Platform level. Child windows always appear in front of their parent window.
}

// Flags for InvisibleButton() [extended in imgui_internal.h]
enum abstract ImGuiButtonFlags(Int) from Int to Int
{
    var None                   = 0;
    var MouseButtonLeft        = 1 << 0;   // React on left mouse button (default)
    var MouseButtonRight       = 1 << 1;   // React on right mouse button
    var MouseButtonMiddle      = 1 << 2;   // React on center mouse button
    var MouseButtonMask_       = MouseButtonLeft | MouseButtonRight | MouseButtonMiddle; // [Internal]
    var EnableNav              = 1 << 3;   // InvisibleButton(): do not disable navigation/tabbing. Otherwise disabled by default.
    var AllowOverlap           = 1 << 12;  // Hit testing will allow subsequent widgets to overlap this one. Require previous frame HoveredId to match before being usable. Shortcut to calling SetNextItemAllowOverlap().
}

// Flags for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
enum abstract ImGuiColorEditFlags(Int) from Int to Int
{
    var None            = 0;
    var NoAlpha         = 1 << 1;   //              // ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
    var NoPicker        = 1 << 2;   //              // ColorEdit: disable picker when clicking on color square.
    var NoOptions       = 1 << 3;   //              // ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
    var NoSmallPreview  = 1 << 4;   //              // ColorEdit, ColorPicker: disable color square preview next to the inputs. (e.g. to show only the inputs)
    var NoInputs        = 1 << 5;   //              // ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview color square).
    var NoTooltip       = 1 << 6;   //              // ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
    var NoLabel         = 1 << 7;   //              // ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
    var NoSidePreview   = 1 << 8;   //              // ColorPicker: disable bigger color preview on right side of the picker, use small color square preview instead.
    var NoDragDrop      = 1 << 9;   //              // ColorEdit: disable drag and drop target/source. ColorButton: disable drag and drop source.
    var NoBorder        = 1 << 10;  //              // ColorButton: disable border (which is enforced by default)
    var NoColorMarkers  = 1 << 11;  //              // ColorEdit: disable rendering R/G/B/A color marker. May also be disabled globally by setting style.ColorMarkerSize = 0.

    // Alpha preview
    // - Prior to 1.91.8 (2025/01/21): alpha was made opaque in the preview by default using old name ImGuiColorEditFlags_AlphaPreview.
    // - We now display the preview as transparent by default. You can use ImGuiColorEditFlags_AlphaOpaque to use old behavior.
    // - The new flags may be combined better and allow finer controls.
    var AlphaOpaque     = 1 << 12;  //              // ColorEdit, ColorPicker, ColorButton: disable alpha in the preview,. Contrary to _NoAlpha it may still be edited when calling ColorEdit4()/ColorPicker4(). For ColorButton() this does the same as _NoAlpha.
    var AlphaNoBg       = 1 << 13;  //              // ColorEdit, ColorPicker, ColorButton: disable rendering a checkerboard background behind transparent color.
    var AlphaPreviewHalf= 1 << 14;  //              // ColorEdit, ColorPicker, ColorButton: display half opaque / half transparent preview.

    // User Options (right-click on widget to change some of them).
    var AlphaBar        = 1 << 18;  //              // ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
    var HDR             = 1 << 19;  //              // (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
    var DisplayRGB      = 1 << 20;  // [Display]    // ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
    var DisplayHSV      = 1 << 21;  // [Display]    // "
    var DisplayHex      = 1 << 22;  // [Display]    // "
    var Uint8           = 1 << 23;  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
    var Float           = 1 << 24;  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
    var PickerHueBar    = 1 << 25;  // [Picker]     // ColorPicker: bar for Hue, rectangle for Sat/Value.
    var PickerHueWheel  = 1 << 26;  // [Picker]     // ColorPicker: wheel for Hue, triangle for Sat/Value.
    var InputRGB        = 1 << 27;  // [Input]      // ColorEdit, ColorPicker: input and output data in RGB format.
    var InputHSV        = 1 << 28;  // [Input]      // ColorEdit, ColorPicker: input and output data in HSV format.

    // Defaults Options. You can set application defaults using SetColorEditOptions(). The intent is that you probably don't want to
    // override them in most of your calls. Let the user choose via the option menu and/or call SetColorEditOptions() once during startup.
    var DefaultOptions_ = Uint8 | DisplayRGB | InputRGB | PickerHueBar;

    // [Internal] Masks
    var AlphaMask_      = NoAlpha | AlphaOpaque | AlphaNoBg | AlphaPreviewHalf;
    var DisplayMask_    = DisplayRGB | DisplayHSV | DisplayHex;
    var DataTypeMask_   = Uint8 | Float;
    var PickerMask_     = PickerHueWheel | PickerHueBar;
    var InputMask_      = InputRGB | InputHSV;

    //ImGuiColorEditFlags_RGB = ImGuiColorEditFlags_DisplayRGB, ImGuiColorEditFlags_HSV = ImGuiColorEditFlags_DisplayHSV, ImGuiColorEditFlags_HEX = ImGuiColorEditFlags_DisplayHex  // [renamed in 1.69]
}

// Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
// We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
// (Those are per-item flags. There is shared behavior flag too: ImGuiIO: io.ConfigDragClickToInputText)
enum abstract ImGuiSliderFlags(Int) from Int to Int
{
    var None               = 0;
    var Logarithmic        = 1 << 5;       // Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
    var NoRoundToFormat    = 1 << 6;       // Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits).
    var NoInput            = 1 << 7;       // Disable Ctrl+Click or Enter key allowing to input text directly into the widget.
    var WrapAround         = 1 << 8;       // Enable wrapping around from max to min and from min to max. Only supported by DragXXX() functions for now.
    var ClampOnInput       = 1 << 9;       // Clamp value to min/max bounds when input manually with Ctrl+Click. By default Ctrl+Click allows going out of bounds.
    var ClampZeroRange     = 1 << 10;      // Clamp even if min==max==0.0f. Otherwise due to legacy reason DragXXX functions don't clamp with those values. When your clamping limits are dynamic you almost always want to use it.
    var NoSpeedTweaks      = 1 << 11;      // Disable keyboard modifiers altering tweak speed. Useful if you want to alter tweak speed yourself based on your own logic.
    var ColorMarkers       = 1 << 12;      // DragScalarN(), SliderScalarN(): Draw R/G/B/A color markers on each component.
    var AlwaysClamp        = ClampOnInput | ClampZeroRange;
    var InvalidMask_       = 0x7000000F;   // [Internal] We treat using those bits as being potentially a 'float power' argument from legacy API (obsoleted 2020-08) that has got miscast to this enum, and will trigger an assert if needed.
}

// Flags for ImGui::BeginTable()
// - Important! Sizing policies have complex and subtle side effects, much more so than you would expect.
//   Read comments/demos carefully + experiment with live demos to get acquainted with them.
// - The DEFAULT sizing policies are:
//    - Default to ImGuiTableFlags_SizingFixedFit    if ScrollX is on, or if host window has ImGuiWindowFlags_AlwaysAutoResize.
//    - Default to ImGuiTableFlags_SizingStretchSame if ScrollX is off.
// - When ScrollX is off:
//    - Table defaults to ImGuiTableFlags_SizingStretchSame -> all Columns defaults to ImGuiTableColumnFlags_WidthStretch with same weight.
//    - Columns sizing policy allowed: Stretch (default), Fixed/Auto.
//    - Fixed Columns (if any) will generally obtain their requested width (unless the table cannot fit them all).
//    - Stretch Columns will share the remaining width according to their respective weight.
//    - Mixed Fixed/Stretch columns is possible but has various side-effects on resizing behaviors.
//      The typical use of mixing sizing policies is: any number of LEADING Fixed columns, followed by one or two TRAILING Stretch columns.
//      (this is because the visible order of columns have subtle but necessary effects on how they react to manual resizing).
// - When ScrollX is on:
//    - Table defaults to ImGuiTableFlags_SizingFixedFit -> all Columns defaults to ImGuiTableColumnFlags_WidthFixed
//    - Columns sizing policy allowed: Fixed/Auto mostly.
//    - Fixed Columns can be enlarged as needed. Table will show a horizontal scrollbar if needed.
//    - When using auto-resizing (non-resizable) fixed columns, querying the content width to use item right-alignment e.g. SetNextItemWidth(-FLT_MIN) doesn't make sense, would create a feedback loop.
//    - Using Stretch columns OFTEN DOES NOT MAKE SENSE if ScrollX is on, UNLESS you have specified a value for 'inner_width' in BeginTable().
//      If you specify a value for 'inner_width' then effectively the scrolling space is known and Stretch or mixed Fixed/Stretch columns become meaningful again.
// - Read on documentation at the top of imgui_tables.cpp for details.
enum abstract ImGuiTableFlags(Int) from Int to Int
{
    // Features
    var None                       = 0;
    var Resizable                  = 1 << 0;   // Enable resizing columns.
    var Reorderable                = 1 << 1;   // Enable reordering columns in header row. (Need calling TableSetupColumn() + TableHeadersRow() to display headers, or using ImGuiTableFlags_ContextMenuInBody to access context-menu without headers).
    var Hideable                   = 1 << 2;   // Enable hiding/disabling columns in context menu.
    var Sortable                   = 1 << 3;   // Enable sorting. Call TableGetSortSpecs() to obtain sort specs. Also see ImGuiTableFlags_SortMulti and ImGuiTableFlags_SortTristate.
    var NoSavedSettings            = 1 << 4;   // Disable persisting columns order, width, visibility and sort settings in the .ini file.
    var ContextMenuInBody          = 1 << 5;   // Right-click on columns body/contents will also display table context menu. By default it is available in TableHeadersRow().
    // Decorations
    var RowBg                      = 1 << 6;   // Set each RowBg color with ImGuiCol_TableRowBg or ImGuiCol_TableRowBgAlt (equivalent of calling TableSetBgColor with ImGuiTableBgFlags_RowBg0 on each row manually)
    var BordersInnerH              = 1 << 7;   // Draw horizontal borders between rows.
    var BordersOuterH              = 1 << 8;   // Draw horizontal borders at the top and bottom.
    var BordersInnerV              = 1 << 9;   // Draw vertical borders between columns.
    var BordersOuterV              = 1 << 10;  // Draw vertical borders on the left and right sides.
    var BordersH                   = BordersInnerH | BordersOuterH; // Draw horizontal borders.
    var BordersV                   = BordersInnerV | BordersOuterV; // Draw vertical borders.
    var BordersInner               = BordersInnerV | BordersInnerH; // Draw inner borders.
    var BordersOuter               = BordersOuterV | BordersOuterH; // Draw outer borders.
    var Borders                    = BordersInner | BordersOuter;   // Draw all borders.
    var NoBordersInBody            = 1 << 11;  // [ALPHA] Disable vertical borders in columns Body (borders will always appear in Headers). -> May move to style
    var NoBordersInBodyUntilResize = 1 << 12;  // [ALPHA] Disable vertical borders in columns Body until hovered for resize (borders will always appear in Headers). -> May move to style
    // Sizing Policy (read above for defaults)
    var SizingFixedFit             = 1 << 13;  // Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching contents width.
    var SizingFixedSame            = 2 << 13;  // Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching the maximum contents width of all columns. Implicitly enable ImGuiTableFlags_NoKeepColumnsVisible.
    var SizingStretchProp          = 3 << 13;  // Columns default to _WidthStretch with default weights proportional to each columns contents widths.
    var SizingStretchSame          = 4 << 13;  // Columns default to _WidthStretch with default weights all equal, unless overridden by TableSetupColumn().
    // Sizing Extra Options
    var NoHostExtendX              = 1 << 16;  // Make outer width auto-fit to columns, overriding outer_size.x value. Only available when ScrollX/ScrollY are disabled and Stretch columns are not used.
    var NoHostExtendY              = 1 << 17;  // Make outer height stop exactly at outer_size.y (prevent auto-extending table past the limit). Only available when ScrollX/ScrollY are disabled. Data below the limit will be clipped and not visible.
    var NoKeepColumnsVisible       = 1 << 18;  // Disable keeping column always minimally visible when ScrollX is off and table gets too small. Not recommended if columns are resizable.
    var PreciseWidths              = 1 << 19;  // Disable distributing remainder width to stretched columns (width allocation on a 100-wide table with 3 columns: Without this flag: 33,33,34. With this flag: 33,33,33). With larger number of columns, resizing will appear to be less smooth.
    // Clipping
    var NoClip                     = 1 << 20;  // Disable clipping rectangle for every individual columns (reduce draw command count, items will be able to overflow into other columns). Generally incompatible with TableSetupScrollFreeze().
    // Padding
    var PadOuterX                  = 1 << 21;  // Default if BordersOuterV is on. Enable outermost padding. Generally desirable if you have headers.
    var NoPadOuterX                = 1 << 22;  // Default if BordersOuterV is off. Disable outermost padding.
    var NoPadInnerX                = 1 << 23;  // Disable inner padding between columns (double inner padding if BordersOuterV is on, single inner padding if BordersOuterV is off).
    // Scrolling
    var ScrollX                    = 1 << 24;  // Enable horizontal scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size. Changes default sizing policy. Because this creates a child window, ScrollY is currently generally recommended when using ScrollX.
    var ScrollY                    = 1 << 25;  // Enable vertical scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size.
    // Sorting
    var SortMulti                  = 1 << 26;  // Hold shift when clicking headers to sort on multiple column. TableGetSortSpecs() may return specs where (SpecsCount > 1).
    var SortTristate               = 1 << 27;  // Allow no sorting, disable default sorting. TableGetSortSpecs() may return specs where (SpecsCount == 0).
    // Miscellaneous
    var HighlightHoveredColumn     = 1 << 28;  // Highlight column headers when hovered (may evolve into a fuller highlight)

    // [Internal] Combinations and masks
    var SizingMask_                = SizingFixedFit | SizingFixedSame | SizingStretchProp | SizingStretchSame;
}

// Flags for ImGui::TableSetupColumn()
enum abstract ImGuiTableColumnFlags(Int) from Int to Int
{
    // Input configuration flags
    var None                  = 0;
    var Disabled              = 1 << 0;   // Overriding/master disable flag: hide column, won't show in context menu (unlike calling TableSetColumnEnabled() which manipulates the user accessible state)
    var DefaultHide           = 1 << 1;   // Default as a hidden/disabled column.
    var DefaultSort           = 1 << 2;   // Default as a sorting column.
    var WidthStretch          = 1 << 3;   // Column will stretch. Preferable with horizontal scrolling disabled (default if table sizing policy is _SizingStretchSame or _SizingStretchProp).
    var WidthFixed            = 1 << 4;   // Column will not stretch. Preferable with horizontal scrolling enabled (default if table sizing policy is _SizingFixedFit and table is resizable).
    var NoResize              = 1 << 5;   // Disable manual resizing.
    var NoReorder             = 1 << 6;   // Disable manual reordering this column, this will also prevent other columns from crossing over this column.
    var NoHide                = 1 << 7;   // Disable ability to hide/disable this column.
    var NoClip                = 1 << 8;   // Disable clipping for this column (all NoClip columns will render in a same draw command).
    var NoSort                = 1 << 9;   // Disable ability to sort on this field (even if ImGuiTableFlags_Sortable is set on the table).
    var NoSortAscending       = 1 << 10;  // Disable ability to sort in the ascending direction.
    var NoSortDescending      = 1 << 11;  // Disable ability to sort in the descending direction.
    var NoHeaderLabel         = 1 << 12;  // TableHeadersRow() will submit an empty label for this column. Convenient for some small columns. Name will still appear in context menu or in angled headers. You may append into this cell by calling TableSetColumnIndex() right after the TableHeadersRow() call.
    var NoHeaderWidth         = 1 << 13;  // Disable header text width contribution to automatic column width.
    var PreferSortAscending   = 1 << 14;  // Make the initial sort direction Ascending when first sorting on this column (default).
    var PreferSortDescending  = 1 << 15;  // Make the initial sort direction Descending when first sorting on this column.
    var IndentEnable          = 1 << 16;  // Use current Indent value when entering cell (default for column 0).
    var IndentDisable         = 1 << 17;  // Ignore current Indent value when entering cell (default for columns > 0). Indentation changes _within_ the cell will still be honored.
    var AngledHeader          = 1 << 18;  // TableHeadersRow() will submit an angled header row for this column. Note this will add an extra row.

    // Output status flags, read-only via TableGetColumnFlags()
    var IsEnabled             = 1 << 24;  // Status: is enabled == not hidden by user/api (referred to as "Hide" in _DefaultHide and _NoHide) flags.
    var IsVisible             = 1 << 25;  // Status: is visible == is enabled AND not clipped by scrolling.
    var IsSorted              = 1 << 26;  // Status: is currently part of the sort specs
    var IsHovered             = 1 << 27;  // Status: is hovered by mouse

    // [Internal] Combinations and masks
    var WidthMask_            = WidthStretch | WidthFixed;
    var IndentMask_           = IndentEnable | IndentDisable;
    var StatusMask_           = IsEnabled | IsVisible | IsSorted | IsHovered;
    var NoDirectResize_       = 1 << 30;  // [Internal] Disable user resizing this column directly (it may however we resized indirectly from its left edge)
}

// Flags for ImGui::TableNextRow()
enum abstract ImGuiTableRowFlags(Int) from Int to Int
{
    var None                     = 0;
    var Headers                  = 1 << 0;   // Identify header row (set default background color + width of its contents accounted differently for auto column width)
}

enum abstract ImGuiListClipperFlags(Int) from Int to Int
{
    var None                  = 0;
    var NoSetTableRowCounters = 1 << 0;   // [Internal] Disabled modifying table row counters. Avoid assumption that 1 clipper item == 1 table row.
}

enum abstract ImDrawFlags(Int) from Int to Int
{
    var None                        = 0;
    var RoundCornersTopLeft         = 1 << 4; // AddRect(), AddRectFilled(), PathRect(): enable rounding top-left corner only (when rounding > 0.0f, we default to all corners). Was 0x01.
    var RoundCornersTopRight        = 1 << 5; // AddRect(), AddRectFilled(), PathRect(): enable rounding top-right corner only (when rounding > 0.0f, we default to all corners). Was 0x02.
    var RoundCornersBottomLeft      = 1 << 6; // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-left corner only (when rounding > 0.0f, we default to all corners). Was 0x04.
    var RoundCornersBottomRight     = 1 << 7; // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-right corner only (when rounding > 0.0f, we default to all corners). Wax 0x08.
    var RoundCornersNone            = 1 << 8; // AddRect(), AddRectFilled(), PathRect(): disable rounding on all corners (when rounding > 0.0f). This is NOT zero, NOT an implicit flag!
    var Closed                      = 1 << 9; // PathStroke(), AddPolyline(): specify that shape should be closed (Important: this is always == 1 for legacy reason)
    var RoundCornersTop             = RoundCornersTopLeft | RoundCornersTopRight;
    var RoundCornersBottom          = RoundCornersBottomLeft | RoundCornersBottomRight;
    var RoundCornersLeft            = RoundCornersBottomLeft | RoundCornersTopLeft;
    var RoundCornersRight           = RoundCornersBottomRight | RoundCornersTopRight;
    var RoundCornersAll             = RoundCornersTopLeft | RoundCornersTopRight | RoundCornersBottomLeft | RoundCornersBottomRight;
    var RoundCornersDefault_        = RoundCornersAll; // Default to ALL corners if none of the _RoundCornersXX flags are specified.
    var RoundCornersMask_           = RoundCornersAll | RoundCornersNone;
    var InvalidMask_                = 0x8000000F;
}

enum abstract ImDrawListFlags(Int) from Int to Int
{
    var None                    = 0;
    var AntiAliasedLines        = 1 << 0;  // Enable anti-aliased lines/borders (*2 the number of triangles for 1.0f wide line or lines thin enough to be drawn using textures, otherwise *3 the number of triangles)
    var AntiAliasedLinesUseTex  = 1 << 1;  // Enable anti-aliased lines/borders using textures when possible. Require backend to render with bilinear filtering (NOT point/nearest filtering).
    var AntiAliasedFill         = 1 << 2;  // Enable anti-aliased edge around filled shapes (rounded rectangles, circles).
    var AllowVtxOffset          = 1 << 3;  // Can emit 'VtxOffset > 0' to allow large meshes. Set when 'ImGuiBackendFlags_RendererHasVtxOffset' is enabled.
}

enum abstract ImFontFlags(Int) from Int to Int
{
    var None                    = 0;
    var NoLoadError             = 1 << 1;   // Disable throwing an error/assert when calling AddFontXXX() with missing file/data. Calling code is expected to check AddFontXXX() return value.
    var NoLoadGlyphs            = 1 << 2;   // [Internal] Disable loading new glyphs.
    var LockBakedSizes          = 1 << 3;   // [Internal] Disable loading new baked sizes, disable garbage collecting current ones. e.g. if you want to lock a font to a single size. Important: if you use this to preload given sizes, consider the possibility of multiple font density used on Retina display.
    var ImplicitRefSize         = 1 << 4;   // [Internal] Reference size was not set explicitly.
}

enum abstract ImFontAtlasFlags(Int) from Int to Int
{
    var None               = 0;
    var NoPowerOfTwoHeight = 1 << 0;   // Don't round the height to next power of two
    var NoMouseCursors     = 1 << 1;   // Don't build software mouse cursors into the atlas (save a little texture memory)
    var NoBakedLines       = 1 << 2;   // Don't build thick line textures into the atlas (save a little texture memory, allow support for point/nearest filtering). The AntiAliasedLinesUseTex features uses them, otherwise they will be rendered using polygons (more expensive for CPU/GPU).
}

enum abstract ImGuiMultiSelectFlags(Int) from Int to Int
{
    var None                  = 0;
    var SingleSelect          = 1 << 0;   // Disable selecting more than one item. This is available to allow single-selection code to share same code/logic if desired. It essentially disables the main purpose of BeginMultiSelect() tho!
    var NoSelectAll           = 1 << 1;   // Disable Ctrl+A shortcut to select all.
    var NoRangeSelect         = 1 << 2;   // Disable Shift+selection mouse/keyboard support (useful for unordered 2D selection). With BoxSelect is also ensure contiguous SetRange requests are not combined into one. This allows not handling interpolation in SetRange requests.
    var NoAutoSelect          = 1 << 3;   // Disable selecting items when navigating (useful for e.g. supporting range-select in a list of checkboxes).
    var NoAutoClear           = 1 << 4;   // Disable clearing selection when navigating or selecting another one (generally used with ImGuiMultiSelectFlags_NoAutoSelect. useful for e.g. supporting range-select in a list of checkboxes).
    var NoAutoClearOnReselect = 1 << 5;   // Disable clearing selection when clicking/selecting an already selected item.
    var BoxSelect1d           = 1 << 6;   // Enable box-selection with same width and same x pos items (e.g. full row Selectable()). Box-selection works better with little bit of spacing between items hit-box in order to be able to aim at empty space.
    var BoxSelect2d           = 1 << 7;   // Enable box-selection with varying width or varying x pos items support (e.g. different width labels, or 2D layout/grid). This is slower: alters clipping logic so that e.g. horizontal movements will update selection of normally clipped items.
    var BoxSelectNoScroll     = 1 << 8;   // Disable scrolling when box-selecting and moving mouse near edges of scope.
    var ClearOnEscape         = 1 << 9;   // Clear selection when pressing Escape while scope is focused.
    var ClearOnClickVoid      = 1 << 10;  // Clear selection when clicking on empty location within scope.
    var ScopeWindow           = 1 << 11;  // Scope for _BoxSelect and _ClearOnClickVoid is whole window (Default). Use if BeginMultiSelect() covers a whole window or used a single time in same window.
    var ScopeRect             = 1 << 12;  // Scope for _BoxSelect and _ClearOnClickVoid is rectangle encompassing BeginMultiSelect()/EndMultiSelect(). Use if BeginMultiSelect() is called multiple times in same window.
    var SelectOnAuto          = 1 << 13;  // Apply selection on mouse down when clicking on unselected item, on mouse up when clicking on selected item. (Default)
    var SelectOnClickAlways   = 1 << 14;  // Apply selection on mouse down when clicking on any items. Prevents Drag and Drop from being used on multiple-selection, but allows e.g. BoxSelect to always reselect even when clicking inside an existing selection. (Excel style behavior)
    var SelectOnClickRelease  = 1 << 15;  // Apply selection on mouse release when clicking an unselected item. Allow dragging an unselected item without altering selection.
    //ImGuiMultiSelectFlags_RangeSelect2d       = 1 << 15,  // Shift+Selection uses 2d geometry instead of linear sequence, so possible to use Shift+up/down to select vertically in grid. Analogous to what BoxSelect does.
    var NavWrapX              = 1 << 16;  // [Temporary] Enable navigation wrapping on X axis. Provided as a convenience because we don't have a design for the general Nav API for this yet. When the more general feature be public we may obsolete this flag in favor of new one.
    var NoSelectOnRightClick  = 1 << 17;  // Disable default right-click processing, which selects item on mouse down, and is designed for context-menus.
    var SelectOnMask_         = SelectOnAuto | SelectOnClickAlways | SelectOnClickRelease;
}

enum abstract ImGuiViewportFlags(Int) from Int to Int
{
    var None                     = 0;
    var IsPlatformWindow         = 1 << 0;   // Represent a Platform Window
    var IsPlatformMonitor        = 1 << 1;   // Represent a Platform Monitor (unused yet)
    var OwnedByApp               = 1 << 2;   // Platform Window: Is created/managed by the user application? (rather than our backend)
    var NoDecoration             = 1 << 3;   // Platform Window: Disable platform decorations: title bar, borders, etc. (generally set all windows, but if ImGuiConfigFlags_ViewportsDecoration is set we only set this on popups/tooltips)
    var NoTaskBarIcon            = 1 << 4;   // Platform Window: Disable platform task bar icon (generally set on popups/tooltips, or all windows if ImGuiConfigFlags_ViewportsNoTaskBarIcon is set)
    var NoFocusOnAppearing       = 1 << 5;   // Platform Window: Don't take focus when created.
    var NoFocusOnClick           = 1 << 6;   // Platform Window: Don't take focus when clicked on.
    var NoInputs                 = 1 << 7;   // Platform Window: Make mouse pass through so we can drag this window while peaking behind it.
    var NoRendererClear          = 1 << 8;   // Platform Window: Renderer doesn't need to clear the framebuffer ahead (because we will fill it entirely).
    var NoAutoMerge              = 1 << 9;   // Platform Window: Avoid merging this window into another host window. This can only be set via ImGuiWindowClass viewport flags override (because we need to now ahead if we are going to create a viewport in the first place!).
    var TopMost                  = 1 << 10;  // Platform Window: Display on top (for tooltips only).
    var CanHostOtherWindows      = 1 << 11;  // Viewport can host multiple imgui windows (secondary viewports are associated to a single window). // FIXME: In practice there's still probably code making the assumption that this is always and only on the MainViewport. Will fix once we add support for "no main viewport".

    // Output status flags (from Platform)
    var IsMinimized              = 1 << 12;  // Platform Window: Window is minimized, can skip render. When minimized we tend to avoid using the viewport pos/size for clipping window or testing if they are contained in the viewport.
    var IsFocused                = 1 << 13;  // Platform Window: Window is focused (last call to Platform_GetWindowFocus() returned true)
}