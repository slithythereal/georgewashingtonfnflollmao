
import flixel.math.FlxMath;
import funkin.backend.utils.CoolUtil;
importScript('data/scripts/HandyDandyFunctions');

var songs:Array<String> = ['behind-the-eag', 'dementia', 'merry-christmas', 'grimace', 'jelly-donut', 'eagnite'];
var curSelected:Int = 0;
var arrowLeft, arrowRight:FlxSprite;
var songTxt:FlxText;

function create(){
	HandyDandy.playMenuSong(FlxG.save.data.curCountry);

    songTxt = new FlxText(0,0,0, songs[curSelected]);
    songTxt.setFormat(null, 45, 0xFFFFFF, "center");
    songTxt.screenCenter();
    add(songTxt);

    arrowLeft = new FlxSprite(95, 325);
	arrowLeft.loadGraphic(Paths.image('menus/arrow'));
	arrowLeft.scale.set(0.25, 0.15);
	arrowLeft.updateHitbox();
	arrowLeft.angle = -90;
	add(arrowLeft);

	arrowRight = new FlxSprite(1045, 325);
	arrowRight.loadGraphic(Paths.image('menus/arrow'));
	arrowRight.scale.set(0.25, 0.15);
	arrowRight.updateHitbox();
	arrowRight.angle = 90;
	add(arrowRight);

    changeSong(0);
}

function update(elapsed:Float){
    if(controls.BACK)
        FlxG.switchState(new MainMenuState());
    if(controls.ACCEPT)
        HandyDandy.loadSong(songs[curSelected].toLowerCase());   

    if (controls.LEFT_P || FlxG.mouse.overlaps(arrowLeft) && arrowLeft.visible && FlxG.mouse.justPressed)
    {
        changeSong(-1);
        FlxTween.tween(arrowLeft, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
            ease: FlxEase.quintInOut,
            onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(arrowLeft, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
            }
        });
    }
    if (controls.RIGHT_P || FlxG.mouse.overlaps(arrowRight) && arrowRight.visible && FlxG.mouse.justPressed)
    {
        changeSong(1);
        FlxTween.tween(arrowRight, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
            ease: FlxEase.quintInOut,
            onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(arrowRight, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
            }
        });
    }
}

function changeSong(cool:Int){
	var cantMove:Bool = false;
    curSelected += cool;
    arrowLeft.visible = (curSelected <= 0) ? false : true;
	arrowRight.visible = (curSelected >= songs.length - 1) ? false : true;

	if (curSelected >= songs.length)
	{
		curSelected = songs.length - 1;
		cantMove = true;
	}
	else if (curSelected < 0)
	{
		curSelected = 0;
		cantMove = true;
	}

    if(!cantMove){
        songTxt.text = songs[curSelected].toUpperCase();
        songTxt.screenCenter();
    }
}