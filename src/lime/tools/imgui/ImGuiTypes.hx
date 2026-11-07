package lime.tools.imgui;

typedef ImVec2 = lime.math.Vector2;
typedef ImVec4 = lime.math.Vector4;
typedef ImColor = lime.math.ARGB;

typedef ImGuiKeyChord = Int;

#if (cpp && !cppia)
typedef ImGuiID = cpp.UInt32;
typedef ImS8 = cpp.Int8;
typedef ImU8 = cpp.UInt8;
typedef ImS16 = cpp.Int16;
typedef ImU16 = cpp.UInt16;
typedef ImS32 = Int;
typedef ImU32 = cpp.UInt32;
typedef ImS64 = cpp.Int64;
typedef ImU64 = cpp.UInt64;
#else
//TODO figure out if this actually works, not sure if we even need non cpp versions
typedef ImGuiID = UInt;
typedef ImS8 = Int;
typedef ImU8 = UInt;
typedef ImS16 = Int;
typedef ImU16 = UInt;
typedef ImS32 = Int;
typedef ImU32 = UInt;
typedef ImS64 = haxe.Int64;
typedef ImU64 = haxe.Int64;
#end

abstract ImTextureID(Int) from Int to Int   //should really be an int64 but we only need 32 bit because were only using opengl where the id matches to gl texture id
{
    public inline function new(id:Int) 
    {
        this = id;
    }

    #if openfl
    public static function fromBitmapData(bitmapData:openfl.display.BitmapData)
    {
        @:privateAccess
        return new ImTextureID(bitmapData != null && bitmapData.__texture != null ? bitmapData.__texture.__getTexture().id : 0);
    }
    #end
}

// A primary data type
enum ImGuiDataType
{
    S8;       // signed char / char (with sensible compilers)
    U8;       // unsigned char
    S16;      // short
    U16;      // unsigned short
    S32;      // int
    U32;      // unsigned int
    S64;      // long long / __int64
    U64;      // unsigned long long / unsigned __int64
    Float;    // float
    Double;   // double
    Bool;     // bool (provided for user convenience, not supported by scalar widgets)
    String;   // char* (provided for user convenience, not supported by scalar widgets)
    COUNT;
}

// A cardinal direction
enum abstract ImGuiDir(Int) from Int to Int
{
    var None    = -1;
    var Left    = 0;
    var Right   = 1;
    var Up      = 2;
    var Down    = 3;
    var COUNT = 4;
}

// A sorting direction
enum abstract ImGuiSortDirection(ImU8) from ImU8 to ImU8
{
    var None         = 0;
    var Ascending    = 1;    // Ascending = 0->9, A->Z etc.
    var Descending   = 2;    // Descending = 9->0, Z->A etc.
}

// A key identifier (ImGuiKey_XXX or ImGuiMod_XXX value): can represent Keyboard, Mouse and Gamepad values.
// All our named keys are >= 512. Keys value 0 to 511 are left unused and were legacy native/opaque key values (< 1.87).
// Support for legacy keys was completely removed in 1.91.5.
// Read details about the 1.87+ transition : https://github.com/ocornut/imgui/issues/4921
// Note that "Keys" related to physical keys and are not the same concept as input "Characters", the latter are submitted via io.AddInputCharacter().
// The keyboard key enum values are named after the keys on a standard US keyboard, and on other keyboard types the keys reported may not match the keycaps.
enum abstract ImGuiKey(Int) from Int to Int
{
    // Keyboard
    var None = 0;
    var NamedKey_BEGIN = 512;  // First valid key value (other than 0)

