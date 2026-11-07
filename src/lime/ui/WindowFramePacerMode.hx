package lime.ui;

/**
	How the frame pacer aligns presents with the display refresh (Codename Engine API).

	The native pacer (Windows, from Codename Engine's lime) aligns frames with the
	compositor; on other platforms every mode leaves timing to the frame rate cap.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract WindowFramePacerMode(Int) from Int to Int from UInt to UInt
{
	/**
		Behaves the same as `ADAPTIVE`. This is the default.
	**/
	public var AUTO = -1;

	/**
		Disable the frame pacer. The frame rate cap alone controls the frame time.
	**/
	public var OFF = 0;

	/**
		Pace only when the frame rate cap is a whole multiple of the refresh rate.
	**/
	public var ADAPTIVE = 1;

	/**
		Lock to the display refresh rate, regardless of the frame rate cap.
	**/
	public var LOCKED = 2;
}
