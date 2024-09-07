import funkin.backend.utils.WindowUtils;
import funkin.game.GameOverSubstate;
import funkin.menus.BetaWarningState;
import funkin.menus.PauseSubState;
import lime.graphics.Image;
import openfl.Lib;

static var curMainMenuSelected:Int = 0;
static var curFreeplaySelected:Int = 0;
static var windowTitleCustom:String = "WHAT'S A KILOMETER";

static var redirectStatesGW:Map<FlxState, String> = [
	TitleState => "murica/AntiPoliticsWarning", 
	MainMenuState => "murica/MainMenuState",
	StoryMenuState => "murica/MainMenuState",
	FreeplayState => "murica/Freeplaylandia"
];

function preStateSwitch() //thank you vs gorefield for custom UI stuffs -slithy
{
	WindowUtils.resetTitle();
	window.title = windowTitleCustom;

    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('GAMEICON')))); //sets game icon
    FlxG.camera.bgColor = 0xFF000000;

	//redirects to modstate if opening these menus
	for (redirectState in redirectStatesGW.keys())
		if (Std.isOfType(FlxG.game._requestedState, redirectState))
			FlxG.game._requestedState = new ModState(redirectStatesGW.get(redirectState));
}

function new() //for save data
{
	//settings
	if(FlxG.save.data.subtitlesGW == null) FlxG.save.data.subtitlesGW = true;
	if(FlxG.save.data.showGWWarning == null) FlxG.save.data.showWarning = true;
	if(FlxG.save.data.brazilMode == null) FlxG.save.data.brazilMode = false;
	//saves
	if(FlxG.save.data.freeplayUnlockedGW == null) FlxG.save.data.freeplayUnlockedGW = false;
	if(FlxG.save.data.songsUnlockedGW == null) FlxG.save.data.songsUnlockedGW = [];
	if(FlxG.save.data.songsFCd == null) FlxG.save.data.songsFCd = [];
	if(FlxG.save.data.songsSFCd == null) FlxG.save.data.songsSFCd = [];

	if(FlxG.save.data.mailUnlocked == null) FlxG.save.data.mailUnlocked = false;
	if(FlxG.save.data.mailObtained == null) FlxG.save.data.mailObtained = []; //contains each letter obtained
	if(FlxG.save.data.mailInventory == null) FlxG.save.data.mailInventory = ["" => []]; //contains data for each mail
	if(FlxG.save.data.mailRead == null) FlxG.save.data.mailRead = []; //contains which mail has been read
	if(FlxG.save.data.mailSongs == null) FlxG.save.data.mailSongs = []; //contains songs where mail is gathered from

	//saves amerikuhn dater
	Lib.application.onExit.add(function(i:Int) {
        FlxG.save.flush();
        trace("Shaving Amerikuhn Dater...");
    });
}