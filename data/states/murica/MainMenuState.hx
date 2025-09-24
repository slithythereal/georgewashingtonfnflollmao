import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.MusicBeatState;
import flixel.effects.FlxFlicker;
import funkin.game.Character;
import funkin.game.PlayState;
import funkin.backend.utils.WindowUtils;
import Sys;
import funkin.backend.assets.ModsFolder;

importScript("data/scripts/HandyDandyFunctions");
importScript("data/scripts/MailUtil");
importScript('data/scripts/Translation');
var options:Array<String> = [];
var menuItems:FlxTypedGroup<FlxSprite>;
var textGrp:FlxTypedGroup<FlxText>;
var curSelected:Int = curMainMenuSelected;
public static var initialized:Bool = false;
var newOption:Int;

// decor
var playIcon, mailTruck, eagle, bg:FlxSprite;
var eagleYArray:Array<Float> = [-35, 70, 250, 450];
var brazilON, eagleActive, eagleON, mailUnlocked, selectedSomethin, mailSelected, isMailHovered, isNight, whiteHouseUnlocked, isWHHovered:Bool = false;
var mailbox, whiteHouseIcon:Character;

function create() {
	loadData();
	window.title = (brazilON ? "BEM-VINDO AO BRASIL!" : "WHAT'S A KILOMETER");

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/brazil' : 'menus/mainmenu/murica flag')));
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	playIcon = new FlxSprite();
	playIcon.loadGraphic(Paths.image('menus/mainmenu/playicons/icon_' + options[curSelected]));
	add(playIcon);
	playIcon.visible = false;

	menuItems = new FlxTypedGroup();
	add(menuItems);

	textGrp = new FlxTypedGroup();
	add(textGrp);

	for (i => option in options) {
		var menuItem:FlxSprite = new FlxSprite();
		menuItem.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/brazil' : 'menus/mainmenu/murica flag')));
		menuItem.scale.set(0.25, 0.15);
		menuItem.ID = i;
		menuItem.updateHitbox();
		menuItem.setPosition(0, ((menuItem.ID = i) * 175) + 25);
		menuItem.screenCenter(FlxAxes.X);
		menuItem.antialiasing = true;
		menuItems.add(menuItem);

		var txt:FlxText = new FlxText();
		txt.text = returnTrans(options[i].toLowerCase() + "_C", curLang);
		txt.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
		txt.ID = i;
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		txt.borderSize = 2;
		txt.setPosition(menuItem.x, menuItem.y + 50);
		txt.screenCenter(FlxAxes.X);
		textGrp.add(txt);
	}

	if (mailUnlocked) { // mailbox unlocked when beating the week
		mailTruck = new FlxSprite(10000, 260); // 726
		mailTruck.loadGraphic(Paths.image("menus/mainmenu/uspstruck"));
		mailTruck.scale.set(1, 1);
		mailTruck.updateHitbox();
		add(mailTruck);

		if (FlxG.save.data.mailInTruck.length >= 1)
			truckDriveBy();

		mailbox = new Character(1050, 450, "other/mailbox", false);
		mailbox.scale.set(0.25, 0.75);
		mailbox.updateHitbox();
		mailbox.scale.set(0.75, 0.75);
		mailbox.origin.set(-200, 0);
		add(mailbox);
		mailbox.playAnim("closedFR", false, null);
	}

	if (whiteHouseUnlocked && !brazilON) {
		whiteHouseIcon = new Character(90, 550, "other/whitehouseicon", false);
		whiteHouseIcon.scale.set(0.30, 0.25);
		whiteHouseIcon.updateHitbox();
		whiteHouseIcon.scale.set(0.7, 0.7);
		whiteHouseIcon.origin.set(-300, -1000);
		add(whiteHouseIcon);
		whiteHouseIcon.playAnim("idle-day", false, null); // in the future, will change depending on day or night
		if (!FlxG.save.data.whiteHouseRisen)
			whiteHouseRise();
	}

	// eagle
	eagle = new FlxSprite(0, -1000);
	eagle.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/toucan' : 'menus/mainmenu/eagle')));
	eagle.scale.set(0.75, 0.75);
	eagle.updateHitbox();
	add(eagle);

	changeOption(0);
}

