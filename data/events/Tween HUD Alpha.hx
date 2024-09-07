var hudTween:FlxTween = null;

function onEvent(_)
{
	if (_.event.name == 'Tween HUD Alpha')
	{ // made it this long bc of the subtitles lmao
		var funnyAlpha = Std.parseFloat(_.event.params[0]);
		var funnyTime = Std.parseFloat(_.event.params[1]);
		for (strum in strumLines)
		{
			for (i => strumLine in strumLines.members)
			{
				for (strumNote in strumLine.members)
					FlxTween.tween(strumNote, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
			}
		}
		FlxTween.tween(iconP1, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(iconP2, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(healthBarBG, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(healthBar, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(scoreTxt, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(accuracyTxt, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
		FlxTween.tween(missesTxt, {alpha: funnyAlpha}, funnyTime, {ease: FlxEase.linear});
	}
}
