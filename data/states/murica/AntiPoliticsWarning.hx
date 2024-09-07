import flixel.text.FlxTextBorderStyle;
import funkin.backend.MusicBeatState;
import funkin.options.keybinds.KeybindsOptions;

var selected:Bool = false;
var clickToStop:FlxText;
var stopdisappeared:Bool = false;
var isSkipping:Bool;

function create()
{ // warning for people playing mod for the first time
	FlxG.mouse.visible = true;
	// skips warning if option is off
	isSkipping = (!FlxG.save.data.showGWWarning && FlxG.save.data.showGWWarning != null ? true : false);
	if (isSkipping)
		go();
	else
	{
		var politicsTxt:FlxText = new FlxText(0, 75, FlxG.width);
		politicsTxt.text = "WARNING\n"
			+ "This mod doesn't encourage politics in any way, neither left or right\n"
			+ "This project was made for fun and sheer comedy\n"
			+ "We hope you enjoy it!";
		politicsTxt.setFormat("fonts/impact.ttf", 45, FlxColor.WHITE, "center");
		politicsTxt.screenCenter(FlxAxes.X);
		add(politicsTxt);

		var pressEnter:FlxText = new FlxText(0, 400);
		pressEnter.text = "Press ACCEPT to play!";
		pressEnter.setFormat("fonts/impact.ttf", 45, FlxColor.YELLOW, "center");
		pressEnter.screenCenter(FlxAxes.X);
		add(pressEnter);

		clickToStop = new FlxText(0, 475);
		clickToStop.text = "Click me to turn off this screen!";
		clickToStop.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
		clickToStop.screenCenter(FlxAxes.X);
		add(clickToStop);
	}
}

function update(elapsed:Float)
{
	if (!selected)
	{
		if (controls.ACCEPT && !isSkipping)
			go();

		if (FlxG.mouse.overlaps(clickToStop) && !stopdisappeared)
		{
			clickToStop.scale.set(1.25, 1.25);
			clickToStop.color = FlxColor.RED;
			if (FlxG.mouse.justPressed)
			{
				FlxG.save.data.showGWWarning = !FlxG.save.data.showGWWarning;
				FlxG.save.flush();
				stopdisappeared = true;
				clickToStop.visible = false;
			}
		}
		else
		{
			clickToStop.scale.set(1, 1);
			clickToStop.color = FlxColor.WHITE;
		}
	}
}

function go()
{
	selected = true;
	FlxG.camera.alpha = 0;
	new FlxTimer().start(0.75, function(tmr:FlxTimer)
	{
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new MainMenuState());
	});
}
