import flixel.FlxObject;
import flixel.sound.FlxSound;
import funkin.options.Options;
import funkin.backend.utils.NativeAPI;
import flixel.text.FlxTextBorderStyle;

importScript('data/scripts/HandyDandyFunctions');
var player:Player;
var timer:Float = 1;
var maxTimer:Float = 1;
var pipes:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var points:Int = 0;
final pointsCap:Int = 100; // 100
var pointsText:FlxText;
var pressButtonTXT:FlxText;
var dead:Bool = false;
var gameStarted:Bool = false;
var lastPipePos:Float = 0;
var wall:FlxSprite;
var explosion:FlxSprite;

function create() {
	FlxG.sound.playMusic(Paths.music('FlappyEag'), true, 1, true, 102);
	FlxG.sound.music.persist = true;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("minigames/flappyeag/bg"));
	bg.setGraphicSize(FlxG.width, FlxG.height);
	bg.updateHitbox();
	add(bg);

	add(pipes);
	
	wall = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image("minigames/flappyeag/wall"));
	add(wall);

	player = new Player(200, FlxG.height / 2);
	add(player);

	explosion = new FlxSprite(-150, -150);
	explosion.frames = Paths.getFrames("stages/dnc/explosion");
	explosion.animation.addByPrefix("explode", "explosion_sfx", 24, false);
	add(explosion);

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

function update(elapsed:Float) {
	var jump = controls.ACCEPT;
	if (jump && !dead) {
		if (!gameStarted)
		{
			gameStarted = true;
			player.gameStarted = true;
		}
		player.jump();
	}

	if (gameStarted && pressButtonTXT.alpha > 0)
		pressButtonTXT.alpha -= elapsed * 5;

	pressButtonTXT.y = player.y - 30 - 50;

	if (!dead && gameStarted)
		timer -= elapsed;
	if (timer <= 0) {
		timer = maxTimer;
		createPipe((lastPipePos + FlxG.random.float(-180, 180) * maxTimer));
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
		NativeAPI.showMessageBox("Launch Codes", "741776", 0x00000000); // will have if statement tied to save data variable (wip)
		FlxG.sound.play(Paths.sound('minigame/flappyeag/win'), 1.5);

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
		FlxG.switchState(new MainMenuState());
	}
}

function die() {
	youDiedTXT.visible = true;
	dead = true;
	player.killBird(points);
	explosion.setPosition(player.x - explosion.width/2, player.y - explosion.height/2);
	explosion.animation.play("explode");
	pipes.forEachAlive(function(pipe:FlxSprite) {
		pipe.velocity.x = 0;
	});
	FlxG.sound.music.stop();
	FlxG.timeScale = 0.000001;
	FlxG.camera.flash(0x81ffffff, 0.5);
	new FlxTimer().start(0.000001 * 0.1 / maxTimer, ()->{ FlxG.timeScale = 1.0; FlxG.camera.shake(0.025, 0.5); });
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
}

function createPipe(cool:Float = 0) {
	if (points >= pointsCap - 2)
	{
		wall.velocity.x = -500 / maxTimer; return;
	}

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

class Player extends FlxSprite
{
	public var gameStarted:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();
		loadGraphic(Paths.image("minigames/flappyeag/eag"));
		scale.set(-5, 5);
		maxVelocity.y = 2000;
		width *= 0.8;
		height *= 0.8;
	}

	public var uglySin:Float = 0;
	public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (gameStarted)
		{
			if (velocity > 0)
				acceleration.y = 5000;
			else if (velocity < 0)
				acceleration.y = 2000;
		}

		if (angle < 45 && gameStarted)
			angle += elapsed * 50;

		if (!gameStarted)
		{
			uglySin += elapsed * 5;
			y = FlxG.height / 2 + Math.sin(uglySin) * 16;
		} 
	}

	public var jumpSFX:FlxSound;
	public function jump() {
		acceleration.y = 2000;
		velocity.y = -825;

		angle = -15;

		jumpSFX = FlxG.sound.load(Paths.sound("minigame/flappyeag/eagJump"), 5);
		jumpSFX.pitch = FlxG.random.float(0.9, 1.1);
		jumpSFX.play(true);
	}

	public function killBird(points:Int)
	{
		angularVelocity = 2000 * (points / 10); // makes player spin like crazy
		FlxG.sound.play(Paths.sound("explosion_sfx"), 1);
		velocity.y = 0;
	}
}