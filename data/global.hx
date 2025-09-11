import funkin.backend.utils.WindowUtils;
import funkin.game.GameOverSubstate;
import funkin.menus.BetaWarningState;
import funkin.menus.PauseSubState;
import lime.graphics.Image;
import openfl.Lib;

static var curMainMenuSelected:Int = 0;
static var windowTitleCustom:String = "WHAT'S A KILOMETER";

static var redirectStatesGW:Map<FlxState, String> = [
	TitleState => "murica/AntiPoliticsWarning", 
	MainMenuState => "murica/MainMenuState",
	StoryMenuState => "murica/MainMenuState",
	FreeplayState => "murica/Freeplaylandia"
];

function preStateSwitch() 
{
	WindowUtils.resetTitle();
	window.title = (FlxG.save.data.curCountry == 'brazil' ? "BEM-VINDO AO BRASIL!" : windowTitleCustom);
    Main.framerateSprite.codenameBuildField.text = "Vs George Washington";

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
	if(FlxG.save.data.subtitlesGW == null) FlxG.save.data.subtitlesGW = true; //subtitles
	if(FlxG.save.data.showGWWarning == null) FlxG.save.data.showGWWarning = true; //warning screen
	if(FlxG.save.data.curCountry == null) FlxG.save.data.curCountry = 'america'; //current country selected
	//saves
	if(FlxG.save.data.weirdRouteEnabled == null) FlxG.save.data.weirdRouteEnabled = false; //WEIRD ROUTE
	if(FlxG.save.data.freeplayUnlockedGW == null) FlxG.save.data.freeplayUnlockedGW = false; //freeplay unlocked
	if(FlxG.save.data.songsUnlockedGW == null) FlxG.save.data.songsUnlockedGW = []; //current songs unlocked
	if(FlxG.save.data.songsFCd == null) FlxG.save.data.songsFCd = []; //songs FC'd
	if(FlxG.save.data.songsSFCd == null) FlxG.save.data.songsSFCd = []; //unused
	if(FlxG.save.data.whiteHouseRisen == null) FlxG.save.data.whiteHouseRisen = false; //white house unlocked
	if(FlxG.save.data.flappyEagDelivered == null) FlxG.save.data.flappyEagDelivered = false;
	if(FlxG.save.data.launchCodesObtained) FlxG.save.data.launchCodesObtained = false;
	//mail
	if(FlxG.save.data.mailUnlocked == null) FlxG.save.data.mailUnlocked = false; //mailbox unlocked
	if(FlxG.save.data.mailObtained == null) FlxG.save.data.mailObtained = []; //contains each letter obtained
	if(FlxG.save.data.mailInventory == null) FlxG.save.data.mailInventory = ["" => []]; //contains data for each mail
	if(FlxG.save.data.mailRead == null) FlxG.save.data.mailRead = []; //contains which mail has been read
	if(FlxG.save.data.mailSongs == null) FlxG.save.data.mailSongs = []; //contains songs where mail is gathered from
	if(FlxG.save.data.mailInTruck == null) FlxG.save.data.mailInTruck = []; //how much mail is in the truck
	//vhs
	if(FlxG.save.data.vhsObtained == null) FlxG.save.data.vhsObtained = []; //current vhs obtained
	if(FlxG.save.data.vhsTOTAL == null) FlxG.save.data.vhsTOTAL = []; //saves vhs to prevent repeat obtaining
	
	//saves amerikuhn dater
	Lib.application.onExit.add(function(i:Int) {
        FlxG.save.flush();
        trace("Shaving Amerikuhn Dater...");
    });
}