    var Tab = 512;             // == ImGuiKey_NamedKey_BEGIN
    var LeftArrow;
    var RightArrow;
    var UpArrow;
    var DownArrow;
    var PageUp;
    var PageDown;
    var Home;
    var End;
    var Insert;
    var Delete;
    var Backspace;
    var Space;
    var Enter;
    var Escape;
    var LeftCtrl; var LeftShift; var LeftAlt; var LeftSuper;     // Also see ImGuiMod_Ctrl, ImGuiMod_Shift, ImGuiMod_Alt, ImGuiMod_Super below!
    var RightCtrl; var RightShift; var RightAlt; var RightSuper;
    var Menu;
    var _0; var _1; var _2; var _3; var _4; var _5; var _6; var _7; var _8; var _9;
    var A; var B; var C; var D; var E; var F; var G; var H; var I; var J;
    var K; var L; var M; var N; var O; var P; var Q; var R; var S; var T;
    var U; var V; var W; var X; var Y; var Z;
    var F1; var F2; var F3; var F4; var F5; var F6;
    var F7; var F8; var F9; var F10; var F11; var F12;
    var F13; var F14; var F15; var F16; var F17; var F18;
    var F19; var F20; var F21; var F22; var F23; var F24;
    var Apostrophe;        // '
    var Comma;             // ,
    var Minus;             // -
    var Period;            // .
    var Slash;             // /
    var Semicolon;         // ;
    var Equal;             // =
    var LeftBracket;       // [
    var Backslash;         // \ (this text inhibit multiline comment caused by backslash)
    var RightBracket;      // ]
    var GraveAccent;       // `
    var CapsLock;
    var ScrollLock;
    var NumLock;
    var PrintScreen;
    var Pause;
    var Keypad0; var Keypad1; var Keypad2; var Keypad3; var Keypad4;
    var Keypad5; var Keypad6; var Keypad7; var Keypad8; var Keypad9;
    var KeypadDecimal;
    var KeypadDivide;
    var KeypadMultiply;
    var KeypadSubtract;
    var KeypadAdd;
    var KeypadEnter;
    var KeypadEqual;
    var AppBack;               // Available on some keyboard/mouses. Often referred as "Browser Back"
    var AppForward;
    var Oem102;                // Non-US backslash.

    // Gamepad
    // (analog values are 0.0f to 1.0f)
    // (download controller mapping PNG/PSD at http://dearimgui.com/controls_sheets)
    //                              // XBOX        | SWITCH  | PLAYSTA. | -> ACTION
    var GamepadStart;          // Menu        | +       | Options  |
    var GamepadBack;           // View        | -       | Share    |
    var GamepadFaceLeft;       // X           | Y       | Square   | Toggle Menu. Hold for Windowing mode (Focus/Move/Resize windows)
    var GamepadFaceRight;      // B           | A       | Circle   | Cancel / Close / Exit
    var GamepadFaceUp;         // Y           | X       | Triangle | Open Context Menu
    var GamepadFaceDown;       // A           | B       | Cross    | Activate / Open / Toggle. Hold for 0.60f to Activate in Text Input mode (e.g. wired to an on-screen keyboard).
    var GamepadDpadLeft;       // D-pad Left  | "       | "        | Move / Tweak / Resize Window (in Windowing mode)
    var GamepadDpadRight;      // D-pad Right | "       | "        | Move / Tweak / Resize Window (in Windowing mode)
    var GamepadDpadUp;         // D-pad Up    | "       | "        | Move / Tweak / Resize Window (in Windowing mode)
    var GamepadDpadDown;       // D-pad Down  | "       | "        | Move / Tweak / Resize Window (in Windowing mode)
    var GamepadL1;             // L Bumper    | L       | L1       | Tweak Slower / Focus Previous (in Windowing mode)
    var GamepadR1;             // R Bumper    | R       | R1       | Tweak Faster / Focus Next (in Windowing mode)
    var GamepadL2;             // L Trigger   | ZL      | L2       | [Analog]
    var GamepadR2;             // R Trigger   | ZR      | R2       | [Analog]
    var GamepadL3;             // L Stick     | L3      | L3       |
    var GamepadR3;             // R Stick     | R3      | R3       |
    var GamepadLStickLeft;     //             |         |          | [Analog] Move Window (in Windowing mode)
    var GamepadLStickRight;    //             |         |          | [Analog] Move Window (in Windowing mode)
    var GamepadLStickUp;       //             |         |          | [Analog] Move Window (in Windowing mode)
    var GamepadLStickDown;     //             |         |          | [Analog] Move Window (in Windowing mode)
    var GamepadRStickLeft;     //             |         |          | [Analog]
    var GamepadRStickRight;    //             |         |          | [Analog]
    var GamepadRStickUp;       //             |         |          | [Analog]
    var GamepadRStickDown;     //             |         |          | [Analog]

    // Aliases: Mouse Buttons (auto-submitted from AddMouseButtonEvent() calls)
    // - This is mirroring the data also written to io.MouseDown[], io.MouseWheel, in a format allowing them to be accessed via standard key API.
    var MouseLeft; var MouseRight; var MouseMiddle; var MouseX1; var MouseX2; var MouseWheelX; var MouseWheelY;

