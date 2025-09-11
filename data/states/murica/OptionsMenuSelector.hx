import funkin.game.PlayState;
import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import flixel.text.FlxTextBorderStyle;
import hxvlc.flixel.FlxVideoSprite;
import funkin.options.OptionsMenu;
import flixel.effects.FlxFlicker;

importScript('data/scripts/HandyDandyFunctions');
importScript('data/scripts/Translation');
/*
 * TODO
 * add export save data xml option
 */
var options:Array<String> = ['Subtitles', 'Show Warning Screen', 'Engine Options', 'Reset Save Data', 'Back'];
var curOptionSelected:Int = 0;
var newOption:Int;
var optionTxtGrp:FlxTypedGroup<FlxText>;
var daCurCountry:String = 'america';
var otherCountry:String = 'brazil';
var canPress:Bool = true;

var optionStuff = [
	"Back" => {
		func: function() {
			FlxG.switchState(new MainMenuState());
		},
		desc: returnTrans('backoptdesc', curLang),
		displayTxt: returnTrans('back', curLang)
	},
	"Engine Options" => {
		func: function() {
			FlxG.switchState(new OptionsMenu());
		},
		desc: returnTrans('engoptdesc', curLang),
		displayTxt: returnTrans('engineoptions', curLang)
	},
	"Subtitles" => {func: function() {
		FlxG.save.data.subtitlesGW = !FlxG.save.data.subtitlesGW;
		var boolT:Bool = FlxG.save.data.subtitlesGW;
		var description = returnTrans('subtdesc', curLang) + '\n' + returnTrans('subtitles', curLang) + ": " + returnONOFF(boolT, curLang);

		var display = returnTrans('subtitles', curLang) + ": " + returnONOFF(boolT, curLang);
		toggleSetting(curOptionSelected, description, display);
	},
		desc: returnTrans('subtdesc', curLang)
		+ '\n'
		+ returnTrans('subtitles', curLang)
		+ ": "
		+ returnONOFF(FlxG.save.data.subtitlesGW, curLang),
		displayTxt: returnTrans('subtitles', curLang) + ": " + returnONOFF(FlxG.save.data.subtitlesGW, curLang)
	},
	"Show Warning Screen" => {func: function() {
		FlxG.save.data.showGWWarning = !FlxG.save.data.showGWWarning;
		var boolT:Bool = FlxG.save.data.showGWWarning;
		var description = returnTrans('warningscreendesc', curLang)
			+ "\n"
			+ returnTrans('warningscreen', curLang)
			+ ": "
			+ returnONOFF(boolT, curLang);

		var display = returnTrans('warningscreen', curLang) + ": " + returnONOFF(FlxG.save.data.showGWWarning, curLang);
		toggleSetting(curOptionSelected, description, display);
	},
		desc: returnTrans('warningscreendesc', curLang)
		+ "\n"
		+ returnTrans('warningscreen', curLang)
		+ ": "
		+ returnONOFF(FlxG.save.data.showGWWarning, curLang),
		displayTxt: returnTrans('warningscreen', curLang) + ": " + returnONOFF(FlxG.save.data.showGWWarning, curLang)
	},
	"Reset Save Data" => {
		func: function() {
			openSubState(new ModSubState('murica/options/ResetSaveDataWarning', {
				onOpen: function() {
					canPress = false;
				},
				onClose: function() {
					canPress = true;
				}
			}));
		},
		desc: returnTrans('rsaved_l', curLang),
		displayTxt: returnTrans('rsaved_C', curLang)
	}
];

var brazilRead:Bool = false;
var countryVid:Map<String, FlxVideoSprite> = [];
var constructionPres:FlxSprite;
var hammer1, hammer2:FlxSprite;
var descBox:FlxSprite;
var descTxt:FlxText;
var descBoxVisible:Bool = false;
var flag:FlxSprite;
var blackBG:FlxSprite;

