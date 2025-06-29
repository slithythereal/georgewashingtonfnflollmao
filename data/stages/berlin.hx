importScript('data/scripts/HandyDandyFunctions');
import flixel.addons.display.FlxBackdrop;

var wall:FlxBackdrop;
var oldWall:FlxSprite;
var sky:FlxBackdrop;
var oldSky:FlxSprite;

function create()
{
	oldWall = stage.stageSprites['wall'];
	oldWall.alpha = 0;

	oldSky = stage.stageSprites['sky'];
	oldSky.alpha = 0;

	sky = new FlxBackdrop(Paths.image('stages/berlin/sky'), 0x01, 0, 0);
	sky.scale.set(1.5, 1.5);
	sky.updateHitbox();
	sky.velocity.x = -400;
	sky.y = -200;
	insert(members.indexOf(oldSky), sky);

	wall = new FlxBackdrop(Paths.image('stages/berlin/wallpart'), 0x01, 0, 0);
	wall.y = 200;
	wall.scale.set(1.5, 1.75);
	wall.velocity.x = -800;
	wall.updateHitbox();
	insert(members.indexOf(oldWall), wall);
}

function update(elaped:Float)
{
	motorcade.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85 / 2);
	skateboard.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85 / 2);
	dad.x = (motorcade.x + 400) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85 / 2));
	boyfriend.x = (skateboard.x - 50) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85 / 2));
}




public function changeSpeed(?mult:Float = 1){
    wall.velocity.x = -800 * mult;
    sky.velocity.x = -400 * mult;
}