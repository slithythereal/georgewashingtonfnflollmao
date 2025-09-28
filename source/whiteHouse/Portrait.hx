package whiteHouse; // Allow `package` declaration. Ignored by the interpreter.

import whiteHouse.InteractableThing;

class Portrait extends InteractableThing
{
    public var name(default, set):String = ArrowDirections.LEFT;
    private function set_name(v:String):String
    {
        frames = Paths.getFrames(path + "objects/" + v + "painting");

        animation.addByPrefix("anim", "daAnim", 24, true);
        animation.play("anim");

        return name = v;
    }
        
    public function new(x:Float, y:Float, name:String) {
        super(x, y, null);
        this.name = name;
        //other code stuff
    }
}