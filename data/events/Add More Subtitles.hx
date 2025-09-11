import flixel.text.FlxTextBorderStyle;

var subTitle:FlxText = null;

function create()
{
	if (FlxG.save.data.subtitlesGW)
	{
		subTitle = new FlxText(0, 555, 0, "");
		subTitle.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
		subTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		subTitle.borderSize = 1;
		subTitle.screenCenter(FlxAxes.X);
		add(subTitle);
		subTitle.camera = camHUD;
	}
}

function onEvent(_)
{
	if (FlxG.save.data.subtitlesGW && _.event.name == 'Add More Subtitles')
	{
		subTitle.text = _.event.params[0];
		subTitle.color = FlxColor.fromString(_.event.params[1]);
		subTitle.screenCenter(FlxAxes.X);
		subTitle.scale.set(1.2, 1.2);
		FlxTween.tween(subTitle, {"scale.x": 1, "scale.y": 1}, 0.05, {ease:FlxEase.linear});
	}
}
