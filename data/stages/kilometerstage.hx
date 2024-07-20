
import flixel.addons.display.FlxBackdrop;

var road:FlxBackdrop;
var oldRoad:FlxSprite;

function create(){
    oldRoad = stage.stageSprites["road"];
    oldRoad.alpha = 0;

    road = new FlxBackdrop(Paths.image("stages/kilometer/road"), 0x01, 0, 0);
    road.y = stage.stageSprites["road"].y;
    road.scale.y = 1.75;
    road.updateHitbox();
    road.velocity.set(-5500);
    insert(members.indexOf(oldRoad), road);

    FlxG.watch.add(stage.stageSprites["mountain"], "x");
    FlxG.watch.add(stage.stageSprites["mountain"], "y");
}

function update(elapsed:Float){
    for(e in [hellcat1, hellcat2])
        e.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2);
}