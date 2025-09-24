import flixel.system.FlxSound;
import flixel.text.FlxTextBorderStyle;

importScript("data/scripts/HandyDandyFunctions");
// main data
public var isNight:Bool = false;
public var curRoom:String = "startroom";
public var startRoom:String = 'stairsoval'; // startroom
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
 * curSection: used for the map system, shows what room you're in
 * mapAngle: angle for the player character on the map
 * mapPos: position for the player character on the map
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
							funnyTextThing('get some tapes first...\n' + tapeCount + "/" + tapeAmt + " tapes collected", [520, 365], 0.75, 300, 25);
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
		leftRoom: 'redrooma',
		openFunc: function() {
			if (!roomVars.exists('guard1st'))
				roomVars.set('guard1st', false);
			if (!roomVars.exists('inviteAccepted'))
				roomVars.set('inviteAccepted', false);

			loadRoomSprite('guard', 'baseSpr', [430, 100], true, 'characters/ovalguard', [2.35, 2.35]);
			var guard:FlxSprite;
			guard = roomSprites['guard'];
			guard.animation.addByPrefix('signdown', 'guardsignidle', 1, false);
			guard.animation.addByPrefix('signmove', 'guardsignfling_', 24, false);
			guard.animation.addByPrefix('signmoveBW', 'guardsignflingbackwards', 24, false);
			guard.animation.addByPrefix('signup', 'guardsignhung', 1, false);
			guard.animation.play('signdown');
			guard.scale.set(0.75, 2.35);
			guard.updateHitbox();
			guard.scale.set(2.35, 2.35);
			guard.origin.set(115, 290);
			HandyDandy.watch(guard);

			new FlxTimer().start(roomTimeVar + 0.01, function(tmr:FlxTimer) {
				// volumeBGM(0.25, 0.5);
				if (roomVars['guard1st'] == false) {
					canPressAnything = false;
					playDialSound('agent_halt', false);
					guard.animation.play('signmove');
					startDialogue('agent_halt');
					new FlxTimer().start(curSound.length / 1000, function(tmr:FlxTimer) {
						roomVars.set('guard1st', true);
					});
				} else if (roomVars['inviteAccepted'] == true) {
					canPressAnything = false;
					FlxTween.tween(guard, {x: -145}, 0.45, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							canPressAnything = true;
						}
					});
				} else if (inventory.contains('invitation')) {
					playDialSound('agent_hasinvite', false);
					// TODO: dialogue
				} else {
					var rando:Int = FlxG.random.int(1, 5);
					guard.animation.play('signmove');

					playDialSound('agentran_' + rando, false);
					startDialogue('agentran_' + rando);
				}
			});

			updateRoomSprite.set('stairsoval', function(elapsed:Float) {
				if (FlxG.mouse.overlaps(guard) && FlxG.mouse.justPressed && canPressAnything && roomVars['inviteAccepted'] == false) {
					if (curItemSelected == 'invitation' && inventory.contains('invitation')) {
						canPressAnything = false;
						trace("WORKS");
						guard.animation.play('signmoveBW');
						roomVars.set('inviteAccepted', true);
						itemLose('invitation');
						FlxTween.tween(guard, {x: -145}, 0.45, {
							ease: FlxEase.linear,
							onComplete: function(twn:FlxTween) {
								playDialSound('agent_escort', false);
								// TODO: dialogue
							}
						});
					} else
						funnyTextThing('you need an invitation...', [520, 365], 0.75, 600, 45);
				}
			});

			closeRoomFunc.set('stairsoval', function() {
				guard.exists = false;
			});
		},
	},
	'redrooma' => {
		downRoom: '1floorstairs',
		rightRoom: 'stairsoval',
		leftRoom: '1floor2doorsbehind',
		upRoom: 'redroomaview',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570]
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
	'1floor2doorsbehind' => {
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
		downRoom: '1floor2doors',
		downRoomSound: shortStep,
		upRoom: '1floorhallwaybehind',
		leftRoom: "redroomb",
		rightRoom: "yellowroom"
	},
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
			makeItem('key1', 'key', [612, 415], [1, 1], [1.2, 1.2], null);
			var key:FlxSprite = roomSprites['key1'];
			key.angle = -130;
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
		rightRoom: 'bigroomview2',
		leftAngle: 17.5,
		rightAngle: -40,
		rightArrowPOS: [700, 570],
		curSection: 'eastroom'
	},
	'bigroomview1behind' => {
		upRoom: '2floorstairs',
		downRoom: 'bigroomview1',
		leftRoom: 'hallwaydoor',
		rightRoom: 'mckinleyposter',
		rightAngle: 25,
		rightArrowPOS: [845, 615],
		leftAngle: -25,
		leftArrowPOS: [325, 615],
		curSection: 'eastroom'
	},
	'mckinleyposter' => {
		downRoom: 'bigroomview1',
		rightRoom: 'marthaposter',
		downRoom: 'bigroomview1',
		rightArrowPOS: [1100, 570],
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('mckinleyposter', 'mckinleypainting', [510, 130], function() {
				playDialSound('mckinley', true);
			}, null);
			closeRoomFunc.set('mckinleyposter', function() {
				poster.exists = false;
			});
		},
		curSection: 'eastroom'
	},
	'marthaposter' => {
		leftRoom: 'mckinleyposter',
		rightRoom: 'georgeposter',
		downRoom: 'right2doors',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('martha', 'marthapainting', [530, -45]);
			closeRoomFunc.set('marthaposter', function() {
				poster.exists = false;
			});
		},
		curSection: 'eastroom'
	},
	'georgeposter' => {
		leftRoom: 'marthaposter',
		rightRoom: 'teddyposter',
		downRoom: 'left2doors',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
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
							playDialSound('georgepaintingv1', true);
							startDialogue('george_intro');
						} else if (roomVars['georgeClickCount'] >= 14) {
							playDialSound('george50times', true);
							startDialogue('george_secret');
							roomVars['georgeGone'] = true;
							poster.visible = false;
							new FlxTimer().start(curSound.length / 1000, function(tmr:FlxTimer) {
								unlockTAPE('eagnite', true, 5);
							});
						} else {
							var rando = FlxG.random.int(1, 4);
							playDialSound('georgepaintingv2_' + rando, true);
							startDialogue('georgerando_' + rando);
						}
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
		},
		curSection: 'eastroom'
	},
	'teddyposter' => {
		leftRoom: 'georgeposter',
		downRoom: 'left2doors',
		leftArrowPOS: [325, 615],
		leftAngle: -25,
		openFunc: function() {
			var poster:FlxSprite;
			poster = loadPortrait('teddy', 'teddypainting', [360, 45], function() {
				var rando = FlxG.random.int(1, 16);
				playDialSound('teddy_' + rando, true);
				startDialogue('teddy_' + rando);
			}, null);

			closeRoomFunc.set('teddyposter', function() {
				poster.exists = false;
			});
		},
		curSection: 'eastroom'
	},
	'bigroomview2' => {
		downRoom: 'bigroomview1behind',
		leftRoom: 'marthaposter',
		rightRoom: 'hallwaydoor',
		upRoom: 'left2doors',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
		curSection: 'eastroom'
	},
	'left2doors' => {
		downRoom: 'georgeposter',
		rightRoom: 'hallwaydoor',
		rightArrowPOS: [1000, 575],
		leftArrowPOS: [120, 575],
		leftRoom: 'teddyposter',
		rightAngle: -40,
		leftAngle: -25,
		upRoom: 'greenroomdoor',
		curSection: 'eastroom'
	},
	'hallwaydoor' => {
		downRoom: 'bigroomview3',
		leftRoom: 'greenroomdoor',
		rightRoom: 'bigroomview1behind',
		upRoom: 'hallway',
		leftArrowPOS: [75, 570],
		rightArrowPOS: [1100, 570],
		curSection: 'eastroom'
	},
	'bigroomview3' => {
		downRoom: 'hallwaydoor',
		leftRoom: 'right2doors',
		rightRoom: 'left2doors',
		leftAngle: -17.5,
		rightAngle: 17.5,
		leftArrowPOS: [320, 575],
		rightArrowPOS: [855, 575],
		curSection: 'eastroom'
	},
	'right2doors' => {
		leftRoom: 'hallwaydoor',
		downRoom: 'marthaposter',
		upRoom: 'bigroomview1behind',
		rightRoom: 'mckinleyposter',
		leftAngle: -10,
		leftArrowPOS: [75, 575],
		rightAngle: -15,
		rightArrowPOS: [1100, 565],
		curSection: 'eastroom'
	},
	'greenroomdoor' => {
		downRoom: 'left2doors',
		rightRoom: 'hallwaydoor',
		upRoom: 'greenroom',
		rightArrowPOS: [1100, 570],
		curSection: 'eastroom'
	},
	// red room a
	// green room
	'greenroom' => {
		downRoom: 'greenroombehind',
		upRoom: 'greenroompainting',
		upAngle: 17.5,
		downAngle: 17.5,
		upArrowPOS: [615, 550],
		rightRoom: "greenroombehind2",
		rightArrowPOS: [1100, 650],
		rightAngle: 45,
		leftRoom: "greenroombehind3",
		leftArrowPOS: [1100, 575],
		leftAngle: -250
	},
	'greenroombehind' => {downRoom: 'greenroom', upRoom: 'left2doors'},
	'greenroombehind2' => {downRoom: 'greenroom', upRoom: 'hallway'},
	'greenroompainting' => {
		downRoom: 'greenroom',
		rightRoom: 'greenroombehind3',
		rightArrowPOS: [1100, 570]
	},
	'greenroombehind3' => {
		downRoom: 'greenroom',
		leftRoom: 'greenroompainting',
		upRoom: 'ovalviewleft',
		leftArrowPOS: [75, 570]
	},
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
					playDialSound('taftgivemcdonald', true);
					taftEvent.animation.play('giveMac');
					taftEvent.animation.finishCallback = function() {
						taftEvent.animation.play('default');
					}
					new FlxTimer().start(portraitTime, function(tmr:FlxTimer) {
						itemGet('bigmac');
						roomVars['firstTimeTaft'] = false;
					});
				} else {
					var rando:Int = FlxG.random.int(1, 3);
					playDialSound('taftrandom_' + rando, true);
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
		rightRoom: 'ovalroom'
	},
	'ovalviewright' => {
		downRoom: 'ovalroombehind',
		rightRoom: 'redovalroom',
		upRoom: 'ovalroomwindow',
		leftRoom: 'ovalroom'
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
				playDialSound('carterrandom_' + rando, true);
				startDialogue('carter_' + rando);
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
					playDialSound('jfkpsst', false);
					startDialogue('jfk_psst');
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
						playDialSound('jfkgetsshot', false, false);
						startDialogue('jfk_shot');
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
											roomVars.set('jfkshot', true);
											canPressAnything = true;
											poster.visible = false;
											volumeBGM(0.7, 1);
										}
									});
								}
							});
						});
					} else if (!roomVars['firstTimeJFK']) {
						var rando = FlxG.random.int(1, 3);
						playDialSound('jfkrando_' + rando, true);
						startDialogue('jfkrando_' + rando);
					} else {
						playDialSound('jfkintrosegment', true);
						startDialogue('jfk_intro');
						// new flxtimer, uses `portraitTime`, gives you note once completed (TODO)
						new FlxTimer().start(portraitTime, function(jfk:FlxTimer) {
							roomVars['firstTimeJFK'] = false;
						});
					}
					switchBGM('jfk');
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

