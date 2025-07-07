import flixel.system.FlxSound;
import flixel.text.FlxTextBorderStyle;

importScript("data/scripts/HandyDandyFunctions");
// main data
public var isNight:Bool = false;
public var curRoom:String = "startroom";
public var startRoom:String = 'startroom'; // startroom
public var pauseFunctions:Array<Void->Bool> = [];
public var roomTimeVar:Float = 0.25;
public var shortStep:String = 'fnaf4runsoundshort';
public var imagePath:String = 'minigames/whitehouse/objects';
public var soundPath:String = 'minigame/whitehouse_day';

// progress
public var canLeave:Bool = false; // can leave the house
public var curSound:FlxSound;

function create() {
	curSound = new FlxSound();
	FlxG.sound.list.add(curSound);
}

/**
 * upRoom, leftRoom, downRoom, rightRoom: your rooms, in each 4 directions
 * upRoomSound, leftRoomSound, downRoomSound, rightRoomSound: replaces the footstep sound with something different
 * openFunc: function that runs when you go to a new room
 * leftAngle, rightAngle, upAngle, downAngle: changes the angle of the arrows
 * leftArrowPOS, rightArrowPOS, upArrowPOS, downArrowPOS: the position of the arrows
 */
// this is like the tf2 coconut, you delete this variable, you delete the minigame entirely
public var dayRooms = [
	// start
	"startroom" => {
		downRoom: 'startbehind',
		downRoomSound: shortStep,
		leftArrowPOS: [75, 570],
		leftRoom: '1floorhallwaystart',
		openFunc: function() {
			if (!roomVars.exists('initialized'))
				roomVars.set('initialized', (startRoom == 'startroom' ? false : true));
			if (!roomVars.exists('canShowWarning'))
				roomVars.set('canShowWarning', false);

			roomVars['canShowWarning'] = (unlockedTapes.length >= 1 && tapeCount == tapeAmt ? true : false);

			if (!roomVars['initialized']) {
				mainCamera.zoom = 2;
				volumeBGM(0, 0.001);
				for (track in bgmLIST)
					dayshiftBGM[track].pause();
				mainCamera.alpha = 0;
				playSound('riser', 0.7);
				FlxTween.tween(mainCamera, {alpha: 1, zoom: 1}, 5, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween) {
						new FlxTimer().start(2.5, function(tmr:FlxTimer) {
							for (arrow in [leftArrow, downArrow, upArrow, rightArrow])
								arrow.alpha = 1;
							roomVars['initialized'] = canPressAnything = true;
							for (track in bgmLIST)
								dayshiftBGM[track].play(true);
							volumeBGM(0.7, 1);
						});
					}
				});
				new FlxTimer().start(roomTimeVar + 0.01, function(tmr:FlxTimer) {
					canPressAnything = false;
					for (arrow in [leftArrow, downArrow, upArrow, rightArrow])
						arrow.alpha = 0;
				});
			}

			var clickableDoor:FlxSprite;
			loadRoomSprite('leavedoor', 'baseSpr', [539, 332], true, 'leavedoor', [2.35, 2.35]);
			clickableDoor = roomSprites['leavedoor'];
			clickableDoor.animation.addByPrefix('closed', 'doorclosed', 1);
			clickableDoor.animation.addByPrefix('anim', 'doorstuff', 24, false);
			clickableDoor.animation.play('closed');
			clickableDoor.antialiasing = false;
			clickableDoor.scale.set(1.175, 1.175);
			clickableDoor.updateHitbox();
			clickableDoor.scale.set(2.35, 2.35);

			updateRoomSprite.set('startroom', function(elapsed:Float) {
				if (FlxG.mouse.overlaps(clickableDoor) && canPressAnything && FlxG.mouse.justPressed && roomVars['initialized']) {
					if (!FlxG.mouse.overlaps(inventoryItems)) {
						if (roomVars['canShowWarning'] == true) {
							trace("works"); // work on this
						} else
							funnyTextThing('get some tapes first...', [520, 365], 0.75, 300, 25);
					}
				}
			});

			closeRoomFunc.set('startroom', function() {
				clickableDoor.exists = false;
			});
		}
	},
	"startbehind" => {downRoom: 'startroom', downRoomSound: shortStep, leftRoom: 'eastwinghallwayfront'},
	// east wing
	"eastwinghallwayfront" => {downRoom: 'eastwinghallwayback', downRoomSound: shortStep, upRoom: 'eastwingfarhallway'},
	"eastwinghallwayback" => {downRoom: 'eastwinghallwayfront', downRoomSound: shortStep, rightRoom: "startroom"},
	"eastwingfarhallway" => {downRoom: 'eastwingfarhallwayback', downRoomSound: shortStep, rightRoom: 'eastwingdeadend1'},
	"eastwingfarhallwayback" => {downRoom: 'eastwingfarhallway', downRoomSound: shortStep, upRoom: "eastwinghallwayback"},
	'eastwingdeadend1' => {leftRoom: 'eastwingdeadend2', leftRoomSound: shortStep, upRoom: 'eastwingfarhallwayback'},
	'eastwingdeadend2' => {downRoom: 'eastwingdeadend1', downRoomSound: shortStep},
	// red room a
	'redroomaview' => {downRoom: 'redroomabehind', leftRoom: 'redroomaportrait'},
	'redroomabehind' => {downRoom: 'redroomaview', upRoom: '1floorstairs'},
	'redroomaportrait' => {leftRoom: 'redroomaview'},
	// 1st floor
	'1floorhallwaystart' => {downRoom: '1floorhallwaybehind', downRoomSound: shortStep, upRoom: '1floor2doors'},
	'1floorhallwaybehind' => {downRoom: '1floorhallwaystart', downRoomSound: shortStep, upRoom: 'startroom'},
	'stairsoval' => {
		rightRoom: '1floorstairs',
		downRoom: '1floor2doorsbehind',
		leftRoom: 'redrooma'
	},
	'redrooma' => {
		downRoom: '1floorstairs',
		rightRoom: 'stairsoval',
		leftRoom: '1floor2doorsbehind',
		upRoom: 'redroomaview'
	},
	'1floor2doors' => {
		downRoom: '1floor2doorsbehind',
		downRoomSound: shortStep,
		upRoom: '1floorstairs',
		leftRoom: 'yellowroom',
		leftArrowPOS: [75, 570],
		rightRoom: 'redroomb',
		rightArrowPOS: [1100, 570]
	},
	'1floor2doorsbehind' => {downRoom: '1floor2doors', downRoomSound: shortStep, upRoom: '1floorhallwaybehind'},
	'1floorstairs' => {
		rightRoom: '1floor2doorsbehind',
		rightArrowPOS: [1100, 590],
		upRoom: '2floorstairs',
		leftArrowPOS: [75, 590],
		leftRoom: 'stairsoval',
		upArrowPOS: [670, 420],
		downRoom: "redrooma",
		openFunc: function() {
			loadRoomSprite('gate', 'baseSpr', [420, 183], true, 'bottomgatedoor', [2.35, 2.35]);

			var gate:FlxSprite;
			gate = roomSprites['gate'];
			gate.animation.addByPrefix('doorup', 'doorup', 1);
			gate.animation.addByPrefix('doorlift', 'doorlift', 24, false);
			gate.animation.addByPrefix('doordown', 'doordown', 1);
			if (roomVars.exists('isDoorUp') && roomVars['isDoorUp'] == true)
				gate.visible = false;
			else {
				gate.animation.play('doordown');
				upArrow.setPosition(2000, 2000);
			}
			gate.antialiasing = false;
			gate.scale.set(1.175, 2.35);
			gate.updateHitbox();
			gate.scale.set(2.35, 2.35);
			gate.origin.set(460, 125);

			updateRoomSprite.set('1floorstairs', function(elapsed:Float) {
				if (FlxG.mouse.overlaps(gate) && FlxG.mouse.justPressed && canPressAnything && !roomVars.exists('isDoorUp')) {
					if (!FlxG.mouse.overlaps(inventoryItems)) {
						if (curItemSelected == 'key' && inventory.contains('key')) {
							canPressAnything = false;
							itemLose('key');
							playSound('bigdoorclose', 0.7);
							gate.animation.play('doorlift');
							gate.animation.finishCallback = function() {
								canPressAnything = true;
								gate.visible = false;
								roomVars.set('isDoorUp', true);
								upArrow.setPosition(670, 420);
							};
						} else
							funnyTextThing('you need a key...', [520, 365], 0.75, 600, 45);
					}
				}
			});
			closeRoomFunc.set('1floorstairs', function() {
				gate.exists = false;
			});
		}
	},
	// yellow room
	'yellowroom' => {
		downRoom: 'yellowroombehind',
		downRoomSound: shortStep,
		upRoom: 'yellowroomcouch',
		rightRoom: 'yellowroompainting',
		rightArrowPOS: [855, 585],
		openFunc: function() {
			rightArrow.flipY = true;
			closeRoomFunc.set("yellowroom", function() {
				rightArrow.flipY = false;
			});
		}
	},
	'yellowroomcouch' => {downRoom: 'yellowroom', rightRoom: 'yellowroompainting'},
	'yellowroompainting' => {
		leftRoom: 'yellowroomcouch',
		rightRoom: 'yellowroom',
		openFunc: function() {
			loadRoomSprite('key1', 'roomSpr', [612, 415], false, 'key', [1, 1]);
			var key:FlxSprite;
			key = roomSprites['key1'];
			key.angle = -130;
			if (roomVars.exists('key1get') && roomVars['key1get'] == true)
				key.visible = false;
			updateRoomSprite.set('yellowroompainting', function(elapsed:Float) {
				if (FlxG.mouse.overlaps(key) && !roomVars['key1get']) {
					FlxTween.tween(key, {"scale.x": 1.2, "scale.y": 1.2}, 0.05, {ease: FlxEase.cubeIn});
					if (FlxG.mouse.justPressed) {
						roomVars.set('key1get', true);
						itemGet('key');
						key.visible = false;
					}
				} else
					FlxTween.tween(key, {"scale.x": 1, "scale.y": 1}, 0.05, {ease: FlxEase.cubeIn});
			});
			closeRoomFunc.set('yellowroompainting', function() {
				key.exists = false;
			});
		}
	},
	'yellowroombehind' => {upRoom: '1floor2doors', downRoom: 'yellowroom'},
	// red room b
	'redroomb' => {downRoom: 'redroombbehind', rightRoom: 'redroomblibrary'},
	'redroombbehind' => {upRoom: '1floor2doors', downRoom: 'redroomb', leftRoom: 'redroomblibrary'},
	'redroomblibrary' => {rightRoom: 'redroomb'},
	// 2nd floor
	'2floorstairs' => {upRoom: '1floorstairs', leftRoom: "bigroomview1", rightRoom: 'pianofromstairsview'},
	// big room
	'bigroomview1' => {
		downRoom: 'bigroomview1behind',
		leftRoom: 'mckinleyposter',
		upRoom: 'bigroomview2',
		rightRoom: 'hallwaydoor'
	},
	'bigroomview1behind' => {
		upRoom: '2floorstairs',
		downRoom: 'bigroomview1',
		leftRoom: 'hallwaydoor',
		rightRoom: 'mckinleyposter'
	},
	'mckinleyposter' => {
		downRoom: 'bigroomview1',
		rightRoom: 'marthaposter',
		downRoom: 'bigroomview1',
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('mckinleyposter', 'mckinleypainting', [510, 130], function() {
				curSound.loadEmbedded(Paths.sound(soundPath + "/mckinley"));
				curSound.play();
				portraitTime = curSound.length / 1000;
			}, null);
			closeRoomFunc.set('mckinleyposter', function() {
				poster.exists = false;
			});
		}
	},
	'marthaposter' => {
		leftRoom: 'mckinleyposter',
		rightRoom: 'georgeposter',
		downRoom: 'right2doors',
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('martha', 'marthapainting', [530, -45]);
			closeRoomFunc.set('marthaposter', function() {
				poster.exists = false;
			});
		}
	},
	'georgeposter' => {
		leftRoom: 'marthaposter',
		rightRoom: 'teddyposter',
		downRoom: 'left2doors',
		openFunc: function() {
			if (!roomVars.exists('georgeClickCount'))
				roomVars.set('georgeClickCount', 0);
			if (!roomVars.exists('georgeGone'))
				roomVars.set('georgeGone', false);

			var poster:FlxSprite;
			if (roomVars['georgeGone'] == false) {
				poster = loadPortrait('georgeposter', 'georgepainting', [425, -45], function() {
					if (roomVars['georgeGone'] == false) {
						if (!roomVars.exists('georgepressed')) {
							curSound.loadEmbedded(Paths.sound(soundPath + "/georgepaintingv1"));
							curSound.play();
							dialogue('george_intro');
						} else if (roomVars['georgeClickCount'] >= 14) {
							curSound.loadEmbedded(Paths.sound(soundPath + "/george50times"));
							curSound.play();
							dialogue('george_secret');
							roomVars['georgeGone'] = true;
							poster.visible = false;
							new FlxTimer().start(11, function(tmr:FlxTimer) {
								unlockTAPE('eagnite', true, 5);
							});
						} else {
							var rando = FlxG.random.int(1, 4);
							curSound.loadEmbedded(Paths.sound(soundPath + "/georgepaintingv2_" + rando));
							curSound.play();
							dialogue('georgerando_' + rando);
						}
						portraitTime = curSound.length / 1000;
					}
				}, function() {
					roomVars.set('georgepressed', true);
					roomVars['georgeClickCount'] += 1;
					trace(roomVars['georgeClickCount']);
				});
			}

			closeRoomFunc.set('georgeposter', function() {
				if (roomVars['georgeGone'] == false)
					poster.exists = false;
			});
		}
	},
	'teddyposter' => {
		leftRoom: 'georgeposter',
		downRoom: 'left2doors',
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('teddy', 'teddypainting', [360, 45], function() {
				var rando = FlxG.random.int(1, 16);
				curSound.loadEmbedded(Paths.sound(soundPath + "/teddy_" + rando));
				curSound.play();
				portraitTime = curSound.length / 1000;
				dialogue('teddy_' + rando);
			}, null);

			closeRoomFunc.set('teddyposter', function() {
				poster.exists = false;
			});
		}
	},
	'bigroomview2' => {
		downRoom: 'bigroomview1behind',
		leftRoom: 'marthaposter',
		rightRoom: 'hallwaydoor',
		upRoom: 'left2doors'
	},
	'left2doors' => {
		downRoom: 'georgeposter',
		rightRoom: 'hallwaydoor',
		rightArrowPOS: [1000, 575],
		leftArrowPOS: [120, 575],
		leftRoom: 'teddyposter',
		rightAngle: -25,
		leftAngle: -25,
		upRoom: 'greenroomdoor'
	},
	'hallwaydoor' => {
		downRoom: 'bigroomview3',
		leftRoom: 'greenroomdoor',
		rightRoom: 'bigroomview1behind',
		upRoom: 'hallway'
	},
	'bigroomview3' => {downRoom: 'hallwaydoor', leftRoom: 'right2doors', rightRoom: 'left2doors'},
	'right2doors' => {
		leftRoom: 'hallwaydoor',
		downRoom: 'marthaposter',
		upRoom: 'bigroomview1behind',
		rightRoom: 'mckinleyposter'
	},
	'greenroomdoor' => {downRoom: 'left2doors', rightRoom: 'hallwaydoor', upRoom: 'greenroom'},
	// red room a
	// green room
	'greenroom' => {downRoom: 'greenroombehind', upRoom: 'greenroompainting', rightRoom: "greenroombehind2"},
	'greenroombehind' => {downRoom: 'greenroom', upRoom: 'left2doors'},
	'greenroombehind2' => {downRoom: 'greenroom', upRoom: 'hallway'},
	'greenroompainting' => {downRoom: 'greenroom', rightRoom: 'greenroombehind3'},
	'greenroombehind3' => {downRoom: 'greenroom', leftRoom: 'greenroompainting', upRoom: 'ovalviewleft'},
	// oval room (FAKE OVAL OFFICE)
	'bigbacktaft' => {
		downRoom: 'ovalroombehind',
		openFunc: function() {
			if (!roomVars.exists('firstTimeTaft'))
				roomVars['firstTimeTaft'] = true;

			loadRoomSprite('taftEvent', 'baseSpr', [425, 206], true, 'taftportraitevent', [2.35, 2.35]);
			var taftEvent = roomSprites['taftEvent'];
			taftEvent.animation.addByPrefix('default', 'taftdefault', 1);
			taftEvent.animation.addByPrefix('giveMac', 'taftanim1', 24, false);
			taftEvent.animation.play('default');

			var poster:FlxSprite;
			poster = loadPortrait('taft', 'taftpainting', [420, 200], function() {
				if (roomVars['firstTimeTaft'] == true) {
					curSound.loadEmbedded(Paths.sound(soundPath + '/taftgivemcdonald'));
					curSound.play();
					portraitTime = curSound.length / 1000;
					taftEvent.animation.play('giveMac');
					taftEvent.animation.finishCallback = function() {
						taftEvent.animation.play('default');
					}
					new FlxTimer().start(portraitTime, function(tmr:FlxTimer) {
						itemGet('bigmac');
						roomVars['firstTimeTaft'] = false;
					});
				} else {
					curSound.loadEmbedded(Paths.sound(soundPath + '/taftrandom_' + FlxG.random.int(1, 3)));
					curSound.play();
					portraitTime = curSound.length / 1000;
				}
			}, null);
			closeRoomFunc.set('bigbacktaft', function() {
				poster.exists = false;
				taftEvent.exists = false;
			});
		}
	},
	'johnadams' => {rightRoom: 'redovalroom', leftRoom: 'ovalroomwindow'},
	'ovalroomwindow' => {
		downRoom: 'ovalroom',
		rightRoom: 'johnadams',
		downRoom: 'ovalbackview',
		leftRoom: 'greenovalroom'
	},
	'ovalroombehind' => {downRoom: 'ovalroom', upRoom: 'hallwaymid'},
	'redovalroom' => {leftRoom: 'johnadams', downRoom: 'ovalviewright', upRoom: 'redroomc'},
	'ovalroom' => {
		downRoom: 'ovalroombehind',
		upRoom: 'ovalroomwindow',
		leftRoom: 'ovalviewleft',
		rightRoom: 'ovalviewright'
	},
	'greenovalroom' => {rightRoom: 'ovalroomwindow', downRoom: 'ovalviewleft', upRoom: 'greenroom'},
	'ovalbackview' => {downRoom: 'ovalroomwindow', upRoom: 'ovalroombehind'},
	'ovalviewleft' => {
		downRoom: 'ovalroombehind',
		leftRoom: 'greenovalroom',
		upRoom: 'ovalroomwindow',
		rightRoom: 'ovalviewright'
	},
	'ovalviewright' => {
		downRoom: 'ovalroombehind',
		rightRoom: 'redovalroom',
		upRoom: 'ovalroomwindow',
		leftRoom: 'ovalviewleft'
	},
	// red room c
	'redroomc' => {
		downRoom: "redroomcbehind",
		upRoom: "beautifulahhpainting",
		rightRoom: 'reddining',
		rightAngle: -25,
		rightArrowPOS: [1000, 575]
	},
	'redroomcbehind' => {downRoom: "redroomc", upRoom: "ovalviewright"},
	'beautifulahhpainting' => {downRoom: 'redroomc'},
	'reddining' => {downRoom: 'redroomcview', upRoom: 'diningviewfront'},
	'redroomcview' => {downRoom: 'redroomcview', upRoom: 'redroomcbehind'},
	// hallway
	'ovalroomdoor' => {downRoom: 'hallwaymid', upRoom: 'ovalroom'},
	'hallway' => {
		downRoom: "hallwaybehind",
		upRoom: 'hallwaymid',
		rightRoom: 'carterjohnson',
		leftRoom: 'greenroomdoor2'
	},
	'greenroomdoor2' => {upRoom: 'greenroom', downRoom: 'hallway'},
	'hallwaybehind' => {downRoom: 'hallway', upRoom: 'bigroomview3'},
	'carterjohnson' => {
		downRoom: 'hallway',
		openFunc: function() {
			var carter, johnson:FlxSprite;
			carter = loadPortrait('carter', 'carterpainting', [-80, 175], function() {
				var rando = FlxG.random.int(1, 7);
				curSound.loadEmbedded(Paths.sound(soundPath + "/carterrandom_" + rando));
				curSound.play();
				portraitTime = curSound.length / 1000;
				dialogue('carter_' + rando);
			}, null);
			johnson = loadPortrait('johnson', 'johnsonpainting', [980, 110]);
			closeRoomFunc.set('carterjohnson', function() {
				for (poster in [carter, johnson])
					poster.exists = false;
			});
		}
	},
	'hallwaymid' => {
		downRoom: "hallwaymidbehind",
		upRoom: 'hallwayend',
		leftRoom: 'ovalroomdoor',
		rightRoom: 'pianoarea'
	},
	'hallwaymidbehind' => {
		downRoom: 'hallwaymid',
		upRoom: 'hallwaybehind',
		leftRoom: 'carterjohnson',
		rightRoom: 'greenroomdoor2'
	},
	'hallwayend' => {
		downRoom: 'hallwayendbehind',
		leftRoom: 'sentientpicofjfk',
		upRoom: 'diningroom',
		newBGM: 'jfk',
		rightRoom: 'ronaldreagan',
		openFunc: function() {
			if (!roomVars.exists('jfkPSST'))
				roomVars['jfkPSST'] = false;

			if (!roomVars['jfkPSST']) {
				new FlxTimer().start(roomTimeVar + 0.01, function(tmr:FlxTimer) {
					canPressAnything = false;
					curSound.loadEmbedded(Paths.sound(soundPath + "/jfkpsst"));
					curSound.play();
					dialogue('jfk_psst');
					volumeBGM(0.1, 0.5);
					new FlxTimer().start(curSound.length / 1000, function(tmr:FlxTimer) {
						roomVars['jfkPSST'] = true;
						canPressAnything = true;
						volumeBGM(0.7, 1);
					});
				});
			}
		}
	},
	'hallwayendbehind' => {
		downRoom: 'hallwayend',
		upRoom: 'hallwaymidbehind',
		leftRoom: 'pianoarea',
		newBGM: "jfk"
	},
	"sentientpicofjfk" => {
		downRoom: 'hallwayend',
		newBGM: 'jfk',
		openFunc: function() { // SPAGHETTI CODE UUUUUHHHHHHHH
			if (!roomVars.exists('firstTimeJFK'))
				roomVars['firstTimeJFK'] = true;

			loadRoomSprite('jfkevent', 'baseSpr', [494, 62], true, 'jfkportraitevent', [2.35, 2.35]);
			var jfkEvent:FlxSprite;
			jfkEvent = roomSprites['jfkevent'];
			jfkEvent.animation.addByPrefix('shadowappear', 'shadowmanappears', 24, false);
			jfkEvent.animation.addByPrefix('shadowleave', 'shadowmanleaves', 24, false);
			jfkEvent.animation.addByPrefix('shot', 'shot', 24, false);
			jfkEvent.animation.addByPrefix('wound', 'wound', 24);
			jfkEvent.animation.addByPrefix('fine', 'fine', 24);
			jfkEvent.animation.play((roomVars.exists('jfkshot') && roomVars['jfkshot'] == true ? 'wound' : 'fine'));

			updateRoomSprite.set('sentientpicofjfk', function(elapsed:Float) {
				if (roomVars['jfkshot']) {
					if (FlxG.mouse.overlaps(jfkEvent) && FlxG.mouse.justPressed)
						funnyTextThing((FlxG.random.float(1, 100) < 99.7 ? 'he is dead...' : "another head for the abomination"), [520, 200], 0.75, 600, 25);
				}
			});
			// the poster
			var poster:FlxSprite;
			poster = loadPortrait('jfk', 'jfkpainting', [485, 50], function() {
				if (!roomVars.exists('jfkshot' && curItemSelected != null)) {
					if (curItemSelected == 'jellydonut' && inventory.contains('jellydonut')) {
						toggleCanPress = false;
						volumeBGM(0.25, 0.5);
						curSound.loadEmbedded(Paths.sound(soundPath + "/jfkgetsshot"));
						curSound.play();
						dialogue('jfk_shot');
						portraitTime = 0.001;
						canPressAnything = false;
						itemLose('jellydonut');
						new FlxTimer().start(13.989, function(tmr:Flxtimer) {
							volumeBGM(0, 0.001);
							jfkEvent.animation.play('shot');
							new FlxTimer().start(2, function(tmr:FlxTimer) {
								jfkEvent.animation.play('shadowappear');
								jfkEvent.animation.finishCallback = function() {
									unlockTAPE('jelly-donut', false, 4, function() {
										jfkEvent.animation.play('shadowleave');
										jfkEvent.animation.finishCallback = function() {
											jfkEvent.animation.play('wound');
											canPressAnything = true;
											poster.visible = false;
											volumeBGM(0.7, 1);
										}
									});
								}
							});
						});
						roomVars.set('jfkshot', true);
					} else if (!roomVars['firstTimeJFK']) {
						var rando = FlxG.random.int(1, 3);
						curSound.loadEmbedded(Paths.sound(soundPath + "/jfkrando_" + rando));
						dialogue('jfkrando_' + rando);
						curSound.play();
						portraitTime = curSound.length / 1000;
					} else {
						curSound.loadEmbedded(Paths.sound(soundPath + "/jfkintrosegment"));
						curSound.play();
						dialogue('jfk_intro');
						portraitTime = curSound.length / 1000;
						// new flxtimer, uses `portraitTime`, gives you note once completed (TODO)
						new FlxTimer().start(portraitTime, function(jfk:FlxTimer) {
							roomVars['firstTimeJFK'] = false;
						});
					}
				}
			}, null);
			poster.visible = ((roomVars.exists('jfkshot') && roomVars['jfkshot'] == true ? false : true));

			closeRoomFunc.set('sentientpicofjfk', function() {
				jfkEvent.exists = false;
				poster.exists = false;
			});
		}
	},
	"ronaldreagan" => {
		downRoom: 'hallwayend',
		openFunc: function() {
			var ron:FlxSprite;
			ron = loadPortrait('ron', 'reaganpainting', [620, 165]);
			closeRoomFunc.set('ronaldreagan', function() {
				ron.exists = false;
			});
		}
	},
	// state dining room
	'diningroom' => {downRoom: 'diningroombehind', upRoom: 'diningviewright', leftRoom: 'diningviewfront'},
	'diningroombehind' => {
		upRoom: 'hallwayendbehind',
		downRoom: 'diningroom',
		rightRoom: 'diningredroom',
		leftRoom: 'diningviewright'
	},
	'diningredroom' => {
		downRoom: 'diningviewfront',
		rightRoom: 'diningviewleft',
		leftRoom: 'diningroombehind',
		upRoom: 'redroomcview'
	},
	'diningviewfront' => {rightRoom: 'diningroom', leftRoom: 'diningviewleft', downRoom: 'diningredroom'},
	'diningviewleft' => {
		leftArrowPOS: [250, 575],
		leftAngle: 5,
		rightAngle: -5,
		rightArrowPOS: [950, 575],
		rightRoom: 'diningviewfront',
		leftRoom: 'diningviewbehind'
	},
	'diningviewright' => {
		leftArrowPOS: [250, 575],
		leftAngle: 5,
		rightAngle: -5,
		rightArrowPOS: [950, 575],
		leftRoom: 'diningroom',
		downRoom: 'mysteryroom',
		rightRoom: 'diningviewbehind'
	},
	'diningviewbehind' => {rightRoom: 'diningviewleft', downRoom: 'abelincoln', leftRoom: 'diningviewright'},
	'abelincoln' => {downRoom: 'diningviewbehind'},
	'mysteryroom' => {downRoom: 'diningviewright'},
	// pianoarea
	'pianoarea' => {
		downRoom: 'pianoareabehind',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
		upRoom: 'pianoareainview',
		rightRoom: 'billpiano',
		leftRoom: 'bush'
	},
	'pianoareabehind' => {
		upRoom: 'hallwaymid',
		rightArrowPOS: [1100, 570],
		leftArrowPOS: [75, 570],
		downRoom: 'pianoarea',
		leftRoom: 'billpiano',
		rightRoom: 'bush'
	},
	'pianoareainview' => {
		rightArrowPOS: [1100, 570],
		leftArrowPOS: [75, 570],
		upRoom: 'pianoareabehind',
		leftRoom: 'pianotostairs',
		rightRoom: 'bush'
	},
	'pianotostairs' => {
		rightAngle: 15,
		rightArrowPOS: [850, 585],
		upRoom: '2floorstairs',
		downRoom: 'pianofromstairsview',
		rightRoom: 'billpiano'
	},
	'pianofromstairsview' => {
		leftArrowPOS: [175, 570],
		upArrowPOS: [600, 450],
		rightArrowPOS: [1150, 570],
		downArrowPOS: [590, 675],
		upAngle: -50,
		downRoom: 'pianotostairs',
		leftRoom: 'billpiano',
		rightRoom: 'pianoareainview',
		upRoom: 'pianoareabehind'
	},
	'billpiano' => {downRoom: 'pianoarea', leftRoom: 'pianotostairs', leftAngle: -25},
	'bush' => {
		rightAngle: 25,
		rightArrowPOS: [850, 575],
		downRoom: 'pianoarea',
		rightRoom: 'pianoareainview'
	},
	// west wing
	// OVAL OFFICE
	'ovalofficeview1' => {upRoom: 'resolutedeskview', downRoom: 'ovalofficepresidentspicture'},
	'resolutedeskview' => {upRoom: 'ovalofficedesk', downRoom: 'ovalofficebottomdoorclosed'},
	'ovalofficedesk' => {upRoom: 'ovalofficepresidentspicture'},
	'ovalofficepresidentspicture' => {downRoom: 'ovalofficeview1'},
	'ovalofficebottomdoorclosed' => {upRoom: 'resolutedeskview'}
];

