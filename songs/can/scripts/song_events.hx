
import Sys;
import funkin.backend.MusicBeatState;

function onGameOver(event)
{
	event.cancel(true);
	MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
	curVidData = {
		vid: "toucanjumpscare",
		daFunc: function()
		{
			Sys.exit(1);
		}
	};
	trace(curVidData);
	FlxG.switchState(new ModState("murica/VidState"));
}
