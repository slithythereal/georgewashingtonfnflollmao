import funkin.backend.utils.FunkinParentDisabler;
import flixel.text.FlxTextBorderStyle;

importScript('data/scripts/HandyDandyFunctions');
var parentDisabler:FunkinParentDisabler;
var unlockTapeTxt:FlxText;
var tapeSpr:FlxSprite;

function postCreate() {
	add(parentDisabler = new FunkinParentDisabler());

	this.data.onOpen != null ? this.data.onOpen() : null;

	var bg:FlxSprite = new FlxSprite();
	bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(bg);
	bg.alpha = 0.75;

	tapeSpr = new FlxSprite(0, 750);
	tapeSpr.loadGraphic(Paths.image('minigames/VHSTAPE_' + (this.data.isTapeSecret ? 'secret' : 'normal')));
	tapeSpr.scale.set(0.4, 0.4);
	tapeSpr.updateHitbox();
	tapeSpr.screenCenter(FlxAxes.X);
	add(tapeSpr);

	if(this.data.isTapeSecret)
		FlxG.sound.play(Paths.sound('minigame/whytfdomydogwalksidewaysboy'));


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

function closeThis() {
	this.data.onClose != null ? this.data.onClose() : null;
	close();
}
