import flixel.math.FlxMath;
import funkin.backend.utils.CoolUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;

importScript("data/scripts/HandyDandyFunctions");
var pages:Array<String> = ['WEEKS', 'ROADTRIPS', 'MINIGAMES', 'OTHER'];

// leave these alone
var weeksArray:Array<String> = [];
var roadtripsArray:Array<String> = [];
var minigamesArray:Array<String> = [];
var othersArray:Array<String> = [];
var allSongsPushed:Array<String> = [];

// apparently all map variables are dynamic so no need for :Map<String, Array<String>>

var descriptions = [
	'WEEKS' => 'Main week songs!',
	'ROADTRIPS' => 'Mini-week songs!',
	'MINIGAMES' => 'Songs unlocked from minigames!\nUnlock more songs by playing minigames!',
	'OTHER' => 'Other songs unlocked from the mod!'
];

var selectorMAP = [
	'WEEKS' => ['week1'],
	'ROADTRIPS' => ['eag'],
	'MINIGAMES' => ['whday'],
	'OTHER' => ['brazil', 'fortnite']
];

var weekStuffs = [
	'week1' => {displayName: "WEEK 1", songs: ['patriot', 'god-and-country', 'kilometer'], description: 'Fight George Washington in this epic 3-song week!'},
	'eag' => {displayName: "EAGVENTURE\nTIME", songs: ['eag', 'behind-the-eag'], description: 'Eag time.'},
	'brazil' => {displayName: "BRAZIL", songs: ['negotiations', 'can'], description: "funk brasilerio"},
	'whday' => {
		displayName: "WHITE HOUSE\nDAY",
		songs: ['dementia', 'merry-christmas', 'jelly-donut', 'grimace'],
		description: 'All the songs you unlocked from the WHITE HOUSE DAY minigame!'
	},
	'fortnite' => {displayName: "FORTNITE", songs: ['eagnite'], description: 'Captain talon is NOT in the item shop :('}
];

var curPageSelected:Int = 0;
var canPress:Bool = true;
var curSongSelected, curWeekSelected:Int = 0;
var newPage, newWeek:Int;
var portrait:FlxSprite;
var arrowLEFT, arrowRIGHT, skibidistar, bg, simpleTxtBG, simpleTxtBG2:FlxSprite;
var songProperties:Map<String, {didFC:Bool}> = [];
var curMode:String = 'SelectPage';
var simpleTxtGrp:FlxTypedGroup<FlxText>;
var simpleDesc, arrowTxt:FlxText;
var songArray:Array<String> = [];
var backdrop:FlxBackdrop;
var stars:FlxTypedGroup = new FlxTypedGroup();
var arcadeLetterRead:Bool = false;
var arcadeMachine:FlxSprite;

