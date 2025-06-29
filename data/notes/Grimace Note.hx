import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import funkin.game.PlayState;
import flixel.system.FlxSound;

var funnyCoords:Array<Array<Float>> = [[400, 0], [-100, -100], [300, 200], [400, 400], [-200, 400], [-200, 0]];
var radiationBar:FlxBar;
var radiation:Float = 0;
var radiationMeter:FlxSprite;
var radiationBarVisible:Bool = false;
var radiationSound:FlxSound;
var splashGrp:FlxTypedGroup<FlxSprite>;
var camOther:FlxCamera;
var blackCam:FlxSprite;
var trumpMaced:FlxSprite;
var radiationFull:Bool = false;

function onPlayerMiss(event)
{
	if (event.noteType == 'Grimace Note')
	{
		event.cancel(true);
		event.note.strumLine.deleteNote(event.note);
	}
}

function onNoteCreation(event)
{
	if (event.noteType == 'Grimace Note')
	{
		event.note.avoid = true;
		event.note.latePressWindow = 0.25;
	}
}

function onPlayerHit(event)
{
	if (event.noteType == 'Grimace Note')
	{
		event.countAsCombo = event.showRating = event.showSplash = false;
		event.strumGlowCancelled = true;
		grimaceSplash();
	}
}

function create()
{
	radiationMeter = new FlxSprite(2175, 0);
	radiationMeter.loadGraphic(Paths.image('mechanics/grimaceradiation'));
	radiationMeter.scale.set(0.9, 0.9);
	radiationMeter.updateHitbox();
	radiationMeter.screenCenter(FlxAxes.Y);
	add(radiationMeter);

	radiationBar = new FlxBar(2191, radiationMeter.y + 43, FlxBarFillDirection.BOTTOM_TO_TOP, Std.int(112.5 - 30), Std.int(290 - 86), __script__.variables,
		'radiation', 0, 100);
	radiationBar.createFilledBar(0xff0f0324, 0xFF9900FF);
	add(radiationBar);
	radiationBar.filledCallback = radiationKILL;

	for (i in [radiationMeter, radiationBar])
		i.cameras = [camHUD];

	radiationSound = new FlxSound();
	radiationSound.loadEmbedded(Paths.sound('radiation'), true);
	radiationSound.play();
	radiationSound.volume = (radiation / 100);
	FlxG.sound.list.add(radiationSound);

	splashGrp = new FlxTypedGroup();
	add(splashGrp);
	// precache
	for (i in [1, 2, 3, 4])
	{
		var splash:FlxSprite = new FlxSprite(0, 0);
		splash.loadGraphic(Paths.image('mechanics/grimacesplash' + i));
		splash.scale.set(1, 1);
		splash.updateHitbox();
		splash.scale.set(0.1, 0.1);
		splashGrp.add(splash);
		splash.ID = i;
		splash.visible = false;
	}
}

function postCreate()
{
	blackCam = new FlxSprite();
	blackCam.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	add(blackCam);
	blackCam.cameras = [camHUD];

	trumpMaced = new FlxSprite();
	trumpMaced.loadGraphic(Paths.image('mechanics/trumpmaced'));
	trumpMaced.screenCenter();
	add(trumpMaced);
	trumpMaced.alpha = 0.75;
	trumpMaced.cameras = [camHUD];
	blackCam.visible = trumpMaced.visible = false;
}

function beatHit(curBeat:Int)
{
	if (curSong.toLowerCase() == 'grimace')
	{
		switch (curBeat)
		{
			case 116:
				revealRadiationBar();
			case 436:
				FlxTween.tween(radiationMeter, {x: 2175}, 2, {ease: FlxEase.linear});
				FlxTween.tween(radiationBar, {x: 2191}, 2, {ease: FlxEase.linear});
				radiationSound.stop();
		}
	}
}

