
var existingSongsArray:Array<String> = ['patriot', 'god-and-country', 'kilometer', 'eag'];
var songArray:Array<String> = [];
function create(){
    var bg:FlxSprite = new FlxSprite();
    bg.loadGraphic(Paths.image('menus/freeplaylandia/freeplaylandia close up'));
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);
}

function update(elapsed:Float){
    if(controls.BACK) {
        FlxG.sound.play(Paths.sound('menu/cancel'));
        FlxG.switchState(new MainMenuState());
    }

}

function loadSong(song:String){
    PlayState.loadSong(song.toLowerCase(), "normal", false, false);
    FlxG.switchState(new PlayState());
}

function loadData(){
    var saveSongsArray:Array<String> = [];
    for(song in FlxG.save.data.songsUnlocked)
        if(!saveSongsArray.contains(song))
            saveSongsArray.push(song);
    trace(saveSongsArray);
    for(song in saveSongsArray)
    {
        if(existingSongsArray.contains(song))
            songArray.push(song.toLowerCase());
    }
    trace(songArray);
}