function create() {
	window.title = "WHAT'S A KILOMETER - Freeplay Menu";
	FlxG.mouse.visible = true;
	HandyDandy.playMenuSong(FlxG.save.data.curCountry);

	loadData();

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/freeplaylandia/freeplaylandia close up'));
	bg.scale.set(1.25, 1.25);
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	backdrop = new FlxBackdrop(Paths.image('menus/freeplaylandia/freeplaylandia close up'), FlxAxes.XY, 0.2, 0.2);
	backdrop.scale.set(0.15, 0.15);
	backdrop.alpha = 0.25;
	backdrop.updateHitbox();
	backdrop.velocity.set(0, 180);
	backdrop.screenCenter();
	add(backdrop);
	backdrop.visible = false;

	simpleTxtBG = new FlxSprite();
	simpleTxtBG.makeGraphic(FlxG.width / 3, FlxG.height, FlxColor.BLACK);
	simpleTxtBG.alpha = 0.75;
	add(simpleTxtBG);

	simpleTxtBG2 = new FlxSprite(FlxG.width * 0.75);
	simpleTxtBG2.makeGraphic(FlxG.width / 4, FlxG.height, FlxColor.BLACK);
	simpleTxtBG2.alpha = 0.9;
	add(simpleTxtBG2);

	simpleDesc = new FlxText(simpleTxtBG2.x, 25, FlxG.width / 4);
	simpleDesc.setFormat("fonts/impact.ttf", 35, FlxColor.WHITE, "center");
	simpleDesc.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	add(simpleDesc);

	simpleTxtGrp = new FlxTypedGroup();
	add(simpleTxtGrp);

	arrowTxt = new FlxText(1000, 1000, 0, "<");
	arrowTxt.setFormat("fonts/impact.ttf", 65, FlxColor.WHITE, "center");
	arrowTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	arrowTxt.borderSize = 4;
	add(arrowTxt);
	if (arcadeLetterRead) {
		arcadeMachine = new FlxSprite(800, 515); 
		arcadeMachine.frames = Paths.getFrames('menus/freeplaylandia/arcademachine');
		arcadeMachine.animation.addByPrefix('delivery', 'delivery', 1, true);
		arcadeMachine.animation.addByPrefix('pallet', 'onpallet', 1, true);
		arcadeMachine.animation.addByPrefix('forklift', 'forklift', 1, true);
		arcadeMachine.animation.addByPrefix('machine', 'machine', 1, true);
		arcadeMachine.animation.addByPrefix('glow', 'glow', 16, false);
		arcadeMachine.scale.set(0.10, 0.30);
		arcadeMachine.updateHitbox();
		arcadeMachine.scale.set(0.35, 0.35);
		arcadeMachine.origin.set(445, 375);

		if (!FlxG.save.data.flappyEagDelivered) {
			var forklift:FlxSprite = new FlxSprite();
			forklift.frames = arcadeMachine.frames;
			forklift.animation.addByPrefix('delivery', "delivery", 1, true);
			forklift.animation.addByPrefix('forklift', "forklift", 1, true);
			forklift.animation.play('forklift');
			forklift.scale.set(0.10, 0.30);
			forklift.updateHitbox();
			forklift.scale.set(0.35, 0.35);
			add(forklift);
			forklift.visible = false;

			add(arcadeMachine);

			canPress = false;
			arcadeMachine.setPosition(-1000, 490);
			arcadeMachine.animation.play('delivery');
			FlxTween.tween(arcadeMachine, {x: 800}, 2, {
				ease: FlxEase.cubeOut,
				onComplete: function(twn:FlxTween) {
					forklift.setPosition(arcadeMachine.x - 138, arcadeMachine.y - 15);
					arcadeMachine.animation.play('pallet');
					forklift.visible = true;
					forklift.animation.play('forklift');
					FlxTween.tween(forklift, {x: 575, y: 475}, 2, {
						ease: FlxEase.cubeOut,
						onComplete: function(twn:FlxTween) {
							FlxTween.tween(forklift, {x: 2000}, 1.5, {
								ease: FlxEase.cubeIn,
								onComplete: function(twn:FlxTween) {
									arcadeMachine.animation.play('machine');
									FlxTween.tween(arcadeMachine, {y: 515}, 2, {
										ease: FlxEase.cubeIn,
										onComplete: function(twn:FlxTween) {
											canPress = true;
											FlxG.save.data.flappyEagDelivered = true;
										}
									});
								}
							});
						}
					});
				}
			});
		} else {
			add(arcadeMachine);
			arcadeMachine.animation.play('machine');
		}
	}

	// loadTxtGrp(pages);
	portrait = new FlxSprite(100, 100);
	portrait.loadGraphic(Paths.image('menus/freeplaylandia/songs/temp'));
	portrait.scale.set(0.8, 0.675);
	portrait.updateHitbox();
	portrait.scale.set(0.75, 0.75);
	portrait.origin.set(465, 325);
	add(portrait);

	arrowLEFT = new FlxSprite(95, 325);
	arrowLEFT.loadGraphic(Paths.image('menus/arrow'));
	arrowLEFT.scale.set(0.25, 0.15);
	arrowLEFT.updateHitbox();
	arrowLEFT.angle = -90;
	add(arrowLEFT);
	arrowLEFT.visible = false;

	arrowRIGHT = new FlxSprite(1045, 325);
	arrowRIGHT.loadGraphic(Paths.image('menus/arrow'));
	arrowRIGHT.scale.set(0.25, 0.15);
	arrowRIGHT.updateHitbox();
	arrowRIGHT.angle = 90;
	add(arrowRIGHT);
	arrowRIGHT.visible = false;

	skibidistar = new FlxSprite(380, 60);
	skibidistar.loadGraphic(Paths.image("menus/freeplaylandia/skibidistar"));
	skibidistar.scale.set(0.6, 0.6);
	skibidistar.updateHitbox();
	add(skibidistar);
	skibidistar.visible = false;
	add(stars);
	for (i in 0...5) {
		var star:Star = new Star();
		stars.add(star);
	}

	switchMode("SelectPage");
	changePage(0);
}

