import funkin.game.PlayState;
import funkin.backend.MusicBeatState;
import Sys;
importScript("data/scripts/HandyDandyFunctions");
importScript("data/scripts/MailUtil");

function create(){
	dad.scrollFactor.set();
}

function onGameOver(event)
{
	event.cancel(true);
	MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
	curVidData = {vid: "eagle jumpsacre", daFunc: function(){
		Sys.exit(1);
	}};
	FlxG.switchState(new ModState("murica/VidState"));
}

function onSongEnd(){
	if(PlayState.isStoryMode)
		MailUtil.newRandomMail(curSong.toLowerCase());
}