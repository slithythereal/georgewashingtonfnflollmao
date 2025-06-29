var isStairsON:Bool = false;
var duration:Float = 0;
var bounceVariable:Float = 75;
public function switchBG()
{
	isStairsON = true;
	stage.stageSprites["plane"].visible = false;
	stage.stageSprites['sunset'].visible = true;
	stage.stageSprites['stairs'].visible = true;
	dad.setPosition(-725, -100);
	boyfriend.setPosition(-200, 0);
	for (i in [boyfriend, dad])
	{
		i.scale.set(0.4, 0.4);
		i.color = FlxColor.BLACK;
        i.moves = true;
        i.angularVelocity = 700;
        i.velocity.set(-1.65, -1.5);
	}

	camFollow.setPosition(200, 200);
	FlxTween.tween(stage.stageSprites['sunset'], {x: 0, y: -100}, 60, {ease: FlxEase.linear});
}
function postCreate(){
    duration = Conductor.stepCrochet * 2 / 1100;
}

function beatHit(){
    if(isStairsON){
        for(i in [boyfriend, dad])
        {
            FlxTween.tween(i, {y: i.y - bounceVariable}, duration, {ease:FlxEase.cubeOut, onComplete: function(twn:FlxTween){
                FlxTween.tween(i, {y: i.y + bounceVariable}, duration, {ease:FlxEase.cubeIn});
            }});
        }
    }
}

function onCameraMove(event)
	if (isStairsON)
		event.cancel(true);