function update(elapsed:Float) {
	if (canPress) {
		if (arcadeLetterRead) {
			if (FlxG.mouse.overlaps(arcadeMachine) && arcadeMachine.visible) {
				arcadeMachine.animation.play('glow');
				if (FlxG.mouse.justPressed)
					FlxG.switchState(new ModState('murica/minigame/FlappyEag'));
			} else
				arcadeMachine.animation.play('machine');
		}
		switch (curMode) {
			case 'SelectPage':
				if (controls.BACK) {
					FlxG.sound.play(Paths.sound('menu/cancel'));
					FlxG.switchState(new MainMenuState());
				}
				if (controls.ACCEPT)
					switchMode("SelectWeek");

				simpleTxtGrp.forEach(function(txt:FlxText) {
					if (FlxG.mouse.overlaps(txt)) {
						if (newPage != txt.ID) {
							newPage = txt.ID;
							curPageSelected = txt.ID;
							pageStuff();
						}
						if (FlxG.mouse.justPressed)
							switchMode("SelectWeek");
					}
				});
				if (controls.UP_P)
					changePage(-1);
				else if (controls.DOWN_P)
					changePage(1);
			case 'SelectWeek':
				if (controls.BACK)
					switchMode("SelectPage");

				if (controls.UP_P)
					changeWeek(-1);
				else if (controls.DOWN_P)
					changeWeek(1);
				simpleTxtGrp.forEach(function(txt:FlxText) {
					if (FlxG.mouse.overlaps(txt)) {
						if (newWeek != txt.ID) {
							newWeek = txt.ID;
							curWeekSelected = txt.ID;
							weekStuff();
						}
						if (FlxG.mouse.justPressed)
							switchMode("SelectSong");
					}
				});
				if (controls.ACCEPT)
					switchMode("SelectSong");

			case 'SelectSong':
				if (songProperties[
					weekStuffs[selectorMAP[pages[curPageSelected]][curWeekSelected]].songs[curSongSelected]
				].didFC) {
					for (i in stars)
						i.update(elapsed);
				}
				if (controls.BACK)
					switchMode("SelectWeek");

				if (controls.LEFT_P || FlxG.mouse.overlaps(arrowLEFT) && arrowLEFT.visible && FlxG.mouse.justPressed) {
					changeSong(-1);
					FlxTween.tween(arrowLEFT, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
						ease: FlxEase.quintInOut,
						onComplete: function(twn:FlxTween) {
							FlxTween.tween(arrowLEFT, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
						}
					});
				}
				if (controls.RIGHT_P || FlxG.mouse.overlaps(arrowRIGHT) && arrowRIGHT.visible && FlxG.mouse.justPressed) {
					changeSong(1);
					FlxTween.tween(arrowRIGHT, {"scale.x": 0.3, "scale.y": 0.3}, 0.05, {
						ease: FlxEase.quintInOut,
						onComplete: function(twn:FlxTween) {
							FlxTween.tween(arrowRIGHT, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
						}
					});
				}
				if (controls.ACCEPT)
					HandyDandy.loadSong(songArray[curSongSelected].toLowerCase());
		}
	}
}

function loadTxtGrp(daArray:Array<String>) {
	simpleTxtGrp.clear();
	for (i => option in daArray) {
		var txt:FlxText = new FlxText(25, ((i * 125) + 100));
		txt.text = daArray[i].toUpperCase();
		txt.setFormat("fonts/impact.ttf", 65, FlxColor.WHITE, "center");
		txt.ID = i;
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		txt.borderSize = 4;
		simpleTxtGrp.add(txt);
	}
}

function switchMode(mode:String) {
	curMode = mode;

	switch (mode) {
		case 'SelectPage':
			loadTxtGrp(pages);
		case 'SelectWeek':
			var dummy:Array<String> = [];
			for (i in selectorMAP[pages[curPageSelected]]) {
				dummy.push(weekStuffs[i].displayName);
			}
			loadTxtGrp(dummy);
	}

	if (arcadeLetterRead)
		arcadeMachine.visible = (mode != 'SelectSong' ? true : false);
	for (txt in simpleTxtGrp)
		txt.visible = (mode == 'SelectSong' ? false : true);
	simpleTxtBG.visible = (mode == 'SelectSong' ? false : true);
	arrowTxt.visible = (mode == 'SelectSong' ? false : true);
	simpleDesc.visible = (mode == 'SelectSong' ? false : true);
	simpleTxtBG2.visible = (mode == 'SelectSong' ? false : true);
	portrait.visible = (mode == 'SelectSong' ? true : false);
	skibidistar.visible = (mode == 'SelectSong' ? true : false);
	arrowLEFT.visible = (mode == 'SelectSong' ? true : false);
	arrowRIGHT.visible = (mode == 'SelectSong' ? true : false);
	var ssgraph:String = 'menus/freeplaylandia/backgrounds/' + selectorMAP[pages[curPageSelected]][curWeekSelected];
	var elsegraph:String = 'menus/freeplaylandia/freeplaylandia close up';
	bg.loadGraphic(Paths.image((mode == 'SelectSong' ? ssgraph : elsegraph)));
	backdrop.visible = (mode == 'SelectSong' ? true : false);
	if (mode == 'SelectSong') {
		backdrop.loadGraphic(Paths.image(ssgraph));
		songArray = weekStuffs[selectorMAP[pages[curPageSelected]][curWeekSelected]].songs;
		curSongSelected = 0;
	}
	toggleStars();

	switch (mode) {
		case 'SelectPage':
			changePage(0);
		case 'SelectWeek':
			changeWeek(0);
		case 'SelectSong':
			changeSong(0);
	}
}

function changePage(cool:Int) {
	curPageSelected += cool;
	if (curPageSelected >= pages.length)
		curPageSelected = 0;
	if (curPageSelected < 0)
		curPageSelected = pages.length - 1;
	pageStuff();
}

function pageStuff() {
	simpleDesc.text = "DESCRIPTION:\n" + descriptions[pages[curPageSelected]];
	simpleDesc.screenCenter(FlxAxes.Y);
	simpleTxtGrp.forEach(function(txt:FlxText) {
		txt.color = (txt.ID == curPageSelected ? FlxColor.RED : FlxColor.WHITE);
		if (txt.ID == curPageSelected)
			arrowTxt.setPosition(txt.x + txt.width, txt.y);
	});
}

function changeWeek(cool:Int) {
	var daArray:Array<String> = selectorMAP[pages[curPageSelected]];
	curWeekSelected += cool;
	if (curWeekSelected >= daArray.length)
		curWeekSelected = 0;
	if (curWeekSelected < 0)
		curWeekSelected = daArray.length - 1;

	weekStuff();
}

function weekStuff() {
	simpleDesc.text = weekStuffs[selectorMAP[pages[curPageSelected]][curWeekSelected]].description;
	simpleTxtGrp.forEach(function(txt:FlxText) {
		txt.color = (txt.ID == curWeekSelected ? FlxColor.RED : FlxColor.WHITE);
		if (txt.ID == curWeekSelected)
			arrowTxt.setPosition(txt.x + txt.width, txt.y);
	});
}

function toggleStars() {
	var songArray = weekStuffs[selectorMAP[pages[curPageSelected]][curWeekSelected]].songs;
	var boolT:Bool = (curMode == 'SelectSong' && songProperties[songArray[curSongSelected]].didFC);
	stars.visible = boolT;
}

function changeSong(cool:Int) {
	var cantMove:Bool = false;
	curSongSelected += cool;
	arrowLEFT.visible = (curSongSelected <= 0) ? false : true;
	arrowRIGHT.visible = (curSongSelected >= songArray.length - 1) ? false : true;
	if (curSongSelected >= songArray.length) {
		curSongSelected = songArray.length - 1;
		cantMove = true;
	} else if (curSongSelected < 0) {
		curSongSelected = 0;
		cantMove = true;
	}

	if (!cantMove) {
		curFreeplaySelected = curSongSelected;

		portrait.loadGraphic(Paths.image('menus/freeplaylandia/songs/picture_' + songArray[curSongSelected].toLowerCase()));
		portrait.scale.set(0.8, 0.675);
		portrait.updateHitbox();
		portrait.scale.set(0.75, 0.75);
		portrait.origin.set(465, 325);
		portrait.screenCenter();
		FlxTween.tween(portrait, {"scale.x": 0.8, "scale.y": 0.8}, 0.05, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(portrait, {"scale.x": 0.75, "scale.y": 0.75}, 0.05, {ease: FlxEase.linear});
			}
		});

		skibidistar.visible = songProperties[songArray[curSongSelected]].didFC; // makes star visible if fc'd the song
		FlxTween.tween(skibidistar, {"scale.x": 0.65, "scale.y": 0.65}, 0.05, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(skibidistar, {"scale.x": 0.6, "scale.y": 0.6}, 0.05, {ease: FlxEase.linear});
			}
		});
		toggleStars();
	}
}

