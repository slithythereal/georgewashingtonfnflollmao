var noGas:FlxSprite;

importScript('data/scripts/HandyDandyFunctions');
function create()
{
	window.title = "December 25th";
	noGas = new FlxSprite(400, 200);
	noGas.loadGraphic(Paths.image('mid song anims/merrychristmas/nogas'));
	noGas.scale.set(0.5, 0.5);
	noGas.updateHitbox();
	add(noGas);
	noGas.alpha = 0.001;
	dad.color = FlxColor.BLACK;
}

var playedSound:Bool = false;
function postUpdate(elapsed:Float)
{
    if (boyfriend.getAnimName() == "fall" && boyfriend.animation.frameIndex >= 5 && !playedSound)
    {
        playedSound = true;
        FlxG.sound.play(Paths.sound("splat"), 1.0);
    }
}

function funnyEvent(event:String){ //hscript call event
	var daEvent:String = event;
	switch(daEvent){
		case 'nogas':
			sleighFalling = true;
			for (i in [boyfriend, stage.stageSprites['sleigh']])
				i.acceleration.y = 1200 * 1.5;
			noGas.alpha = 1;
			FlxTween.tween(noGas, {alpha: 0}, 0.5, {ease: FlxEase.linear});
		case 'atdnc':
			sleighFalling = false;
			stage.stageSprites['sleigh'].visible = false;
			for (i in [boyfriend, stage.stageSprites['sleigh']])
				i.acceleration.y = 0;
			boyfriend.moves = false;
			backgroundCreate('dnc');
			boyfriend.playAnim('fall', false);
		case 'sleighfall':
			stage.stageSprites['sleigh'].visible = true;
			stage.stageSprites['sleigh'].setPosition(300, -1200);
			stage.stageSprites['sleigh'].angle = -30;
			FlxTween.tween(stage.stageSprites['sleigh'], {x:-2000, y:100}, 0.4, {onComplete: function(twn:FlxTween){
				stage.stageSprites['sleigh'].visible = false;
				stage.stageSprites['explosion'].playAnim('explosion');
				stage.stageSprites['explosion'].visible = true;
				FlxG.sound.play(Paths.sound("explosion_sfx"), 0.75);
			}});
	}
}