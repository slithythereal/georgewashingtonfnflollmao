package whiteHouse; // Allow `package` declaration. Ignored by the interpreter.

enum ArrowDirections {
    LEFT;
    DOWN;
    UP;
    RIGHT;
}

class Arrow extends FunkinSprite
{
    public var roomFinal:String = null;
    public var stepSound:String = "fnaf4runsound";

    public var direction(default, set):Int = ArrowDirections.LEFT;
    private function set_direction(v:Int):Int
    {
        frames = Paths.getFrames("minigames/whitehouse/directionalarrows");

        var dirAnim = switch(v) { case ArrowDirections.LEFT | ArrowDirections.RIGHT: "left"; case ArrowDirections.DOWN: "down"; case ArrowDirections.UP: "up"; };
        animation.addByPrefix("anim", dirAnim + "arrow", 24, true);
        animation.play("anim");
        if (v == ArrowDirections.RIGHT) flipX = true;

        centerOrigin();

        return direction = v;
    }

    public var select:Void->Void = null;
        
    public function new(x:Float, y:Float, direction:ArrowDirections, roomFinal:String = null) {
        super(x, y, null);
        this.direction = direction;
        this.roomFinal = roomFinal;
        //other code stuff
    }

    public override function update(elapsed) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this)) hover()
		else unHover();

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed && select != null) select();
    }

    private function hover()
    {
        scale.set(FlxMath.lerp(scale.x, 1.4, 0.3), FlxMath.lerp(scale.y, 1.4, 0.3));
    }

    private function unHover()
    {
        scale.set(FlxMath.lerp(scale.x, 1.0, 0.1), FlxMath.lerp(scale.y, 1.0, 0.1));
    }
}