function create() {
	loadData();

	FlxG.mouse.visible = true;
	var bg:FlxSprite = new FlxSprite(0, 0);
	bg.loadGraphic(Paths.image('menus/options/' + daCurCountry + '/bg'));
	bg.screenCenter();
	add(bg);

	constructionPres = new FlxSprite(620, 35);
	constructionPres.frames = Paths.getFrames('menus/options/' + daCurCountry + '/mechanic');
	constructionPres.animation.addByPrefix('anim', 'anim', 24);
	constructionPres.scale.set(0.8, 0.8);
	constructionPres.updateHitbox();
	constructionPres.animation.play('anim');
	add(constructionPres);

	optionTxtGrp = new FlxTypedGroup();
	add(optionTxtGrp);
	for (i => option in options) {
		var txt:FlxText = new FlxText(75, (i * 100) + 50);
		txt.text = optionStuff[options[i]].displayTxt.toUpperCase();
		txt.setFormat("fonts/Robot Socialista.ttf", 45, FlxColor.WHITE, "center");
		txt.ID = i;
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		txt.borderSize = 2;
		optionTxtGrp.add(txt);
	}

	hammer1 = new FlxSprite();
	hammer2 = new FlxSprite();
	for (i in [hammer1, hammer2]) {
		i.frames = Paths.getFrames('menus/options/hammer');
		i.animation.addByPrefix('idle', 'hammer', 24);
		i.scale.set(0.35, 0.35);
		i.updateHitbox();
		i.animation.play('idle');
	}
	add(hammer1);
	add(hammer2);

	if (brazilRead) {
		flag = new FlxSprite(25, 625);
		flag.loadGraphic(Paths.image('menus/options/' + otherCountry + '/flag'));
		flag.scale.set(0.075, 0.1);
		flag.updateHitbox();
		add(flag);
	}

	var descInfo:FlxText = new FlxText(FlxG.width - 375, 22, 344, returnTrans('tabpress', curLang));
	descInfo.setFormat(null, 15, FlxColor.WHITE, "right");
	descInfo.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	descInfo.borderSize = 2;
	descInfo.alpha = 0.5;
	add(descInfo);

	descBox = new FlxSprite();
	descBox.makeGraphic(1, 1, FlxColor.BLACK);
	descBox.alpha = 0.6;
	descBox.visible = descBoxVisible;
	add(descBox);

	descTxt = new FlxText(80, 600, 500, "", 32);
	descTxt.setFormat("fonts/THE PRESIDENT.ttf", 32, FlxColor.WHITE, "center");
	descTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	descTxt.scrollFactor.set();
	descTxt.borderSize = 2.4;
	descTxt.alpha = 0.75;
	descTxt.visible = descBoxVisible;
	add(descTxt);

	blackBG = new FlxSprite();
	blackBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	add(blackBG);
	blackBG.visible = false;

	if (brazilRead) {
		for (i in ["america", "brazil"]) {
			var spr:FlxVideoSprite = new FlxVideoSprite();
			spr.load(Assets.getPath(Paths.video('countrytransitions/' + i)));
			spr.bitmap.onFormatSetup.add(function() {
				blackBG.visible = true;
				spr.setGraphicSize(FlxG.width, FlxG.height);
				spr.screenCenter();
			});
			spr.bitmap.onEndReached.add(function() {
				spr.bitmap.dispose();
				remove(spr);
				FlxG.save.data.curCountry = otherCountry;
				setCurLang();
				FlxG.save.flush();
				FlxG.switchState(new MainMenuState());
			});
			countryVid.set(i, spr);
		}
	}
	changeSetting(0);
}

function changeSetting(cool:Int) {
	curOptionSelected += cool;
	if (curOptionSelected >= options.length)
		curOptionSelected = 0;
	if (curOptionSelected < 0)
		curOptionSelected = options.length - 1;

	changeDescTxt(optionStuff[options[curOptionSelected]].desc);
}

function update(elapsed:Float) {
	if (canPress) {
		if (controls.BACK)
			optionStuff['Back'].func();
		if (controls.SWITCHMOD)
			toggleDescBox();
		if (controls.UP_P)
			changeSetting(-1);
		if (controls.DOWN_P)
			changeSetting(1);
		if (controls.ACCEPT)
			optionStuff[options[curOptionSelected]].func();
		optionTxtGrp.forEach(function(i:FlxText) {
			if (FlxG.mouse.overlaps(i)) {
				if (newOption != i.ID) {
					curOptionSelected = newOption = i.ID;
					changeDescTxt(optionStuff[options[curOptionSelected]].desc);
				}

				if (FlxG.mouse.justPressed)
					optionStuff[options[curOptionSelected]].func();
			}
		});
		if (brazilRead) {
			if (FlxG.mouse.overlaps(flag)) {
				flag.scale.set(0.1, 0.15);
				if (FlxG.mouse.justPressed) {
					canPress = false;
					countryVid[otherCountry].play();
					add(countryVid[otherCountry]);
				}
			} else
				flag.scale.set(0.075, 0.1);
		}
	}
}

function loadData() {
	brazilRead = (FlxG.save.data.mailRead.contains("brazil"));
	if (brazilRead && FlxG.save.data.curCountry == 'brazil') {
		daCurCountry = 'brazil';
		otherCountry = 'america';
	} else {
		daCurCountry = 'america';
		otherCountry = 'brazil';
	}
}

function changeDescTxt(newTxt:String) {
	descTxt.text = newTxt;
	descTxt.screenCenter(FlxAxes.X);
	descBox.setPosition(descTxt.x - 10, descTxt.y - 10);
	descBox.setGraphicSize(Std.int(descTxt.width + 20), Std.int(descTxt.height + 25));
	descBox.updateHitbox();
	optionTxtGrp.forEach(function(i:FlxText) {
		if (i.ID == curOptionSelected) {
			hammer1.setPosition(i.x - 90, i.y - 25);
			hammer2.setPosition(i.width + 50, i.y - 25);
		}
	});
}

function toggleDescBox() {
	descBoxVisible = !descBoxVisible;
	descTxt.visible = descBox.visible = descBoxVisible;
}

function toggleSetting(id:Int, newTxt:String, displayTxt:String) {
	FlxG.sound.play(Paths.sound('menu/confirm'));

	optionStuff[options[curOptionSelected]].desc = newTxt;
	changeDescTxt(optionStuff[options[curOptionSelected]].desc);
	FlxG.save.flush();

	optionTxtGrp.forEach(function(i:FlxText) {
		if (i.ID == id) {
			i.text = displayTxt;
			FlxFlicker.flicker(i, 1, 0.06);
		}
	});
}
