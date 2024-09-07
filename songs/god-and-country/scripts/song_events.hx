import funkin.game.PlayState;

var georgeComedy:FunkinSprite;
var trumpComedy:FunkinSprite;
var georgekill:FunkinSprite;
var trumpExplosion:FunkinSprite;
var dadYValues:Array<Float> = [];

importScript("data/scripts/HandyDandyFunctions");

function create()
{
	georgeComedy = new FunkinSprite(-575, 175);
	georgeComedy.frames = Paths.getFrames('mid song anims/georgeinterruption');
	georgeComedy.animation.addByPrefix('interrupted', 'george interrupted anim', 24, false);
	add(georgeComedy);
	georgeComedy.alpha = 0.001;

	trumpComedy = new FunkinSprite(0, 195);
	trumpComedy.frames = Paths.getFrames('mid song anims/trumpinterruption');
	trumpComedy.animation.addByPrefix('interrupted', 'trump cuts anim', 24, false);
	add(trumpComedy);
	trumpComedy.alpha = 0.001;

	georgekill = new FunkinSprite(-175, 150);
	georgekill.frames = Paths.getFrames('mid song anims/georgekillanim');
	georgekill.animation.addByPrefix('kill', 'george kills trump', 24, false);
	add(georgekill);
	georgekill.alpha = 0.001;

	trumpExplosion = new FunkinSprite(-175, -888);
	trumpExplosion.frames = Paths.getFrames('mid song anims/explosivo');
	trumpExplosion.animation.addByPrefix('explode', 'explosivo', 24, false);
	trumpExplosion.scale.set(5.65, 5.65);
	trumpExplosion.updateHitbox();
	add(trumpExplosion);
	trumpExplosion.alpha = 0.001;

}

function stepHit(curStep:Int)
{
	switch (curStep)
	{
		case 770:
			dad.alpha = 0.001;
			trumpComedy.animation.play('interrupted');
			georgeComedy.animation.play('interrupted');
			georgeComedy.alpha = 1;
			trumpComedy.alpha = 1;
		case 880:
			dad.alpha = 1;
			remove(trumpComedy);
		case 892:
			stage.stageSprites["georgebg"].visible = true;
			remove(georgeComedy);
		case 1402:
			stage.stageSprites["georgebg"].visible = false;
			georgekill.alpha = 1;
			georgekill.animation.play('kill');
			dadYValues = [dad.x, dad.y];
			FlxTween.tween(dad, {y: dad.y - 575}, 0.95, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween)
				{
					dad.alpha = 0.001;
					trumpExplosion.alpha = 1;
					trumpExplosion.animation.play("explode");
					dad.setPosition(dadYValues[0], dadYValues[1]);
				}
			});
		case 1440:
			dad.alpha = 1;
			remove(georgekill);
			remove(trumpExplosion);
			stage.stageSprites["bg"].alpha = 0.001;
			gf.alpha = 0.001;
		case 1568:
			stage.stageSprites["bg"].alpha = 1;
			gf.alpha = 1;
	}
}