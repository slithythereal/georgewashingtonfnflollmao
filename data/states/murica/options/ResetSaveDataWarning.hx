import funkin.backend.utils.FunkinParentDisabler;
import funkin.backend.utils.NativeAPI;
import flixel.text.FlxTextBorderStyle;

importScript('data/scripts/Translation');
importScript('data/scripts/HandyDandyFunctions');
var parentDisabler:FunkinParentDisabler;
var yesButton:FlxText;
var noButton:FlxText;

function postCreate() {
	add(parentDisabler = new FunkinParentDisabler());

	this.data.onOpen != null ? this.data.onOpen() : null;

	var bg:FlxSprite = new FlxSprite();
	bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(bg);
	bg.alpha = 0.75;

	var txt:FlxText = new FlxText(0, 50, FlxG.width - 250);
	txt.text = returnTrans('rsd_1', curLang) + '\n' + returnTrans('rsd_2', curLang) + '\n' + returnTrans('rsd_3', curLang) + '\n'
		+ returnTrans('rsd_4', curLang);
	txt.setFormat(Paths.font('VCR.ttf'), 55, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFFFF0000);
	txt.borderSize = 4;
	txt.screenCenter(FlxAxes.X);
	add(txt);

	yesButton = new FlxText(0, 425);
	yesButton.text = returnTrans('yes_C', curLang);
	yesButton.setFormat(Paths.font('VCR.ttf'), 45, 0xFFffff, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	yesButton.borderSize = 4;
	yesButton.screenCenter(FlxAxes.X);
	add(yesButton);

	noButton = new FlxText(0, 500);
	noButton.text = returnTrans('no_C', curLang);
	noButton.setFormat(Paths.font('VCR.ttf'), 45, 0xFFffff, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	noButton.borderSize = 4;
	noButton.screenCenter(FlxAxes.X);
	add(noButton);
}

function postUpdate(elapsed:Float) {
	if (FlxG.mouse.overlaps(yesButton)) {
		yesButton.scale.set(1.2, 1.2);
		if (FlxG.mouse.justPressed) {
			if (FlxG.keys.pressed.SHIFT && FlxG.save.data.weirdRouteEnabled) {
				HandyDandy.antiNuke();
				NativeAPI.showMessageBox("NUCLEAR", "Error (vs george washington):\nSave Data COMPLETE RESET: Wiping 100% Nuclear data.", 0xFF000000);
			} else
				NativeAPI.showMessageBox("Vs George Washington", "Save Data RESET.\nGood Luck!", 0x00000000);
			HandyDandy.resetSaveData();
		}
	} else
		yesButton.scale.set(1, 1);

	if (FlxG.mouse.overlaps(noButton)) {
		noButton.scale.set(1.2, 1.2);
		if (FlxG.mouse.justPressed)
			closeThis();
	} else
		noButton.scale.set(1, 1);
	if (controls.BACK)
		closeThis();
}

function closeThis() {
	this.data.onClose != null ? this.data.onClose() : null;
	close();
}
