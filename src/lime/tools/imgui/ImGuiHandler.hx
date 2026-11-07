package lime.tools.imgui;

//probably not needed if not using openfl
class ImGuiHandler #if openfl extends openfl.display.DisplayObject #end
{
	public static var instance(get, null):ImGuiHandler;
	static function get_instance() {
		if (instance == null) instance = new ImGuiHandler();
		return instance;
	}
	
	private var callbacks:Array<Void->Void> = [];

	public function new() 
	{
		super();
	}

	public function addCallback(func:Void->Void) 
	{
		if (!callbacks.contains(func))
		{
			callbacks.push(func);
		}
	}

	public function removeCallback(func:Void->Void) 
	{
		callbacks.remove(func);
	}

	public function clearCallbacks()
	{
		callbacks.splice(0, callbacks.length);
	}

    private function exec()
    {
        for (func in callbacks)
		{
			func();
		}
    }
    
    #if openfl
	public override function __enterFrame(deltaTime:Float) 
	{
		super.__enterFrame(deltaTime);
        exec();
	}
    #end
}