// load room objects
public function loadRoomSprite(sprNAME:String, grp:String, pos:Array<Float>, animated:Bool, graphic:String, scale:Array<Float>) {
	if (!roomSprites.exists(sprNAME)) {
		var spr:FlxSprite = new FlxSprite(pos[0], pos[1]);
		if (animated)
			spr.frames = Paths.getSparrowAtlas(imagePath + "/" + graphic);
		else
			spr.loadGraphic(Paths.image(imagePath + "/" + graphic));
		spr.scale.set(scale[0], scale[1]);
		spr.updateHitbox();
		switch (grp) {
			case 'baseSpr':
				baseSpr.add(spr);
			case 'roomSpr':
				roomSpr.add(spr);
		}
		roomSprites.set(sprNAME, spr);
	} else {
		roomSprites[sprNAME].exists = true;
	}
}

public function funnyTextThing(txt:String, pos:Array<Float>, twnTime:Float, txtAcceleration:Float, ?size:Int = 45):FlxSprite {
	var txt:FlxText = new FlxText(pos[0], pos[1], 0, txt);
	txt.setFormat("fonts/THE PRESIDENT.ttf", size, FlxColor.WHITE, "center");
	txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txt.borderSize = 2;
	roomSpr.add(txt);
	txt.moves = true;
	txt.acceleration.x = -txtAcceleration / 1000;
	txt.acceleration.y = txtAcceleration;
	txt.velocity.set(FlxG.random.float(25, -25));
	FlxTween.tween(txt, {alpha: 0}, twnTime, {
		ease: FlxEase.linear,
		onComplete: function() {
			roomSpr.remove(txt);
		}
	});
}

