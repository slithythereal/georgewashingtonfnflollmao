import flixel.text.FlxTextBorderStyle;

importScript("data/scripts/HandyDandyFunctions");
var emperorTxt:FlxText;

function onSongEnd()
{
	HandyDandy.saveMailData("toucan", "toucan", false, "Another Letter from the Brazilian government");
}

function create()
{
	emperorTxt = new FlxText(-375, 100, 0, "The FIRST emperor of BRAZIL\nDom Pedro");
	emperorTxt.setFormat("fonts/impact.ttf", 50, FlxColor.WHITE, "center");
	emperorTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	emperorTxt.borderSize = 4;
	add(emperorTxt);
}

function beatHit(curBeat:Int)
	if (curBeat == 0)
		FlxTween.tween(emperorTxt, {alpha: 0}, 5, {ease: FlxEase.linear});