function grimaceSplash()
{
	var randoTex:Int = FlxG.random.int(1, 4);
	var randoPos:Int = FlxG.random.int(0, funnyCoords.length - 1);
	var splash:FlxSprite = new FlxSprite(0, 0);
	splash.setPosition(funnyCoords[randoPos][0], funnyCoords[randoPos][1]);
	splash.loadGraphic(Paths.image('mechanics/grimacesplash' + randoTex));
	splash.scale.set(1, 1);
	splash.updateHitbox();
	splash.scale.set(0.1, 0.1);
	splashGrp.add(splash);
	splash.cameras = [camHUD];
	FlxG.sound.play(Paths.sound('grimacesplat' + FlxG.random.int(1, 3)));
	FlxTween.tween(splash, {"scale.x": 1, "scale.y": 1}, 0.1, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween)
		{
			splash.velocity.y = FlxG.random.float(5, 35);
			new FlxTimer().start(FlxG.random.float(5, 7.5), function(tmr:FlxTimer)
			{
				FlxTween.tween(splash, {alpha: 0}, FlxG.random.float(8, 12), {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						splashGrp.remove(splash);
					}
				});
			});
		}
	});

	if(!radiationFull){
		radiation += 5;
		radiationBar.value = radiation;
		if (radiationSound.playing)
			radiationSound.volume = (radiation / 100);
		revealRadiationBar();
	}

}

function revealRadiationBar()
{
	if (!radiationBarVisible)
	{
		radiationBarVisible = true;
		FlxTween.tween(radiationMeter, {x: 1175}, 3, {ease: FlxEase.quartInOut});
		FlxTween.tween(radiationBar, {x: 1191}, 3, {ease: FlxEase.quartInOut});
	}
}

function onPostGameOver()
	if (radiationSound.playing)
		radiationSound.stop();

function radiationKILL()
{
	radiationFull = true;
	FlxG.sound.play(Paths.sound('slenderman'));

	FlxTween.tween(camGame, {zoom: 0.9}, 5.069, {ease: FlxEase.linear});
	FlxTween.color(boyfriend, 5.069, FlxColor.WHITE, 0xFF510069, {ease: FlxEase.linear});
	new FlxTimer().start(7.889, function(slender:FlxTimer)
	{
		gameOver(boyfriend);
	});
	new FlxTimer().start(5.069, function(tmr:FlxTimer)
	{
		radiationSound.stop();
		PlayState.instance.paused = true;
		PlayState.instance.canPause = false;
		for (strumLine in PlayState.instance.strumLines.members)
		{
			strumLine.vocals.pause();
			strumLine.vocals.volume = 0;
		}
		PlayState.instance.inst.pause();
		PlayState.instance.vocals.pause();
		PlayState.instance.vocals.volume = PlayState.instance.inst.volume = 0;

		camGame.visible = false;
		camHUD.visible = false;
		blackCam.visible = trumpMaced.visible = true;

		// trump grimace sprite visible
		hilarious([
			[0.469, true],
			[0.048, false],
			[0.02, true],
			[0.107, false],
			[0.019, true],
			[0.048, false],
			[0.061, true],
			[0.067, false],
			[0.228, true],
			[0.049, false],
			[0.1, true],
			[0.056, false],
			[0.094, true],
			[0.133, false],
			[0.125, true],
			[0.282, false],
			[0.015, true],
			[0.156, false],
			[0.012, true],
			[0.043, false],
			[0.022, true],
			[0.089, false],
			[0.021, true],
			[0.045, false],
			[0.018, true],
			[0.025, false],
			[0.018, true],
			[0.114, false]
		]);
	});
}

var funny:Int = 0;
var times:Array<Float> = [];

function hilarious(stuff:Array<Dynamic>)
{
	if (times.length <= 1)
		for (i in 0...stuff.length)
			times.push(stuff[i][0]);

	new FlxTimer().start(times[funny], function(tmr:FlxTimer)
	{
		camHUD.visible = stuff[funny][1];
		funny++;

		if (funny == stuff.length)
			trace("DONE");
		else
			hilarious(stuff);
	});
}