public function playDialSound(soundFile:String, isPortrait:Bool, ?hasTimer:Null<Bool> = true) {
	curSound.loadEmbedded(Paths.sound(soundPath + "/" + soundFile));
	curSound.play();
	if (isPortrait)
		portraitTime = curSound.length / 1000;
	if (hasTimer || hasTimer == null) {
		canPressAnything = false;
		volumeBGM(0.25, 0.5);
		new FlxTimer().start(curSound.length / 1000, function(tmr:FlxTimer) {
			canPressAnything = true;
			volumeBGM(0.7, 1);
		});
	}
}

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

public function makeItem(item:String, sprite:String, pos:Array<Float>, scaleReg:Array<Float>, scaleOverlap:Array<Float>, pressFunc:Void->Void) {
	loadRoomSprite(item, 'roomSpr', pos, false, sprite, scaleReg);
	var daItem:FlxSprite;
	daItem = roomSprites[item];
	var getItem:String = item + '_get';
	if (!roomVars.exists(getItem))
		roomVars.set(getItem, false);

	if (roomVars.exists(getItem) && roomVars[getItem] == true)
		daItem.visible = false;

	if (updateRSArray == null)
		updateRSArray = [];

	updateRSArray.push(function(elapsed:Float) {
		if (roomVars[getItem] == false) {
			if (FlxG.mouse.overlaps(daItem)) {
				FlxTween.tween(daItem, {"scale.x": scaleOverlap[0], "scale.y": scaleOverlap[1]}, 0.05, {ease: FlxEase.cubeIn});
				if (FlxG.mouse.justPressed) {
					if (pressFunc != null)
						pressFunc();
					roomVars.set(getItem, true);
					itemGet(sprite);
					daItem.visible = false;
				}
			} else
				FlxTween.tween(daItem, {"scale.x": scaleReg[0], "scale.y": scaleReg[1]}, 0.05, {ease: FlxEase.cubeIn});
		}
	});
}
