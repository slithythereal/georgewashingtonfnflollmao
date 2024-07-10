import funkin.game.PlayState;

function onSongEnd(){
    if(PlayState.isStoryMode){
        var songsToUnlock:Array<String> = ['patriot', 'god-and-country', 'kilometer'];
        for(song in songsToUnlock)
            if(!FlxG.save.data.songsUnlocked.contains(song))
                FlxG.save.data.songsUnlocked.push(song);
        trace("unlocked freeplaylandia (WINNER!!!)");
        trace(FlxG.save.data.songsUnlocked);
        FlxG.save.flush();
    }
}
