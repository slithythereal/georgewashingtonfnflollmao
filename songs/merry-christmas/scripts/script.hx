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
}

function beatHit(curBeat:Int)
{
	switch (curBeat)
	{
		case 52:
			sleighFalling = true;
			for (i in [boyfriend, stage.stageSprites['sleigh']])
				i.acceleration.y = 1200 * 1.5;
			noGas.alpha = 1;
			FlxTween.tween(noGas, {alpha: 0}, 0.5, {ease: FlxEase.linear});
		case 54:
			sleighFalling = false;
			for (i in [boyfriend, stage.stageSprites['sleigh']])
				i.acceleration.y = 0;
			boyfriend.moves = false;
			backgroundCreate('dnc');
			boyfriend.playAnim('fall', false);
	}
}
