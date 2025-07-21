import flixel.FlxObject;
import flixel.sound.FlxSound;
import funkin.options.Options;
import funkin.backend.utils.NativeAPI;
import flixel.text.FlxTextBorderStyle;

importScript('data/scripts/HandyDandyFunctions');
var player:FlxSprite;
var timer:Float = 1;
var maxTimer:Float = 1;
var pipes:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var points:Int = 0;
var pointsText:FlxText;
var pressButtonTXT:FlxText;
var dead:Bool = false;
var gameStarted:Bool = false;
var lastPipePos:Float = 0;
var wall:FlxSprite;

function create() {
	FlxG.sound.playMusic(Paths.music('FlappyEag'), true, 1, true, 102);
	FlxG.sound.music.persist = true;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("minigames/flappyeag/bg"));
	bg.setGraphicSize(FlxG.width, FlxG.height);
	bg.updateHitbox();
	add(bg);

	add(pipes);

	player = new FlxSprite(200, FlxG.height / 2).loadGraphic(Paths.image("minigames/flappyeag/eag"));
	player.scale.set(-5, 5);
	player.maxVelocity.y = 2000;
	player.width *= 0.8;
	player.height *= 0.8;
	add(player);

	wall = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image("minigames/flappyeag/wall"));
	add(wall);

	pointsText = new FlxText(900, 16, 0, "Points: " + points, 16);
	pointsText.setFormat("fonts/fortnite.otf", 30, FlxColor.WHITE, "center");
	pointsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(pointsText);

	pressButtonTXT = new FlxText(16, 16, 500, "Press [" + CoolUtil.keyToString(Options.P1_ACCEPT[0]) + "] to jump.", 25);
	pressButtonTXT.setFormat("fonts/fortnite.otf", 25, FlxColor.WHITE, "center");
	pressButtonTXT.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(pressButtonTXT);

	youWonTXT = new FlxText(0, FlxG.height / 2 - 25, FlxG.width, "YOU WON.", 50);
	youWonTXT.setFormat("fonts/fortnite.otf", 50, FlxColor.WHITE, "center");
	youWonTXT.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	youWonTXT.visible = false;
	add(youWonTXT);

	youDiedTXT = new FlxText(0, FlxG.height / 2 - 25, FlxG.width, "YOU ARE DEAD.\npress R to restart\npress ESC to leave", 50);
	youDiedTXT.setFormat("fonts/fortnite.otf", 50, FlxColor.WHITE, "center");
	youDiedTXT.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	youDiedTXT.visible = false;
	add(youDiedTXT);
}

var uglySin:Float = 0;

function update(elapsed:Float) {
	var jump = controls.ACCEPT;
	if (jump && !dead) {
		if (!gameStarted) {
			gameStarted = true;
			player.acceleration.y = 1500;
		}

		player.velocity.y = -750;

		player.angle = -15;

		jumpSFX = FlxG.sound.load(Paths.sound("minigame/flappyeag/eagJump"), 5);
		jumpSFX.pitch = FlxG.random.float(0.9, 1.1);
		jumpSFX.play(true);
	}

	if (player.angle < 45 && gameStarted)
		player.angle += elapsed * 50;

	if (!gameStarted) {
		uglySin += elapsed * 5;
		player.y = FlxG.height / 2 + Math.sin(uglySin) * 16;
	} else
		pressButtonTXT.alpha -= elapsed * 5;

	pressButtonTXT.y = player.y - 30 - 50;

	if (!dead && gameStarted)
		timer -= elapsed;
	if (timer <= 0) {
		timer = maxTimer;
		createPipe((maxTimer > 0.65 ? FlxG.random.float(-180, 180) : lastPipePos + FlxG.random.float(-300, 300) * maxTimer));
	}

	for (i in pipes.members) {
		if (FlxG.overlap(player, i) && !dead) {
			if (i.ID == 0)
				die();

			if (i.ID == 1) {
				i.ID = 2;
				passPipe(i.y + 150);
			}
		}

		if (i.x < -100) {
			i.kill();
			i.destroy();
		}
	}

	if ((player.y < -player.height * 2 || player.y > FlxG.height + (player.height * 2)) && !dead)
		die();

	if (FlxG.overlap(player, wall) && !dead) {
		if (!FlxG.save.data.weirdRouteEnabled && !FlxG.save.data.launchCodesObtained) {
			NativeAPI.showMessageBox("Launch Codes", "741776\n921945\n9112001\n6181812\n12141799", 0x00000000);
			FlxG.save.data.launchCodesObtained = true;
		}
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('minigame/flappyeag/win'));

		wall.velocity.x = 0;
		die();
		youWonTXT.visible = true;
		youDiedTXT.visible = false;
	}

	if (dead) {
		pointsText.x = FlxMath.lerp(pointsText.x, FlxG.width / 2 - pointsText.width / 2, 0.05);
		pointsText.y = FlxMath.lerp(pointsText.y, FlxG.height / 2 + pointsText.height / 2 + 150, 0.05);
		pointsText.scale.set(FlxMath.lerp(pointsText.scale.x, 1.5, 0.01), FlxMath.lerp(pointsText.scale.y, 1.5, 0.01));
	}

	if (dead && FlxG.keys.justPressed.R)
		FlxG.switchState(new ModState('murica/minigame/FlappyEag'));

	if (dead && FlxG.keys.justPressed.ESCAPE) {
		FlxG.sound.music.stop();
		FlxG.switchState(new FreeplayState());
	}
}

