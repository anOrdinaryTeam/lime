package lime.tools.imgui;

import haxe.Json;

class ImGuiPayload
{
    public var data:Dynamic = {};
    public var type:String = "";
    
    public function new (type:String, data:Dynamic) 
    {
        this.type = type;
        this.data = data;
    }

    public function serialize()
    {
        return Json.stringify(data);
    }
    public function deserialize(str:String)
    {
        data = Json.parse(str);
    }
}