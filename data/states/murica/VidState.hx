import hxvlc.flixel.FlxVideoSprite;

importScript("data/scripts/HandyDandyFunctions");

var funnyVideo:FlxVideoSprite;

function postCreate()
{
	funnyVideo = new FlxVideoSprite();
	funnyVideo.load(Assets.getPath(Paths.video(curVidData.vid))); //loads video
	add(funnyVideo);
	funnyVideo.play();
	funnyVideo.bitmap.onEndReached.add(function()
	{
		funnyVideo.destroy();
		if(curVidData.daFunc != null) //runs function if has one
			curVidData.daFunc();
	});
}