    // [Internal] Reserved for mod storage
    var ReservedForModCtrl; var ReservedForModShift; var ReservedForModAlt; var ReservedForModSuper;

    // [Internal] If you need to iterate all keys (for e.g. an input mapper) you may use ImGuiKey_NamedKey_BEGIN..ImGuiKey_NamedKey_END.
    var NamedKey_END;
    var NamedKey_COUNT = NamedKey_END - NamedKey_BEGIN;

    // Keyboard Modifiers (explicitly submitted by backend via AddKeyEvent() calls)
    // - Any functions taking a ImGuiKeyChord parameter can binary-or those with regular keys, e.g. Shortcut(ImGuiMod_Ctrl | ImGuiKey_S).
    // - Those are written back into io.KeyCtrl, io.KeyShift, io.KeyAlt, io.KeySuper for convenience,
    //   but may be accessed via standard key API such as IsKeyPressed(), IsKeyReleased(), querying duration etc.
    // - Code polling every key (e.g. an interface to detect a key press for input mapping) might want to ignore those
    //   and prefer using the real keys (e.g. ImGuiKey_LeftCtrl, ImGuiKey_RightCtrl instead of ImGuiMod_Ctrl).
    // - In theory the value of keyboard modifiers should be roughly equivalent to a logical or of the equivalent left/right keys.
    //   In practice: it's complicated; mods are often provided from different sources. Keyboard layout, IME, sticky keys and
    //   backends tend to interfere and break that equivalence. The safer decision is to relay that ambiguity down to the end-user...
    // - On macOS, we swap Cmd(Super) and Ctrl keys at the time of the io.AddKeyEvent() call.
    var Mod_None                   = 0;
    var Mod_Ctrl                   = 1 << 12; // Ctrl (non-macOS), Cmd (macOS)
    var Mod_Shift                  = 1 << 13; // Shift
    var Mod_Alt                    = 1 << 14; // Option/Menu
    var Mod_Super                  = 1 << 15; // Windows/Super (non-macOS), Ctrl (macOS)
    var Mod_Mask_                  = 0xF000;  // 4-bits
}


// Enumeration for PushStyleColor() / PopStyleColor()
enum abstract ImGuiCol(Int) from Int to Int
{
    var Text = 0;
    var TextDisabled;
    var WindowBg;              // Background of normal windows
    var ChildBg;               // Background of child windows
    var PopupBg;               // Background of popups, menus, tooltips windows
    var Border;
    var BorderShadow;
    var FrameBg;               // Background of checkbox, radio button, plot, slider, text input
    var FrameBgHovered;
    var FrameBgActive;
    var TitleBg;               // Title bar
    var TitleBgActive;         // Title bar when focused
    var TitleBgCollapsed;      // Title bar when collapsed
    var MenuBarBg;
    var ScrollbarBg;
    var ScrollbarGrab;
    var ScrollbarGrabHovered;
    var ScrollbarGrabActive;
    var CheckMark;             // Checkbox tick and RadioButton circle
    var SliderGrab;
    var SliderGrabActive;
    var Button;
    var ButtonHovered;
    var ButtonActive;
    var Header;                // Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
    var HeaderHovered;
    var HeaderActive;
    var Separator;
    var SeparatorHovered;
    var SeparatorActive;
    var ResizeGrip;            // Resize grip in lower-right and lower-left corners of windows.
    var ResizeGripHovered;
    var ResizeGripActive;
    var InputTextCursor;       // InputText cursor/caret
    var TabHovered;            // Tab background, when hovered
    var Tab;                   // Tab background, when tab-bar is focused & tab is unselected
    var TabSelected;           // Tab background, when tab-bar is focused & tab is selected
    var TabSelectedOverline;   // Tab horizontal overline, when tab-bar is focused & tab is selected
    var TabDimmed;             // Tab background, when tab-bar is unfocused & tab is unselected
    var TabDimmedSelected;     // Tab background, when tab-bar is unfocused & tab is selected
    var TabDimmedSelectedOverline;//..horizontal overline, when tab-bar is unfocused & tab is selected
    var DockingPreview;        // Preview overlay color when about to docking something
    var DockingEmptyBg;        // Background color for empty node (e.g. CentralNode with no window docked into it)
    var PlotLines;
    var PlotLinesHovered;
    var PlotHistogram;
    var PlotHistogramHovered;
    var TableHeaderBg;         // Table header background
    var TableBorderStrong;     // Table outer and header borders (prefer using Alpha=1.0 here)
    var TableBorderLight;      // Table inner borders (prefer using Alpha=1.0 here)
    var TableRowBg;            // Table row background (even rows)
    var TableRowBgAlt;         // Table row background (odd rows)
    var TextLink;              // Hyperlink color
    var TextSelectedBg;        // Selected text inside an InputText
    var TreeLines;             // Tree node hierarchy outlines when using ImGuiTreeNodeFlags_DrawLines
    var DragDropTarget;        // Rectangle border highlighting a drop target
    var DragDropTargetBg;      // Rectangle background highlighting a drop target
    var UnsavedMarker;         // Unsaved Document marker (in window title and tabs)
    var NavCursor;             // Color of keyboard/gamepad navigation cursor/rectangle, when visible
    var NavWindowingHighlight; // Highlight window when using Ctrl+Tab
    var NavWindowingDimBg;     // Darken/colorize entire screen behind the Ctrl+Tab window list, when active
    var ModalWindowDimBg;      // Darken/colorize entire screen behind a modal window, when one is active
    var COUNT;
}

