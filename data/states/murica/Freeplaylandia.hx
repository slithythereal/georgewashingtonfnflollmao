import flixel.math.FlxMath;
import funkin.backend.utils.CoolUtil;

var existingSongsArray:Array<String> = ['patriot', 'god-and-country', 'kilometer', 'eag'];
var songArray:Array<String> = [];
var curSelected:Int = 0;
var portrait:FlxSprite;
var arrowLEFT:FlxSprite;
var arrowRIGHT:FlxSprite;
function create(){
    CoolUtil.playMenuSong();


    loadData();
    
    var bg:FlxSprite = new FlxSprite();
    bg.loadGraphic(Paths.image('menus/freeplaylandia/freeplaylandia close up'));
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    portraitGrp = new FlxTypedGroup();
    add(portraitGrp);

    portrait = new FlxSprite();
    portrait.loadGraphic(Paths.image('menus/freeplaylandia/songs/picture_' + songArray[curSelected].toLowerCase()));
    portrait.scale.set(0.75, 0.75); 
    portrait.updateHitbox();
    portrait.screenCenter();
    add(portrait);
}

function update(elapsed:Float){
    if(controls.BACK) {
        FlxG.sound.play(Paths.sound('menu/cancel'));
        FlxG.switchState(new MainMenuState());
    }
    if(controls.ACCEPT) loadSong(songArray[curSelected].toLowerCase());
    if(controls.LEFT_P) changeOption(-1);
    if(controls.RIGHT_P) changeOption(1);
}

function loadSong(song:String){
    PlayState.loadSong(song.toLowerCase(), "normal", false, false);
    FlxG.switchState(new PlayState());
}

function changeOption(cool:Int){
    curSelected += cool;
    if(curSelected >= songArray.length)
        curSelected = 0;
    if(curSelected < 0)
        curSelected = songArray.length -1;

    portrait.loadGraphic(Paths.image('menus/freeplaylandia/songs/picture_' + songArray[curSelected].toLowerCase()));

    FlxTween.tween(portrait, {"scale.x": 0.8, "scale.y": 0.8}, 0.05, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
        FlxTween.tween(portrait, {"scale.x": 0.75, "scale.y": 0.75}, 0.05, {ease:FlxEase.linear});
    }});

    trace(curSelected);
}

function loadData(){
    var saveSongsArray:Array<String> = [];
    for(song in FlxG.save.data.songsUnlocked)
        if(!saveSongsArray.contains(song))
            saveSongsArray.push(song);
    trace(saveSongsArray);
    for(song in saveSongsArray)
    {
        if(existingSongsArray.contains(song.toLowerCase()))
            songArray.push(song.toLowerCase());
    }
    trace(songArray);
}
function watch(obj:FlxObject){
    FlxG.watch.add(obj, "x");
    FlxG.watch.add(obj, "y");
}