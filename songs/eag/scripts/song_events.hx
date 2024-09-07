import funkin.game.PlayState;
import funkin.backend.MusicBeatState;
import Sys;
importScript("data/scripts/HandyDandyFunctions");

function onGameOver(event)
{
	event.cancel(true);
	MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
	curVidData = {vid: "eagle jumpsacre", daFunc: function(){
		Sys.exit(1);
	}};
	trace(curVidData);
	FlxG.switchState(new ModState("murica/VidState"));
}

function onSongEnd(){
	HandyDandy.saveMailData("brazil", 'brazil', false, 'Letter from Brazilian government');
}