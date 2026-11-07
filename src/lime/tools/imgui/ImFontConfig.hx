package lime.tools.imgui;

class ImFontConfig
{
    //TODO: fix this
    public function new() {}
    public var mergeMode:Bool = false;
    public var pixelSnapH:Bool = false;
    public var oversampleH:Int = 0;
    public var oversampleV:Int = 0;
    public var ellipsisChar:Int = 0;
    public var sizePixels:Float = 0;
    public var glyphRanges:Array<Int> = [];
    public var glyphExcludeRanges:Array<Int> = [];
    public var glyphOffsetX:Float = 0;
    public var glyphOffsetY:Float = 0;
    public var glyphMinAdvanceX:Float = 0;
    public var glyphMaxAdvanceX:Float = 3.402823466e+38;
    public var glyphExtraAdvanceX:Float = 0;
    public var fontNo:Int = 0;
    public var fontLoaderFlags:Int = 0;
    public var rasterizerMultiply:Float = 1.0;
    public var rasterizerDensity:Float = 1.0;
    public var extraSizeScale:Float = 1.0;
}