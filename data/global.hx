import funkin.backend.utils.WindowUtils;
import funkin.game.GameOverSubstate;
import funkin.menus.BetaWarningState;
import funkin.menus.PauseSubState;
import lime.graphics.Image;
import openfl.Lib;

static var curMainMenuSelected:Int = 0;
static var curFreeplaySelected:Int = 0;
static var windowTitleCustom:String = "WHAT'S A KILOMETER";

public static var weekProgress:Map<String,
{
	song:String,
	weekMisees:Int,
	weekScore:Int,
	deaths:Int
}> = [];

static var redirectStates:Map<FlxState, String> = [
	TitleState => "murica/MainMenuState", 
	MainMenuState => "murica/MainMenuState",
	StoryMenuState => "murica/MainMenuState",
	FreeplayState => "murica/Freeplaylandia"
];

function preStateSwitch() //thank you vs gorefield for custom UI stuffs -slithy
{
	WindowUtils.resetTitle();
	window.title = windowTitleCustom;

    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('GAMEICON'))));
    FlxG.camera.bgColor = 0xFF000000;

	for (redirectState in redirectStates.keys())
		if (Std.isOfType(FlxG.game._requestedState, redirectState))
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function new() //for save data
{
	//settings
	if(FlxG.save.data.subtitlesGW == null) FlxG.save.data.subtitlesGW = true;
	if(FlxG.save.data.bgEvents == null) FlxG.save.data.bgEvents = true;

	//saves
	if(FlxG.save.data.freeplayUnlocked == null) FlxG.save.data.freeplayUnlocked = false;
	if(FlxG.save.data.songsUnlocked == null) FlxG.save.data.songsUnlocked = [];
	if(FlxG.save.data.songsFCd == null) FlxG.save.data.songsFCd = [];
	if(FlxG.save.data.songsSFCd == null) FlxG.save.data.songsSFCd = [];

	Lib.application.onExit.add(function(i:Int) {
        FlxG.save.flush();
        trace("Shaving Amerikuhn Dater...");
    });
}