// Enumeration for PushStyleVar() / PopStyleVar() to temporarily modify the ImGuiStyle structure.
// - The enum only refers to fields of ImGuiStyle which makes sense to be pushed/popped inside UI code.
//   During initialization or between frames, feel free to just poke into ImGuiStyle directly.
// - Tip: Use your programming IDE navigation facilities on the names in the _second column_ below to find the actual members and their description.
//   - In Visual Studio: Ctrl+Comma ("Edit.GoToAll") can follow symbols inside comments, whereas Ctrl+F12 ("Edit.GoToImplementation") cannot.
//   - In Visual Studio w/ Visual Assist installed: Alt+G ("VAssistX.GoToImplementation") can also follow symbols inside comments.
//   - In VS Code, CLion, etc.: Ctrl+Click can follow symbols inside comments.
// - When changing this enum, you need to update the associated internal table GStyleVarInfo[] accordingly. This is where we link enum values to members offset/type.
enum abstract ImGuiStyleVar(Int) from Int to Int
{
    // Enum name -------------------------- // Member in ImGuiStyle structure (see ImGuiStyle for descriptions)
    var Alpha = 0;                    // float     Alpha
    var DisabledAlpha;            // float     DisabledAlpha
    var WindowPadding;            // ImVec2    WindowPadding
    var WindowRounding;           // float     WindowRounding
    var WindowBorderSize;         // float     WindowBorderSize
    var WindowMinSize;            // ImVec2    WindowMinSize
    var WindowTitleAlign;         // ImVec2    WindowTitleAlign
    var ChildRounding;            // float     ChildRounding
    var ChildBorderSize;          // float     ChildBorderSize
    var PopupRounding;            // float     PopupRounding
    var PopupBorderSize;          // float     PopupBorderSize
    var FramePadding;             // ImVec2    FramePadding
    var FrameRounding;            // float     FrameRounding
    var FrameBorderSize;          // float     FrameBorderSize
    var ItemSpacing;              // ImVec2    ItemSpacing
    var ItemInnerSpacing;         // ImVec2    ItemInnerSpacing
    var IndentSpacing;            // float     IndentSpacing
    var CellPadding;              // ImVec2    CellPadding
    var ScrollbarSize;            // float     ScrollbarSize
    var ScrollbarRounding;        // float     ScrollbarRounding
    var ScrollbarPadding;         // float     ScrollbarPadding
    var GrabMinSize;              // float     GrabMinSize
    var GrabRounding;             // float     GrabRounding
    var ImageRounding;            // float     ImageRounding
    var ImageBorderSize;          // float     ImageBorderSize
    var TabRounding;              // float     TabRounding
    var TabBorderSize;            // float     TabBorderSize
    var TabMinWidthBase;          // float     TabMinWidthBase
    var TabMinWidthShrink;        // float     TabMinWidthShrink
    var TabBarBorderSize;         // float     TabBarBorderSize
    var TabBarOverlineSize;       // float     TabBarOverlineSize
    var TableAngledHeadersAngle;  // float     TableAngledHeadersAngle
    var TableAngledHeadersTextAlign;// ImVec2  TableAngledHeadersTextAlign
    var TreeLinesSize;            // float     TreeLinesSize
    var TreeLinesRounding;        // float     TreeLinesRounding
    var DragDropTargetRounding;   // float     DragDropTargetRounding
    var ButtonTextAlign;          // ImVec2    ButtonTextAlign
    var SelectableTextAlign;      // ImVec2    SelectableTextAlign
    var SeparatorSize;            // float     SeparatorSize
    var SeparatorTextBorderSize;  // float     SeparatorTextBorderSize
    var SeparatorTextAlign;       // ImVec2    SeparatorTextAlign
    var SeparatorTextPadding;     // ImVec2    SeparatorTextPadding
    var DockingSeparatorSize;     // float     DockingSeparatorSize
    var COUNT;
}