function loadSongSelStuff() {
	var pagesTEMP:Array<String> = pages;

	trace("SONGS ALR UNLOCKED: " + FlxG.save.data.songsUnlockedGW);

	for (week in selectorMAP['WEEKS']) {
		var songArray:Array<String> = weekStuffs[week].songs;
		var pushedSongs:Array<String> = [];
		for (song in songArray) {
			if (FlxG.save.data.songsUnlockedGW.contains(song))
				pushedSongs.push(song);
			else if (!FlxG.save.data.songsUnlockedGW.contains(song))
				weekStuffs[week].songs.remove(song);
		}

		if (pushedSongs.length > 1) {
			trace(week + ": " + weekStuffs[week].songs);
			weeksArray.push(week);
			for (song in pushedSongs)
				allSongsPushed.push(song);
		} else if (pushedSongs.length < 1) {
			selectorMAP["WEEKS"].remove(week);
		}
	}
	if (weeksArray.length < 1)
		pages.remove("WEEKS");

	for (roadtrip in selectorMAP['ROADTRIPS']) {
		var songArray:Array<String> = weekStuffs[roadtrip].songs;
		var pushedSongs:Array<String> = [];
		for (song in songArray) {
			if (FlxG.save.data.songsUnlockedGW.contains(song))
				pushedSongs.push(song);
			else if (!FlxG.save.data.songsUnlockedGW.contains(song))
				weekStuffs[roadtrip].songs.remove(song);
		}
		if (pushedSongs.length > 1) {
			trace(roadtrip + ": " + weekStuffs[roadtrip].songs);
			roadtripsArray.push(roadtrip);
			for (song in pushedSongs)
				allSongsPushed.push(song);
		} else if (pushedSongs.length < 1) {
			selectorMAP["ROADTRIPS"].remove(roadtrip);
		}
	}
	if (roadtripsArray.length < 1)
		pages.remove("ROADTRIPS");

	for (minigame in selectorMAP['MINIGAMES']) {
		var songArray:Array<String> = weekStuffs[minigame].songs;
		var pushedSongs:Array<String> = [];
		for (song in songArray) {
			if (FlxG.save.data.songsUnlockedGW.contains(song))
				pushedSongs.push(song);
			else if (!FlxG.save.data.songsUnlockedGW.contains(song))
				weekStuffs[minigame].songs.remove(song);
		}
		if (pushedSongs.length > 1) {
			trace(minigame + ": " + weekStuffs[minigame].songs);
			minigamesArray.push(minigame);
			for (song in pushedSongs)
				allSongsPushed.push(song);
		} else if (pushedSongs.length < 1)
			selectorMAP["MINIGAMES"].remove(minigame);
	}
	if (minigamesArray.length < 1)
		pages.remove("MINIGAMES");

	for (others in selectorMAP['OTHER']) {
		var songArray:Array<String> = weekStuffs[others].songs;
		var pushedSongs:Array<String> = [];
		for (song in songArray) {
			if (FlxG.save.data.songsUnlockedGW.contains(song))
				pushedSongs.push(song);
			else if (!FlxG.save.data.songsUnlockedGW.contains(song))
				weekStuffs[others].songs.remove(song);
		}
		if (pushedSongs.length > 1) {
			trace(others + ": " + weekStuffs[others].songs);

			othersArray.push(others);
			for (song in pushedSongs)
				allSongsPushed.push(song);
		} else if (pushedSongs.length < 1) {
			selectorMAP["OTHER"].remove(others);
		}
	}
	if (othersArray.length < 1)
		pages.remove("OTHER");
}

