import flixel.addons.text.FlxTypeText;
import flixel.system.FlxSound;
import flixel.input.keyboard.FlxKey;

importScript("data/scripts/WhiteHouseHandler");

var spaceTXT:FlxText;
var warningDESCRIPTION:FlxTypeText;
var escapeTXT:FlxText;
var curText:Int = 1;

var dayProperties:Map<String, {dialogueAmt:Int, endFunc:Void->Void}> = [
	'day' => {
		dialogueAmt: 8,
		endFunc: function() FlxG.switchState(new ModState("murica/WhiteHouseState"))
	},
	'night' => {dialogueAmt: 8, endFunc: null}
];

var tOD:String; // time of day
var canSkip:Bool = false;
var forceOFF:Bool = false;

var instructions:Map<String, {text:String, delay:Float, func:Void->Void}> = [
	"day1" => {
		text: "Welcome to the day shift!\nYou are tasked with finding 4 classified government tapes.\nIn return, you will get a reward for each tape retrieved.",
		delay: 0.05,
		func: null
	},
	"day2" => {
		text: "Use items you find across the white house to assist you in your expedition.\nPress (TAB) to pull up your inventory",
		delay: 0.05,
		func: null
	},
	"day3" => {text: "You also have notes you can pull up and view\nPress (N) to pull up your notes.", delay: 0.05, func: null},
	"day4" => {text: "Negotiate with white house employees and residents.", delay: 0.05, func: null},
	"day5" => {text: "Get the tapes.", delay: 0.05, func: null},
	"day6" => {text: "Leave the White House.", delay: 0.05, func: null},
	"day7" => {text: "It is as simple as that.\nNow, go and get your tapes, you will recieve your reward soon!", delay: 0.05, func: null},
	"day8" => {text: "just don't run out of time.", delay: 0.1, func: null}
];

var type1:FlxSound;
var type2:FlxSound;
var type3:FlxSound;

function create()
{
	brazilOn = !(FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);
	FlxG.sound.music.stop();
	type1 = new FlxSound();
	type2 = new FlxSound();
	type3 = new FlxSound();
	FlxG.sound.list.add(type1);
	FlxG.sound.list.add(type2);
	FlxG.sound.list.add(type3);
	type1.loadEmbedded(Paths.sound('ui/type_1'));
	type2.loadEmbedded(Paths.sound('ui/type_2'));
	type3.loadEmbedded(Paths.sound('ui/type_3'));

	// tOD = (isNight ? "night" : "day"); //for update
	tOD = "day";
	trace(tOD);
	warningDESCRIPTION = new FlxTypeText(0, 140, FlxG.width - 250, '');
	warningDESCRIPTION.setFormat("fonts/VCR.ttf", 25, FlxColor.WHITE, "center");
	add(warningDESCRIPTION);
	warningDESCRIPTION.sounds = [type1, type2, type3];

	spaceTXT = new FlxText(0, 470, 0, "Press [SPACE] to continue");
	spaceTXT.setFormat("fonts/VCR.ttf", 15, FlxColor.WHITE, "center");
	add(spaceTXT);
	spaceTXT.screenCenter(FlxAxes.X);
	spaceTXT.visible = false;

	escapeTXT = new FlxTypeText(8, FlxG.height - 38, 0, ".....................");
	escapeTXT.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "center");
	add(escapeTXT);
	escapeTXT.alpha = 0;
	escapeTXT.prefix = "Skipping";


	nextTXT(0);
}

var skipMessageTime:Float = 0;

function update(elapsed:Float)
{
	warningDESCRIPTION.screenCenter(FlxAxes.X);
	#if debug
	if(FlxG.keys.justPressed.Q)
		FlxG.switchState(new ModState("murica/WhiteHouseState"));
	#end
	if (!forceOFF)
	{
		if (canSkip && FlxG.keys.justPressed.SPACE)
		{
			if(curText != dayProperties[tOD].dialogueAmt)
				nextTXT(1);
			else
			{
				if(dayProperties[tOD].endFunc != null)
					dayProperties[tOD].endFunc();
			}
		}
	}

	if (FlxG.keys.justPressed.ESCAPE)
	{
		escapeTXT.start(0.25, true, false, null, null);
	}
	if (FlxG.keys.pressed.ESCAPE)
	{
		skipMessageTime += elapsed;
		escapeTXT.alpha += 0.5 * elapsed;
	}
	if (FlxG.keys.justReleased.ESCAPE)
	{
		skipMessageTime = 0;
		escapeTXT.alpha = 0;
	}
	if (skipMessageTime >= 2)
		if(dayProperties[tOD].endFunc != null)
			dayProperties[tOD].endFunc();
}

function nextTXT(cool:Int)
{
	curText += cool;
	if (curText > dayProperties[tOD].dialogueAmt)
		curText = dayProperties[tOD].dialogueAmt;
	if (curText < 1)
		curText = 1;

	warningDESCRIPTION.resetText(instructions[tOD + curText].text);
	warningDESCRIPTION.start(instructions[tOD + curText].delay, true);
	spaceTXT.visible = false;
	canSkip = false;
	warningDESCRIPTION.completeCallback = function()
	{
		canSkip = true;
		spaceTXT.visible = true;
	}
	if (instructions[tOD + curText].func != null)
		instructions[tOD + curText].func();
}