// Identify a mouse button.
// Those values are guaranteed to be stable and we frequently use 0/1 directly. Named enums provided for convenience.
enum abstract ImGuiMouseButton(Int) from Int to Int
{
    var Left = 0;
    var Right = 1;
    var Middle = 2;
    var COUNT = 5;
}

// Enumeration for GetMouseCursor()
// User code may request backend to display given cursor by calling SetMouseCursor(), which is why we have some cursors that are marked unused here
enum abstract ImGuiMouseCursor(Int) from Int to Int
{
    var None = -1;
    var Arrow = 0;
    var TextInput;         // When hovering over InputText, etc.
    var ResizeAll;         // (Unused by Dear ImGui functions)
    var ResizeNS;          // When hovering over a horizontal border
    var ResizeEW;          // When hovering over a vertical border or a column
    var ResizeNESW;        // When hovering over the bottom-left corner of a window
    var ResizeNWSE;        // When hovering over the bottom-right corner of a window
    var Hand;              // (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
    var Wait;              // When waiting for something to process/load.
    var Progress;          // When waiting for something to process/load, but application is still interactive.
    var NotAllowed;        // When hovering something with disallowed interaction. Usually a crossed circle.
    var COUNT;
}

// Enumeration for AddMouseSourceEvent() actual source of Mouse Input data.
// Historically we use "Mouse" terminology everywhere to indicate pointer data, e.g. MousePos, IsMousePressed(), io.AddMousePosEvent()
// But that "Mouse" data can come from different source which occasionally may be useful for application to know about.
// You can submit a change of pointer type using io.AddMouseSourceEvent().
enum abstract ImGuiMouseSource(Int) from Int to Int
{
    var Mouse = 0;         // Input is coming from an actual mouse.
    var TouchScreen;       // Input is coming from a touch screen (no hovering prior to initial press, less precise initial press aiming, dual-axis wheeling possible).
    var Pen;               // Input is coming from a pressure/magnetic pen (often used in conjunction with high-sampling rates).
    var COUNT;
}

// Enumeration for ImGui::SetNextWindow***(), SetWindow***(), SetNextItem***() functions
// Represent a condition.
// Important: Treat as a regular enum! Do NOT combine multiple values using binary operators! All the functions above treat 0 as a shortcut to ImGuiCond_Always.
enum abstract ImGuiCond(Int) from Int to Int
{
    var None          = 0;        // No condition (always set the variable), same as _Always
    var Always        = 1 << 0;   // No condition (always set the variable), same as _None
    var Once          = 1 << 1;   // Set the variable once per runtime session (only the first call will succeed)
    var FirstUseEver  = 1 << 2;   // Set the variable if the object/window has no persistently saved data (no entry in .ini file)
    var Appearing     = 1 << 3;   // Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
}

// Enum for ImGui::TableSetBgColor()
// Background colors are rendering in 3 layers:
//  - Layer 0: draw with RowBg0 color if set, otherwise draw with ColumnBg0 if set.
//  - Layer 1: draw with RowBg1 color if set, otherwise draw with ColumnBg1 if set.
//  - Layer 2: draw with CellBg color if set.
// The purpose of the two row/columns layers is to let you decide if a background color change should override or blend with the existing color.
// When using ImGuiTableFlags_RowBg on the table, each row has the RowBg0 color automatically set for odd/even rows.
// If you set the color of RowBg0 target, your color will override the existing RowBg0 color.
// If you set the color of RowBg1 or ColumnBg1 target, your color will blend over the RowBg0 color.
enum abstract ImGuiTableBgTarget(Int) from Int to Int
{
    var None                     = 0;
    var RowBg0                   = 1;        // Set row background color 0 (generally used for background, automatically set when ImGuiTableFlags_RowBg is used)
    var RowBg1                   = 2;        // Set row background color 1 (generally used for selection marking)
    var CellBg                   = 3;        // Set cell background color (top-most color)
}