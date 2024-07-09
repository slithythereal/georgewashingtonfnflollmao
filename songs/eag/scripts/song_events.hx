import funkin.game.PlayState;

function onSongEnd(){
    if(PlayState.isStoryMode && !FlxG.save.data.eagleUnlocked){
        trace("UNLOCKED EAGLE IN FREEPLAY!!!");
        FlxG.save.data.eagleUnlocked = true;
        FlxG.save.flush();
    }
}