public var portraitTime:Float = 1;
public var toggleCanPress:Bool = true;

public function loadPortrait(portraitSpr:String, graphic:String, pos:Array<Float>, ?onClick:Null<Void->Void>, ?onEnd:Null<Void->Void>) {
	var sprite:FlxSprite;
	loadRoomSprite(portraitSpr, 'roomSpr', pos, true, graphic, [2.35, 2.35]);
	sprite = roomSprites[portraitSpr];
	sprite.animation.addByPrefix('anim', 'daAnim', 4);
	sprite.animation.play('anim');
	sprite.antialiasing = false;
	sprite.alpha = 0.001;

	if (updatePortraits == null)
		updatePortraits = [];
	updatePortraits.push(function(elapsed:Float) {
		if (FlxG.mouse.overlaps(sprite) && canPressAnything && sprite.exists && sprite.visible) {
			sprite.alpha = 0.75;
			if (FlxG.mouse.justPressed) {
				toggleCanPress = true;
				if (onClick != null) {
					onClick();
					if (isInventoryUp)
						toggleBoxes();
					if (toggleCanPress) {
						canPressAnything = false;
						volumeBGM(0.25, 0.5);
					}
					new FlxTimer().start(portraitTime, function(tmr:FlxTimer) {
						if (onEnd != null)
							onEnd();
						if (toggleCanPress) {
							canPressAnything = true;
							volumeBGM(0.7, 1);
						}
					});
				}
			}
		} else
			sprite.alpha = 0.001;
	});

	return sprite;
}
