import funkin.game.PlayState;

function onSongEnd(){
    if(PlayState.isStoryMode && !FlxG.save.data.songsUnlocked.contains('Eag')){
        trace("UNLOCKED EAGLE IN FREEPLAY!!!");
        FlxG.save.data.songsUnlocked.push('Eag');
        FlxG.save.flush();
    }
}