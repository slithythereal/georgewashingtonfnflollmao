import funkin.game.PlayState;
import flixel.sound.FlxSound;

importScript('data/scripts/HandyDandyFunctions');
function create() {
	camHUD.visible = false;
	camGame.visible = false;
	boyfriend.gameOverCharacter = 'kilodeath';
	lossSFX = 'gameover/kilometergameover';
}

var ufo:FlxSprite;

function postCreate() {
	ufo = new FlxSprite(-5000, -120);
	ufo.loadGraphic(Paths.image('stages/kilometer/ufo'));
	ufo.scale.set(0.65, 0.65);
	ufo.updateHitbox();
	ufo.angle = -25;
	add(ufo);
}

function onStartCountdown(event) {
	if (PlayState.isStoryMode) {
		event.cancel(true);
		startSong();
		startedCountdown = true;
		if (startTimer == null)
			startTimer = new FlxTimer();
	}
}

function onGameOver() {
	if (!camGame.visible)
		camGame.visible = true;
}

function transitionTOBG(param1:String, param2:String) {
	var oldBG:String = '';
	var newBG:String = '';
	oldBG = param1;
	newBG = param2;
	FlxTween.tween(camGame, {zoom: 0.8}, 0.6155, {
		ease: FlxEase.quadIn,
		onComplete: function(tmr:FlxTimer) {
			FlxTween.tween(camGame, {zoom: 0.4}, 0.6155, {ease: FlxEase.sineOut});
		}
	});
	FlxTween.tween(stage.stageSprites['mountain'], {x: -5000}, 1.75, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			stage.stageSprites['mountain'].x = 5000;
		}
	});
	new FlxTimer().start(0.62, function(tmr:FlxTimer) {
		stage.stageSprites[oldBG].visible = false;
		stage.stageSprites[oldBG].velocity.x = 0;
		stage.stageSprites[newBG].visible = true;
		stage.stageSprites[newBG].velocity.x = -60;
	});
}

function funnyEvent(param1:String) {
	var event:String = '';
	event = param1;
	switch (event) {
		case "togglecamvis":
			camHUD.visible = true;
			camGame.visible = true;
		case "zad":
			FlxTween.tween(stage.stageSprites['superbowl arena'], {alpha: 0.001}, 0.5, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween) {
					stage.stageSprites['superbowl arena'].visible = false;
					stage.stageSprites['superbowl arena'].alpha = 1;
				}
			});
		case "notzad":
			stage.stageSprites['murica'].visible = true;
		case "fallingvid":
			VideoHandler.playNext();
		case 'ufo':
			FlxTween.tween(ufo, {x: 5000}, 1.75, {ease: FlxEase.linear});
	}
}

function onSongEnd() {
	if (PlayState.isStoryMode) {
		trace("unlocked freeplaylandia (WINNER!!!)");
		if (!FlxG.save.data.freeplayUnlockedGW)
			FlxG.save.data.freeplayUnlockedGW = true;
		if (!FlxG.save.data.mailUnlocked)
			FlxG.save.data.mailUnlocked = true;
		FlxG.save.flush();
		HandyDandy.saveMailData("potus", "eag", false, "Letter from George Washington");
	}
}

function firework() {
	stage.stageSprites["firework"].alpha = 0;
	var firework:FlxSprite = new FlxSprite(FlxG.random.float(-FlxG.width, FlxG.width * 2),
		FlxG.height * 1.2).loadGraphic(Paths.image("stages/kilometer/firework"));
	firework.scale.set(0.2, 0.2);
	firework.scrollFactor.set(0.4, 0.4);
	firework.updateHitbox();
	firework.acceleration.y = 600;
	firework.velocity.y = -FlxG.random.float(800, 1600);
	firework.color = FlxG.random.color(FlxColor.WHITE, FlxColor.BLACK, null, false);
	insert(members.indexOf(stage.stageSprites["firework"]), firework);
	new FlxTimer().start(FlxG.random.float(0.8, 1.2), function(tmr:FlxTimer) {
		var fireSound:FlxSound;
		fireSound = FlxG.sound.load(Paths.sound('firework'), 0.7);
		fireSound.pitch = FlxG.random.float(0.75, 1.5);
		fireSound.play(true);
		firework.acceleration.y = 0;
		firework.velocity.y = 200;
		firework.scale.set(3, 3);
		FlxTween.tween(firework, {alpha: 0}, 2, {
			ease: FlxEase.linear,
			startDelay: FlxG.random.float(1.0, 2.25),
			onComplete: function(twn:FlxTween) {
				firework.destroy();
				firework.kill();
			}
		});
	});
}