function update(elapsed:Float) {
	if (!selectedSomethin) {
		if (FlxG.keys.justPressed.Q) { // TO REMOVE
			FlxG.switchState(new ModState("murica/NewWhiteHouse"));
		}

		if (FlxG.keys.justPressed.SEVEN) {
			persistentUpdate = !(persistentDraw = true);
			openSubState(new EditorPicker());
		}
		if (controls.SWITCHMOD) {
			openSubState(new ModSwitchMenu());
			persistentUpdate = !(persistentDraw = true);
		}

		if (controls.UP_P)
			changeOption(-1);
		if (controls.DOWN_P)
			changeOption(1);

		if (controls.ACCEPT)
			transitionState(options[curSelected]);

		// TO REMOVE
		if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new ModState("murica/DebugSongSelectorState"));

		// eagle
		if (eagleON) {
			if (FlxG.random.int(1, 750) == 1 && !eagleActive)
				activateEagle();

			if (eagleActive && FlxG.mouse.overlaps(eagle) && FlxG.mouse.justPressed) {
				if (brazilON)
					toucanPressed();
				else
					eaglePressed();
			}
		}

		textGrp.forEach(function(txt:FlxText) {
			if (FlxG.mouse.overlaps(txt)) {
				if (newOption != txt.ID) {
					newOption = txt.ID;
					curSelected = txt.ID;
					changeOptionEtc();
				}
				if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(eagle))
					transitionState(options[curSelected]);
			}
		});

		// mail
		if (mailUnlocked) {
			if (FlxG.mouse.overlaps(mailbox)) {
				if (!isMailHovered) {
					isMailHovered = true;
					mailbox.playAnim("open");
					FlxG.sound.play(Paths.sound("ui/mailboxopen"));
				}
				if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(eagle)) {
					selectedSomethin = true;
					FlxG.switchState(new ModState("murica/MailboxState"));
				}
			} else {
				if (isMailHovered) {
					isMailHovered = false;
					mailbox.playAnim("close");
					FlxG.sound.play(Paths.sound("ui/mailboxclose"));
				}
			}
		}

		// white house
		if (whiteHouseUnlocked && !brazilON) {
			if (FlxG.mouse.overlaps(whiteHouseIcon)) {
				if (!isWHHovered) {
					isWHHovered = true;
					whiteHouseIcon.playAnim("hover-day"); // will change depending on day/night
				}
				if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(eagle))
					whiteHouseStart();
			} else {
				if (isWHHovered) {
					isWHHovered = false;
					whiteHouseIcon.playAnim("idle-day");
				}
			}
		}
	}
}

