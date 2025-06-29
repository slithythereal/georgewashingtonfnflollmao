importScript('data/scripts/HandyDandyFunctions');

var vhsArray:Array<String> = [];
var curVhsSelected:Int = 0;
var vhsExist:Bool = false;
var tv:FlxSprite;
var vhsPlayer:FlxSprite;
function create(){
    tv = new FlxSprite(0, 85);
    tv.loadGraphic(Paths.image('menus/vhs/oldtv'));
    tv.scale.set(0.25, 0.25);
    tv.updateHitbox(FlxAxes.X);
    tv.screenCenter();
    add(tv);

    vhsPlayer = new FlxSprite(165, 450);
    vhsPlayer.frames = Paths.getSparrowAtlas('menus/vhs/vhsplayer');
    vhsPlayer.animation.addByPrefix("idle", 'vhsplayer', 24);
    vhsPlayer.animation.addByPrefix("boom", 'vhsboom', 24);
    vhsPlayer.scale.set(0.5, 0.15);
    vhsPlayer.updateHitbox();
    vhsPlayer.scale.set(0.6, 0.6);
    vhsPlayer.origin.set(400, 715);
    add(vhsPlayer);
    vhsPlayer.animation.play("idle");
}

function update(elapsed:Float){
    if(controls.BACK)
        FlxG.switchState(new MainMenuState());
}