var jumpSFX:FlxSound;

function jump() {
	player.velocity.y = -750;

	player.angle = -15;

	jumpSFX = FlxG.sound.load(Paths.sound("minigame/flappyeag/eagJump"), 5);
	jumpSFX.pitch = FlxG.random.float(0, 100);
	jumpSFX.play(true);

	trace("JUMP");
}

function die() {
	youDiedTXT.visible = true;
	player.angularVelocity = 2000 * (points / 10); // makes player spin like crazy
	FlxG.camera.shake(0.025, 0.5);
	FlxG.sound.play(Paths.sound("explosion_sfx"), 1);
	dead = true;
	pipes.forEachAlive(function(pipe:FlxSprite) {
		pipe.velocity.x = 0;
	});
}

var passPipeSFX:FlxSound;

function passPipe(y:Float = 0) {
	passPipeSFX = FlxG.sound.load(Paths.sound("minigame/flappyeag/eagPassPipe"), 5);
	passPipeSFX.pitch = FlxMath.lerp(1.25, 0.75, (y / FlxG.height));
	passPipeSFX.play(true);

	points += 1;
	pointsText.text = "Points: " + points;
	pointsText.scale.set(1.4, 1.4);
	FlxTween.tween(pointsText, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
	maxTimer -= maxTimer / 100;

	if (points >= 100) // 100
		wall.velocity.x = -500 / maxTimer;
}

function createPipe(cool:Float = 0) {
	if (cool > 180)
		cool = 180;
	if (cool < -180)
		cool = -180;
	lastPipePos = cool;

	var trigger = new FlxSprite(FlxG.width + 250 - (50 / 2), FlxG.height / 2 + cool - (400 / 2)).makeGraphic(50, 400, FlxColor.RED);
	trigger.offset.y = 0;
	trigger.velocity.x = -500 / maxTimer;
	trigger.ID = 1;
	trigger.visible = false;
	pipes.add(trigger);

	var pipe1 = new FlxSprite(FlxG.width + 200, FlxG.height / 2 + cool + 150).loadGraphic(Paths.image("minigames/flappyeag/piep"));
	pipe1.scale.set(-5, 20);
	pipe1.updateHitbox();
	pipe1.velocity.x = -500 / maxTimer;
	pipe1.ID = 0;
	pipe1.width *= 0.5;
	pipe1.height *= 0.9;
	pipes.add(pipe1);

	var pipe2 = new FlxSprite(FlxG.width + 200, FlxG.height / 2 + cool - 550).loadGraphic(Paths.image("minigames/flappyeag/piep"));
	pipe2.scale.set(-5, -20);
	pipe2.updateHitbox();
	pipe2.velocity.x = -500 / maxTimer;
	pipe2.ID = 0;
	pipe2.width *= 0.5;
	pipe2.height *= 0.9;
	pipes.add(pipe2);
}