function changeOption(cool:Int) {
	curSelected += cool;
	if (curSelected >= options.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = options.length - 1;

	curMainMenuSelected = curSelected;

	changeOptionEtc();
}

function changeOptionEtc() {
	FlxG.sound.play(Paths.sound('menu/scroll'));

	menuItems.forEach(function(spr:FlxSprite) {
		spr.scale.set((spr.ID == curSelected ? 0.35 : 0.25), 0.15);
	});
	textGrp.forEach(function(txt:FlxText) {
		txt.size = (txt.ID == curSelected ? 50 : 25);
		txt.borderColor = (txt.ID == curSelected ? (brazilON ? FlxColor.GREEN : FlxColor.RED) : FlxColor.BLACK);
		txt.borderSize = (txt.ID == curSelected ? 4.5 : 3);
		txt.screenCenter(FlxAxes.X);
	});
	var path:String = (brazilON ? 'menus/mainmenu/brazil/playicons/icon_' + options[curSelected] : 'menus/mainmenu/playicons/icon_' + options[curSelected]);
	playIcon.loadGraphic(Paths.image(path));
}

function transitionState(state:String) {
	FlxG.mouse.visible = false;
	selectedSomethin = true;
	FlxG.sound.play(Paths.sound('menu/confirm'));

	playIcon.visible = true;

	if (mailUnlocked)
		FlxTween.tween(mailbox, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
	if (whiteHouseUnlocked && !brazilON)
		FlxTween.tween(whiteHouseIcon, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});

	menuItems.forEach(function(spr:FlxSprite) { // tweens sprites and flickers chosen menuitem
		if (curSelected != spr.ID) {
			FlxTween.tween(spr, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					spr.destroy();
				}
			});
		} else {
			FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
				spr.destroy();
				loadState(state);
			});
		}
	});
	textGrp.forEach(function(txt:FlxText) { // same thing for text lol
		if (curSelected != txt.ID) {
			FlxTween.tween(txt, {x: (FlxG.random.int(1, 2) == 1) ? -1000 : 1500}, 0.4, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween) {
					txt.destroy();
				}
			});
		} else {
			FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker) {
				txt.destroy();
				loadState(state);
			});
		}
	});
}

function loadState(state:String) {
	switch (state) {
		case 'play':
			if (brazilON)
				HandyDandy.loadWeek(['negotiations'], 'dom week', 'dom');
			else
				HandyDandy.loadWeek(['patriot', 'god-and-country', 'kilometer'], 'George Week', 'georgeW1');
		case 'freeplaylandia':
			FlxG.switchState(new FreeplayState());
		case 'options':
			FlxG.switchState(new ModState('murica/OptionsMenuSelector'));
		case "credits":
			FlxG.switchState(new ModState("murica/Credits"));
		default:
			selectedSomethin = false;
			trace("no menu here lol");
			FlxG.switchState(new MainMenuState()); // reloads menustate for null option
	}
}

function loadData() {
	FlxG.mouse.visible = true;

	// lots of save data transferring going on here
	HandyDandy.saveDataUpdate();

	brazilON = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.curCountry == 'brazil');

	DiscordUtil.changePresence("Most american menu i've ever seen", "Main Menu");
	trace("brazil on: " + brazilON);

	HandyDandy.playMenuSong(FlxG.save.data.curCountry);

	if (!initialized)
		initialized = true;

	mailUnlocked = FlxG.save.data.mailUnlocked;
	whiteHouseUnlocked = (FlxG.save.data.mailRead.contains("whitehouse") ? true : false);

	var birdMailID:String = (brazilON ? "toucan" : "potus");
	eagleON = (FlxG.save.data.mailRead.contains(birdMailID) ? true : false);

	options.push('play');
	if (FlxG.save.data.freeplayUnlockedGW)
		options.push('freeplaylandia');
	options.push('options');
	options.push('credits');

	FlxG.console.registerFunction('unlockmail', function(mail:String) {
		if (allMail.contains(mail)) {
			HandyDandy.saveMailData(mail, allMailEver[mail].letterID, false, allMailEver[mail].desc);
			truckDriveBy();
			trace('unlocked ' + mail);
		} else
			trace('mail does not exist');
	});

	setCurLang();

	FlxG.console.registerFunction('unlockallmail', function() {
		MailUtil.unlockALLMAIL();
	});
	FlxG.console.registerFunction('giveMail', function(mail:String) {
		MailUtil.newSingleMail(mail);
	});
}

