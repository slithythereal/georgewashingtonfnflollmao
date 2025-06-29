import flixel.text.FlxTextBorderStyle;
importScript('data/scripts/MailUtil');
importScript('data/scripts/Invisible HUD');
importScript("data/scripts/HandyDandyFunctions");
var emperorTxt:FlxText;
var presidentTxt:FlxText;

function onSongEnd(){
	if (PlayState.isStoryMode){
		HandyDandy.saveMailData("toucan", "toucan", false, "Another Letter from the Brazilian government");
		MailUtil.newRandomMail(curSong.toLowerCase());
	}
}


function create()
{
	emperorTxt = new FlxText(-375, 100, 0, "The FIRST emperor of BRAZIL\nDom Pedro");
	emperorTxt.setFormat("fonts/impact.ttf", 50, FlxColor.WHITE, "center");
	emperorTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	emperorTxt.borderSize = 4;
	add(emperorTxt);

	presidentTxt = new FlxText(635, 100, 0, "O PRIMEIRO Presidente dos ESTADOS UNIDOS\nGeorge Washington");
	presidentTxt.setFormat("fonts/impact.ttf", 50, FlxColor.WHITE, "center");
	presidentTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	presidentTxt.borderSize = 4;
	add(presidentTxt);
}

function beatHit(curBeat:Int)
{
	switch (curBeat)
	{
		case 0:
			FlxTween.tween(emperorTxt, {alpha: 0}, 5, {ease: FlxEase.linear});
		case 8:
			FlxTween.tween(presidentTxt, {alpha: 0}, 5, {ease: FlxEase.linear});
	}
}