function loadData() {
	loadSongSelStuff();
	var saveSongsArray:Array<String> = [];
	// sets the song properties
	for (song in allSongsPushed) {
		var songlol:String = song.toLowerCase();
		songProperties.set(songlol, {
			didFC: (FlxG.save.data.songsFCd.contains(songlol)) ? true : false // detects if song is fc'd based on savedata
		});
	}
	arcadeLetterRead = FlxG.save.data.mailRead.contains('arcade');
}

class Star extends FlxSprite { //TO FIX
	public var timer:Float = 1;

	public var datween:FlxTween;

	public function new() {
		super(0, 0, null);
		loadGraphic(Paths.image('menus/freeplaylandia/skibidistar'));
		scale.set(0.25, 0.25);
		updateHitbox();
		antialiasing = false;
		alpha = 0;
		scale.set(0.75, 0.75);
		timer = FlxG.random.float(0.05, 1.0);
		datween = new FlxTween();
	}

	public function update(elapsed:Float) {
		super.update(elapsed);
		timer -= elapsed;
		if (timer <= 0 && alpha == 0)
			play();
	}

	public function play() {
		timer = FlxG.random.float(1.0, 2.5);
		alpha = 1.0;
		x = portrait.x + FlxG.random.float(0, portrait.width - 50);
		y = portrait.y + FlxG.random.float(0, portrait.height - 50);
		datween.tween(this, {"scale.x": 0.25, "scale.y": 0.25}, 0.2, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				datween.tween(this, {"scale.x": 0.15, "scale.y": 0.15, alpha: 0}, FlxG.random.float(0.2, 1), {
					ease: FlxEase.linear
				});
			}
		});
	}
}
