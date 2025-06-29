var hudTween:FlxTween = null;

function onEvent(_)
{
	if (_.event.name == 'Tween HUD Alpha')
	{ // made it this way bc of the subtitles lmao
		var funnyAlpha = Std.parseFloat(_.event.params[0]);
		var funnyTime = Std.parseFloat(_.event.params[1]);

		for(i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, accuracyTxt, missesTxt])
			FlxTween.tween(i, {alpha: funnyAlpha}, funnyTime, {ease:FlxEase.linear});

		tweenNote(funnyAlpha, funnyTime);
		
	}
}

function tweenNote(alpha:Float, time:Float){
	for (strum in strumLines)
		{
			for (i => strumLine in strumLines.members)
			{
				for (strumNote in strumLine.members)
					FlxTween.tween(strumNote, {alpha: alpha}, time, {ease: FlxEase.linear});
			}
		}
}