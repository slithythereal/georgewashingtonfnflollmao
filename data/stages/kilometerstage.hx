
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.FlxG;

var road:FlxBackdrop;
var oldRoad:FlxSprite;

function create(){
    oldRoad = stage.stageSprites["road"]; //takes old road and kills it
    oldRoad.alpha = 0;

    road = new FlxBackdrop(Paths.image("stages/kilometer/road"), 0x01, 0, 0); //replaces road pic with flxbackdrop
    road.y = stage.stageSprites["road"].y;
    road.scale.set(1, 2);
    road.updateHitbox();
    road.velocity.set(-10000);
    insert(members.indexOf(oldRoad), road);
}

function postCreate(){
    //tweens hellcats based on random floats
    for(e in [hellcat3, hellcat4, hellcat5, hellcat6])
        FlxTween.tween(e, {x: e.x + (FlxG.random.float(25, 75) * FlxG.random.int(-1, 1, [0]))}, FlxG.random.float(1.5, 4.0), {ease: FlxEase.linear, startDelay: FlxG.random.float(0.5, 2), type: FlxTween.PINGPONG});
}

function update(elapsed:Float){
    for(e in [hellcat1, hellcat2])
    {
        e.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2);
    }
    dad.x = (hellcat1.x + 450) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2));
    boyfriend.x = (hellcat2.x + 500) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2));
}