// eagle
function eaglePressed() {
	selectedSomethin = true;
	trace("eagle pressed");

	FlxG.sound.music.stop();

	var bgBLACK:FlxSprite = new FlxSprite();
	bgBLACK.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	add(bgBLACK);

	var eagMew:FlxSprite = new FlxSprite();
	eagMew.loadGraphic(Paths.image('menus/mainmenu/eagle mewing'));
	eagMew.scale.set(2, 2);
	eagMew.updateHitbox();
	eagMew.screenCenter();
	add(eagMew);

	new FlxTimer().start(1, function(tmr:FlxTimer) {
		FlxG.sound.play(Paths.sound('bear5scream'));
		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			HandyDandy.loadWeek(["eag", 'behind-the-eag'], "Eagle", "eagle");
		});
	});
}

function activateEagle() {
	eagleActive = true;

	trace("EAGLE RAHHH");

	FlxG.sound.play(Paths.sound((brazilON ? 'toucan sound' : 'eagle sound')));

	var isLeft:Bool = (FlxG.random.int(1, 2) == 2 ? true : false);
	var eagleY:Float = FlxG.random.float(-35, 450);
	var twnVar:Float = FlxG.random.float(0.75, 1.5);
	eagle.x = (isLeft ? -1000 : 1500);
	eagle.y = eagleY;

	eagle.flipX = (isLeft ? false : true);

	FlxTween.tween(eagle, {y: (FlxG.random.int(1, 2) == 2 ? eagleY + 100 : eagleY - 200)}, twnVar, {ease: FlxEase.linear});
	FlxTween.tween(eagle, {x: (!isLeft ? -1000 : 1500)}, twnVar, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			eagleActive = false;
		}
	});
}

// brazil
function toucanPressed() {
	selectedSomethin = true;
	trace("TOUCAN PRESSED");
	FlxG.sound.music.stop();
	FlxG.sound.play(Paths.sound('toucanbigscary'));

	var toucanSCARY:FlxSprite = new FlxSprite();
	toucanSCARY.loadGraphic(Paths.image('menus/mainmenu/brazil/toucan scary'));
	toucanSCARY.scale.set(0.005, 0.005);
	toucanSCARY.updateHitbox();
	toucanSCARY.screenCenter();
	add(toucanSCARY);

	FlxTween.tween(toucanSCARY, {"scale.x": 1, "scale.y": 1}, 1.446, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			HandyDandy.loadWeek(["can"], "Toucan", "toucan");
		}
	});
}

// truck
function truckDriveBy() {
	trace(FlxG.save.data.mailInTruck);
	var throttle:FlxSound = new FlxSound();
	throttle.loadEmbedded(Paths.sound("ui/truck throttle"));
	FlxG.sound.list.add(throttle);
	throttle.play();
	selectedSomethin = true;
	FlxTween.tween(mailTruck, {x: 726}, 0.5, {
		ease: FlxEase.quartOut,
		onComplete: function(twn:FlxTween) {
			new FlxTimer().start(2, function(tmr:FlxTimer) {
				throttle.fadeOut(0.6, 0);
				FlxG.sound.play(Paths.sound("ui/truck leaving"));
				FlxTween.tween(mailTruck, {x: -3000}, 0.75, {
					ease: FlxEase.quartIn,
					onComplete: function(twn:FlxTween) {
						selectedSomethin = false;
						FlxG.save.data.mailInTruck = [];
						mailTruck.x = 10000;
						trace(FlxG.save.data.mailInTruck);
					}
				});
			});
		}
	});
}

// whitehouse
function whiteHouseRise() {
	whiteHouseIcon.y = 800;
	selectedSomethin = true;
	FlxG.sound.music.fadeOut(1, 0.5);
	FlxG.sound.play(Paths.sound("ui/earfquake tyler creator"));
	FlxG.camera.shake(0.025, 11);
	FlxTween.tween(whiteHouseIcon, {y: 550}, 11, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			selectedSomethin = false;
			FlxG.save.data.whiteHouseRisen = true;
			FlxG.sound.music.fadeIn(1, 1);
		}
	});
}

function whiteHouseStart() {
	selectedSomethin = true;
	FlxG.switchState(new ModState("murica/minigame/WhiteHouseWarning"));
}
