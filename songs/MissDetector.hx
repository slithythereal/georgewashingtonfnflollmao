import funkin.game.PlayState; // detects misses in a week and runs event

var funnySongs:Array<String> = [];

// might use this script for the future -slithy
function onSongEnd()
{
	if (misses <= 0 && !FlxG.save.data.songsFCd.contains(curSong.toLowerCase())) //saves song to savedata if fc'd
	{
		FlxG.save.data.songsFCd.push(curSong.toLowerCase());
		FlxG.save.flush();
		trace("i neva miss");
	}

	if(PlayState.isStoryMode && PlayState.storyPlaylist[0] == funnySongs[funnySongs.length - 1])
	{
		for(song in funnySongs){
			if(!FlxG.save.data.songsUnlockedGW.contains(song)){
				trace("UNLOCKED " + song.toUpperCase() + " IN FREEPLAY!!!");
				FlxG.save.data.songsUnlockedGW.push(song);
				FlxG.save.flush();
				trace(FlxG.save.data.songsUnlockedGW);
			}
		}
	}
}

function create()
{
	if (PlayState.isStoryMode)
		funnySongs = [for (e in PlayState.storyWeek.songs) e.name];
}
