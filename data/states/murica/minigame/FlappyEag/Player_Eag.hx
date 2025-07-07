/*class SpecialSprite extends FlxSprite
{
    public var customValue:String = null;
    public function new(?x:Float = 0, ?y:Float = 0, ?graphic:FlxGraphicAsset, customValue:String) { // it also has to start with the same arguments as the super class, (limitation for now)
        super(x, y, graphic); // this does nothing currently, its purely visual for now, but it will be used in the future
        this.customValue = customValue;
        //other code stuff
    }

    public override function update(elapsed) {
        super.update(elapsed);
    }
}

function create()
{
    var spr = new SpecialSprite(200, 400, null, "powerful");
    add(spr);
}

function die()
{
    FlxG.sound.play(Paths.sound("explosion_sfx"), 0.75);
}*/