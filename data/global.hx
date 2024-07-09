import funkin.backend.utils.WindowUtils;
import funkin.game.GameOverSubstate;
import funkin.menus.BetaWarningState;
import funkin.menus.PauseSubState;
import lime.graphics.Image;
import openfl.Lib;

static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;
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
	StoryMenuState => "murica/MainMenuState"/*,
	FreeplayState => "murica/Freeplaylandia"*/
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
	if(FlxG.save.data.subtitles == null) FlxG.save.data.subtitles = false;

	//saves
	if(FlxG.save.data.eagleUnlocked == null) FlxG.save.data.eagleUnlocked = false;
	if(FlxG.save.data.freeplayUnlocked == null) FlxG.save.data.freeplayUnlocked = false;

	Lib.application.onExit.add(function(i:Int) {
        FlxG.save.flush();
        trace("Saving Data...");
    });
}