
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.FlxG;

var road:FlxBackdrop;
var oldRoad:FlxSprite;

function create(){
    oldRoad = stage.stageSprites["road"];
    oldRoad.alpha = 0;

    road = new FlxBackdrop(Paths.image("stages/kilometer/road"), 0x01, 0, 0);
    road.y = stage.stageSprites["road"].y;
    road.scale.set(1, 2);
    road.updateHitbox();
    road.velocity.set(-10000);
    insert(members.indexOf(oldRoad), road);

}

function postCreate(){
    for(e in [hellcat3, hellcat4, hellcat5, hellcat6])
        FlxTween.tween(e, {x: e.x + FlxG.random.float(25, 75)}, FlxG.random.float(0.75, 2.75), {ease: FlxEase.linear, startDelay: FlxG.random.float(0.5, 2), type: FlxTween.PINGPONG});
}

function update(elapsed:Float){
    for(e in [hellcat1, hellcat2])
        e.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2);

}
