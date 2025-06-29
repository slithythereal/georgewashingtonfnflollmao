import Sys;
import funkin.backend.MusicBeatState;
importScript("data/scripts/MailUtil");
importScript("data/scripts/HandyDandyFunctions");

function onGameOver(event)
{
	event.cancel(true);
	MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
	curVidData = {
		vid: "lol you lose",
		daFunc: function()
		{
			Sys.exit(1);
		}
	};
	trace(curVidData);
	FlxG.switchState(new ModState("murica/VidState"));
}
function create() 
	window.title = "Fortnite: Battle Royale";
