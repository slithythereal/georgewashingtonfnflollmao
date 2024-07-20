import funkin.game.PlayState;
import funkin.backend.MusicBeatState;

function onSongEnd(){
    if(PlayState.isStoryMode && !FlxG.save.data.songsUnlocked.contains('Eag')){
        trace("UNLOCKED EAGLE IN FREEPLAY!!!");
        FlxG.save.data.songsUnlocked.push('Eag');
        FlxG.save.flush();
    }
}

function onGameOver(event){
    event.cancel(true);
    MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
    FlxG.switchState(new ModState("murica/EagleGameOver"));
}