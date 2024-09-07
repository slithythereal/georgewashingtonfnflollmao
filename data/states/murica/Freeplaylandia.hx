import flixel.math.FlxMath;
import funkin.backend.utils.CoolUtil;

importScript("data/scripts/HandyDandyFunctions");
var existingSongsArray:Array<String> = [
	'patriot',
	'god-and-country',
	'kilometer',
	'eag',
	'negotiations',
	'can'
];

var songArray:Array<String> = [];
var curSelected:Int = curFreeplaySelected;
var portrait:FlxSprite;
var arrowLEFT:FlxSprite;
var arrowRIGHT:FlxSprite;
var songProperties:Map<String, {didFC:Bool}> = [];
var skibidistar:FlxSprite;

function create()
{
	FlxG.mouse.visible = true;

	loadData();

	var isBrazil:Bool = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);
	HandyDandy.playMenuSong(isBrazil);

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

	arrowLEFT = new FlxSprite(95, 325);
	arrowLEFT.loadGraphic(Paths.image('menus/arrow'));
	arrowLEFT.scale.set(0.25, 0.15);
	arrowLEFT.updateHitbox();
	arrowLEFT.angle = -90;
	add(arrowLEFT);

	arrowRIGHT = new FlxSprite(1045, 325);
	arrowRIGHT.loadGraphic(Paths.image('menus/arrow'));
	arrowRIGHT.scale.set(0.25, 0.15);
	arrowRIGHT.updateHitbox();
	arrowRIGHT.angle = 90;
	add(arrowRIGHT);

	skibidistar = new FlxSprite(380, 60);
	skibidistar.loadGraphic(Paths.image("menus/freeplaylandia/skibidistar"));
	skibidistar.scale.set(0.6, 0.6);
	skibidistar.updateHitbox();
	add(skibidistar);

	changeOption(0);
}

function update(elapsed:Float)
{
	if (controls.BACK)
	{
		FlxG.sound.play(Paths.sound('menu/cancel'));
		FlxG.switchState(new MainMenuState());
	}
	if (controls.ACCEPT)
		HandyDandy.loadSong(songArray[curSelected].toLowerCase()); 
	if (controls.LEFT_P || FlxG.mouse.overlaps(arrowLEFT) && arrowLEFT.visible && FlxG.mouse.justPressed)
	{
		changeOption(-1);
		FlxTween.tween(arrowLEFT, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
			ease: FlxEase.quintInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(arrowLEFT, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
			}
		});
	}
	if (controls.RIGHT_P || FlxG.mouse.overlaps(arrowRIGHT) && arrowRIGHT.visible && FlxG.mouse.justPressed)
	{
		changeOption(1);
		FlxTween.tween(arrowRIGHT, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
			ease: FlxEase.quintInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(arrowRIGHT, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
			}
		});
	}
}

function changeOption(cool:Int)
{
	var cantMove:Bool = false;
	curSelected += cool;

	//makes arrows visible depending on if you're on the first or last song in the menu
	arrowLEFT.visible = (curSelected <= 0) ? false : true;
	arrowRIGHT.visible = (curSelected >= songArray.length - 1) ? false : true;

	if (curSelected >= songArray.length)
	{
		curSelected = songArray.length - 1;
		cantMove = true;
	}
	else if (curSelected < 0)
	{
		curSelected = 0;
		cantMove = true;
	}

	if(!cantMove){
		curFreeplaySelected = curSelected;

		portrait.loadGraphic(Paths.image('menus/freeplaylandia/songs/picture_' + songArray[curSelected].toLowerCase()));
	
		FlxTween.tween(portrait, {"scale.x": 0.8, "scale.y": 0.8}, 0.05, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(portrait, {"scale.x": 0.75, "scale.y": 0.75}, 0.05, {ease: FlxEase.linear});
			}
		});
	
		skibidistar.visible = songProperties[songArray[curSelected]].didFC; // makes star visible if fc'd the song
		FlxTween.tween(skibidistar, {"scale.x": 0.65, "scale.y": 0.65}, 0.05, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(skibidistar, {"scale.x": 0.6, "scale.y": 0.6}, 0.05, {ease: FlxEase.linear});
			}
		});
	}
}

function loadData()
{
	var saveSongsArray:Array<String> = [];
	// takes songs from save data
	for (song in FlxG.save.data.songsUnlockedGW)
		if (!saveSongsArray.contains(song))
			saveSongsArray.push(song);

	// detects if the saved song aint an error
	for (song in saveSongsArray)
		if (existingSongsArray.contains(song.toLowerCase()))
			songArray.push(song.toLowerCase());

	// sets the song properties
	for (song in songArray)
	{
		var songlol:String = song.toLowerCase();
		songProperties.set(songlol, {
			didFC: (FlxG.save.data.songsFCd.contains(songlol)) ? true : false //detects if song is fc'd based on savedata
		});
	}
	trace(songProperties);
}
