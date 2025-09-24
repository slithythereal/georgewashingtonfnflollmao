package whiteHouse; // Allow `package` declaration. Ignored by the interpreter.

var path = "minigames/whitehouse/objects/";

class Portrait extends FunkinSprite
{
    public var name(default, set):String = ArrowDirections.LEFT;
    private function set_name(v:String):String
    {
        frames = Paths.getFrames(path + v + "painting");

        animation.addByPrefix("anim", "daAnim", 24, true);
        animation.play("anim");

        return name = v;
    }

    public var select:Void->Void = null;
        
    public function new(x:Float, y:Float, name:String) {
        super(x, y, null);
        this.name = name;
        //other code stuff
    }

    public override function update(elapsed) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this)) hover()
		else unHover();

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
        {
            select();
        }
    }

    private function hover()
    {
        alpha = FlxMath.lerp(alpha, 1.0, 0.3);
    }

    private function unHover()
    {
        alpha = FlxMath.lerp(alpha, 0.0, 0.1);
    }

    private function select()
    {
        trace("You are talking to " + name);
    }
}