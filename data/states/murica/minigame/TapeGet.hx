import funkin.backend.utils.FunkinParentDisabler;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxGradient;
import flixel.sound.FlxSound;

importScript('data/scripts/HandyDandyFunctions');
var parentDisabler:FunkinParentDisabler;
var unlockTapeTxt:FlxText;
var tapeSpr:FlxSprite;
var shiny:FlxTypedGroup = new FlxTypedGroup();
var sparkles:FlxTypedGroup = new FlxTypedGroup();

function postCreate() {
	add(parentDisabler = new FunkinParentDisabler());

	this.data.onOpen != null ? this.data.onOpen() : null;

	var bg:FlxSprite = new FlxSprite();
	bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(bg);
	bg.alpha = 0.75;

	add(shiny);
	for (i in 0...8) {
		var shinyBG:FlxSprite = FlxGradient.createGradientFlxSprite(1, FlxG.height, !this.data.isTapeSecret ? [0x0, FlxColor.WHITE] : [0x0, 0xffffeea2]);
		shinyBG.scale.x = 360 / 4;
		shinyBG.updateHitbox();
		shinyBG.origin.y += shinyBG.height / 2 + shinyBG.width;
		shinyBG.angle += 360 / 8 * i;
		shinyBG.screenCenter(FlxAxes.XY);
		shinyBG.y -= FlxG.height - 200;
		shinyBG.alpha = 0;
		shiny.add(shinyBG);

		FlxTween.tween(shinyBG, {alpha: 0.6}, 1.75, {
			ease: FlxEase.quartOut,
			startDelay: 0.75
		});
	}

	tapeSpr = new FlxSprite(0, 850);
	tapeSpr.loadGraphic(Paths.image('minigames/VHSTAPE_' + (this.data.isTapeSecret ? 'secret' : 'normal')));
	tapeSpr.scale.set(0.4, 0.4);
	tapeSpr.updateHitbox();
	tapeSpr.screenCenter(FlxAxes.X);
	add(tapeSpr);

	if (this.data.isTapeSecret)
		FlxG.sound.play(Paths.sound('minigame/whytfdomydogwalksidewaysboy'));

	add(sparkles);
	var sparkleCount:Float = (this.data.isTapeSecret ? 9 : 3);
	for (i in 0...sparkleCount) {
		var spark:Sparkle = new Sparkle();
		if(this.data.isTapeSecret)
			spark.color = 0xfffdf7bc;
		sparkles.add(spark);
	}

	unlockTapeTxt = new FlxText(0, 425, 0, "You Got A Tape");
	unlockTapeTxt.text = (this.data.isTapeSecret ? "You Got A SECRET Tape!" : "You Got A Tape!");
	unlockTapeTxt.setFormat("fonts/THE PRESIDENT.ttf", 65, FlxColor.WHITE, "center");
	unlockTapeTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	unlockTapeTxt.borderSize = 3;
	unlockTapeTxt.screenCenter(FlxAxes.X);
	add(unlockTapeTxt);
	unlockTapeTxt.visible = false;

	FlxTween.tween(tapeSpr, {y: 100}, 1.75, {
		ease: FlxEase.quartOut,
		onComplete: function(twn:FlxTween) {
			new FlxTimer().start(1.2, function(tmr:FlxTimer) {
				unlockTapeTxt.visible = true;
				new FlxTimer().start(1.75, function(tmr:FlxTimer) {
					closeThis();
				});
			});
		}
	});
}

function update(elapsed:Float) {
	for (i in shiny)
		i.angle += elapsed * 90;
	for (i in sparkles)
		i.update(elapsed);
}

function closeThis() {
	this.data.onClose != null ? this.data.onClose() : null;
	close();
}

class Sparkle extends FlxSprite { //TO FIX
	public var timer:Float = 1;

	public function new() {
		super(0, 0, null);
		loadGraphic(Paths.image('minigames/sparkle'), true, 48, 48);
		animation.add('idle', [0, 1, 2, 3], 4, false);
		animation.play('idle', true);
		antialiasing = false;

		alpha = 0;
		timer = FlxG.random.float(0.05, 1.0);
	}

	public function update(elapsed:Float) {
		super.update(elapsed);
		timer -= elapsed;
		if (animation.curAnim.finished)
			alpha = 0;
		if (timer <= 0 && alpha == 0)
			play();
	}

	public function play() {
		timer = FlxG.random.float(1.0, 2.5);

		alpha = 1.0;
		animation.play('idle', true);
		x = tapeSpr.x + FlxG.random.float(0, tapeSpr.width);
		y = tapeSpr.y + FlxG.random.float(0, tapeSpr.height);

		var scaleCustom = FlxG.random.float(1.0, 2.0);
		scale.set(scaleCustom, scaleCustom);
		var sparkle:FlxSound;
		sparkle = FlxG.sound.load(Paths.sound("minigame/sparkle"), 0.1);
		sparkle.pitch = FlxG.random.float(0.75, 1.25);
		sparkle.play(true);
	}
}
