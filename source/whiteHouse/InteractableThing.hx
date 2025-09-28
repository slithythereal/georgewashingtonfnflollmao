package whiteHouse; // Allow `package` declaration. Ignored by the interpreter.

import funkin.backend.FunkinSprite;

enum HoverType {
    NONE;
    SCALE;
    ALPHA;
}

class InteractableThing extends FunkinSprite
{
    public final path = "minigames/whitehouse/";

    public var room:String = null;

    public var select:Void->Void = null;

    public var isSelectable:Bool = true;

    public var customID:String = "";

    public var data(default, set):Dynamic;
    private function set_data(data:Dynamic)
    {
        if (data == null) return;
        if (data.angle != null) angle = data.angle;
        if (data.id != null) customID = data.id;
        if (data.isSelectable != null) isSelectable = data.isSelectable;
        return this.data = data;
    }
        
    public function new(x:Float, y:Float, data) {
        super(x, y, null);
        this.data = data;
    }

    public override function update(elapsed) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this)) hover()
		else unHover();

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed && isSelectable && select != null) select();
    }

    public var hoverType = HoverType.SCALE;

    private function hover()
    {
        if (hoverType == HoverType.SCALE)
            scale.set(FlxMath.lerp(scale.x, 1.4, 0.3), FlxMath.lerp(scale.y, 1.4, 0.3));
        if (hoverType == HoverType.ALPHA)
            alpha = FlxMath.lerp(alpha, 1.0, 0.3);
    }

    private function unHover()
    {
        if (hoverType == HoverType.SCALE)
            scale.set(FlxMath.lerp(scale.x, 1.0, 0.1), FlxMath.lerp(scale.y, 1.0, 0.1));
        if (hoverType == HoverType.ALPHA)
            alpha = FlxMath.lerp(alpha, 0.0, 0.1);
    }

    public function setAnims(anim)
    {
        var name = anim.name;
        var prefix = anim.prefix;
        var fps = anim.fps==null ? 24 : anim.fps;
        var looped = anim.looped==null ? false : anim.looped;
        var forced = anim.forced==null ? false : anim.forced;
        var indices = anim.indices==null ? null : anim.indices;
        var offset = anim.offset==null ? [0, 0] : anim.offset;

        addAnim(name, prefix, fps, forced, false, indices, offset[0], offset[1]);
    }
}