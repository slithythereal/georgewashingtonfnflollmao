import flixel.addons.text.FlxTypeText;
import flixel.system.FlxSound;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxTextBorderStyle;
import flixel.FlxCamera;

importScript("data/scripts/HandyDandyFunctions");
importScript("data/scripts/WhiteHouseHandler");
importScript('data/scripts/WhiteHouseDialogue');
public var canPause:Bool = true;
public var isPaused:Bool = false;
public var canPressAnything:Bool = true;
var canPressLEFT, canPressRIGHT, canPressUP, canPressDOWN:Bool = false;
var daPath:String = "minigames/whitehouse";
var soundPath:String = 'minigame/whitehouse_day';
public var mainCamera:FlxCamera;
public var camHUD:FlxCamera;

// music
public var inWHITEHOUSE:Bool = true;
public var bgmLIST:Array<String> = ['base', 'biden', 'jfk', 'kamala', 'trump'];
public var dayshiftBGM:Map<String, FlxSound> = [];
public var curTrack:String = '';
public var desiredVolume:Float = 0.5;

// tapes
public var unlockedTapes:Array<{songNAME:String, isSecret:Bool, id:Int}> = [];
public var tapeCount:Int = 0; // how many tapes obtained
public var tapeAmt:Int = 4; // total amt of tapes in game
var tapeCountSpr:FlxSprite;
var tapeCountTxt:FlxText;

// inventory
public var inventoryBoxes:FlxTypedGroup<FlxSprite>;
public var inventoryItems:FlxTypedGroup<FlxSprite>;
public var inventory:Array<String> = [];
public var curItemSelected:String = null;
public var curInventorySelected:Int = 0;
public var isInventoryUp:Bool = false;
var newInventory:Int;
public var inventoryLabel:FlxSprite;
var inventory1stTime:Bool = null;

// sprites
public var leftArrow:FlxSprite;
public var rightArrow:FlxSprite;
public var upArrow:FlxSprite;
public var downArrow:FlxSprite;
public var roomSprite:FlxSprite;

// groups
public var baseSpr:FlxGroup; // base sprites that are added in first
public var roomSpr:FlxGroup; // sprites that are added via the different rooms
public var subUIGRP:FlxGroup; // other UI (arrows)
// roomspritefunctions
public var updatePortraits:Array<Void->Float> = [];
public var updateRSArray:Array<Void->Float> = [];
public var updateRoomSprite:Map<String, Void->Float> = []; // updateRoomSprite.set("roomname", function(elapsed:Float))
public var closeRoomFunc:Map<String, Void->Void> = []; // closeRoomFunc.set("roomname", function())
public var pauseFunction:Map<String, Void->Bool> = []; // pauseFunction.set("roomname", function(isPaused:Bool))
// cache
public var roomVars:Map<String, Dynamic> = []; // room variables
public var roomSprites:Map<String, FlxObject> = []; // keeps roomsprites in cache for reviving
public var dialTxt:FlxText;

// main functions
function create() {
	FlxG.console.registerFunction('ResetState', function() {
		FlxG.switchState(new ModState('murica/WhiteHouseState'));
	});

	mainCamera = new FlxCamera(0, 0);
	FlxG.cameras.reset(mainCamera);
	FlxG.cameras.setDefaultDrawTarget(mainCamera, true);

	FlxG.cameras.add(camHUD = new FlxCamera(), false);
	camHUD.bgColor = FlxColor.TRANSPARENT;

	mainCamera.zoom = 1;
	FlxG.mouse.visible = true;
	mainCamera.alpha = 0;
	camHUD.alpha = 0;

	for (i => music in bgmLIST) {
		var musica:FlxSound = new FlxSound();
		FlxG.sound.list.add(musica);
		musica.loadEmbedded(Paths.music('minigames/whitehouse/dayshift_' + music), true);
		musica.play(true);
		musica.ID = i;
		musica.volume = 0;
		dayshiftBGM.set(music, musica);
	}

	baseSpr = new FlxGroup();
	add(baseSpr);

	roomSprite = new FlxSprite();
	roomSprite.loadGraphic(Paths.image(daPath + "/day/" + 'startroom'));
	roomSprite.scale.set(2.35, 2.35);
	roomSprite.updateHitbox();
	roomSprite.screenCenter();
	baseSpr.add(roomSprite);

	roomSpr = new FlxGroup();
	add(roomSpr);

	subUIGRP = new FlxGroup();
	add(subUIGRP);

	// INVENTORY
	inventoryBoxes = new FlxTypedGroup();
	add(inventoryBoxes);
	inventoryItems = new FlxTypedGroup();
	add(inventoryItems);

	inventoryLabel = new FlxSprite(0, 580);
	inventoryLabel.frames = Paths.getFrames(daPath + "/inventoryLabel");
	inventoryLabel.animation.addByPrefix('anim', 'inventorything', 4);
	inventoryLabel.animation.play('anim');
	inventoryLabel.scale.set(0.75, 0.75);
	inventoryLabel.updateHitbox();
	inventoryLabel.screenCenter(FlxAxes.X);
	subUIGRP.add(inventoryLabel);
	inventoryLabel.alpha = 0.75;
	inventoryLabel.visible = false;

	// arrows
	leftArrow = makeArrow([500, 575], 'leftarrow', false);
	subUIGRP.add(leftArrow);
	rightArrow = makeArrow([700, 575], 'leftarrow', true);
	subUIGRP.add(rightArrow);
	upArrow = makeArrow([600, 550], 'uparrow', false);
	subUIGRP.add(upArrow);
	downArrow = makeArrow([590, 600], 'downarrow', false);
	subUIGRP.add(downArrow);

	// tape
	tapeCountSpr = new FlxSprite(930, -700);
	tapeCountSpr.loadGraphic(Paths.image('minigames/VHSTAPE_normal'));
	tapeCountSpr.scale.set(0.075, 0.075);
	tapeCountSpr.updateHitbox();
	subUIGRP.add(tapeCountSpr);

	tapeCountTxt = new FlxText(tapeCountSpr.x + tapeCountSpr.width + 10, tapeCountSpr.y, 0, "");
	tapeCountTxt.text = tapeCount + "/" + tapeAmt;
	tapeCountTxt.setFormat("fonts/THE PRESIDENT.ttf", 45, FlxColor.WHITE, "center");
	tapeCountTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	tapeCountTxt.borderSize = 1.75;
	subUIGRP.add(tapeCountTxt);

	dialTxt = new FlxText(0, 525, 0, "");
	dialTxt.text = "";
	dialTxt.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
	dialTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	dialTxt.borderSize = 1;
	dialTxt.screenCenter(FlxAxes.X);
	add(dialTxt);
	dialTxt.cameras = [camHUD];

	// setting values
	for (arrow in [leftArrow, rightArrow, upArrow, downArrow])
		arrow.scrollFactor.set(0.5, 0.5);

	// camera
	mainCamera.setScrollBoundsRect(roomSprite.x, roomSprite.y, roomSprite.width, roomSprite.height);
	loadRoom(startRoom);

	FlxG.console.registerFunction('LoadRoom', function(room:String) {
		loadRoom(room.toLowerCase());
	});
	FlxG.console.registerFunction('giveItem', function(item:String) {
		itemGet(item);
	});

	FlxG.console.registerFunction('giveTape', function(tape:String, isSecret:Bool, id:Int) {
		unlockTAPE(tape, isSecret, id);
	});
}

function update(elapsed:Float) {
	if (!isPaused) {
		updateCameraStuffs(elapsed);
		updateArrows(elapsed);

		if (inventory.length >= 1 && canPressAnything)
			updateInventory(elapsed);

		// updates the room sprites
		if (updateRoomSprite.exists(curRoom))
			updateRoomSprite[curRoom](elapsed);
		if (updateRSArray != null)
			for (update in updateRSArray)
				update(elapsed);
		// updates portraits
		if (updatePortraits != null)
			for (update in updatePortraits)
				update(elapsed);

		if (canPressAnything) {
			if (FlxG.keys.justPressed.R)
				FlxG.switchState(new ModState('murica/WhiteHouseState'));

			if (controls.BACK) // pause screen
				pauseMenu();
		}
	}
}

function loadRoom(room:String) {
	// sets data values
	var previousRoom = curRoom;
	curRoom = room;
	canPressAnything = false;

	FlxG.watch.addQuick('current room', curRoom);

	if (isInventoryUp)
		toggleBoxes();

	for (group in [baseSpr, roomSpr, subUIGRP, inventoryItems, inventoryBoxes]) { // yea i made a for statement out of flxgroups, yall good?
		group.forEach(function(spr:FlxObject) {
			var curAlpha:Float = spr.alpha;
			FlxTween.tween(spr, {alpha: 0}, roomTimeVar, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween) {
					FlxTween.tween(spr, {alpha: curAlpha}, roomTimeVar, {ease: FlxEase.linear});
				}
			});
		});
	}

	FlxTween.tween(camHUD, {alpha: 0}, roomTimeVar, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			FlxTween.tween(camHUD, {alpha: 1}, roomTimeVar, {ease: FlxEase.linear});
		}
	});

	// timer
	new FlxTimer().start(roomTimeVar, function(tmr:FlxTimer) {
		if (mainCamera.alpha == 0)
			mainCamera.alpha = 1;

		if (closeRoomFunc.exists(previousRoom)) // calls close room func if exists
			closeRoomFunc[previousRoom]();

		roomSprite.loadGraphic(Paths.image(daPath + "/day/" + curRoom));

		// left, right, up, down
		setArrowPos([[500, 575], [700, 575], [600, 550], [590, 600]]);

		leftArrow.visible = canPressLEFT = (dayRooms[curRoom].leftRoom == null ? false : true);
		downArrow.visible = canPressDOWN = (dayRooms[curRoom].downRoom == null ? false : true);
		upArrow.visible = canPressUP = (dayRooms[curRoom].upRoom == null ? false : true);
		rightArrow.visible = canPressRIGHT = (dayRooms[curRoom].rightRoom == null ? false : true);

		leftArrow.angle = (dayRooms[curRoom].leftAngle != null ? dayRooms[curRoom].leftAngle : 0);
		rightArrow.angle = (dayRooms[curRoom].rightAngle != null ? dayRooms[curRoom].rightAngle : 0);
		upArrow.angle = (dayRooms[curRoom].upAngle != null ? dayRooms[curRoom].upAngle : 0);
		downArrow.angle = (dayRooms[curRoom].downAngle != null ? dayRooms[curRoom].downAngle : 0);

		for (i in [leftArrow, rightArrow, upArrow, downArrow])
			HandyDandy.watch(i);

		if (updatePortraits != null)
			updatePortraits = null;
		if (updateRSArray != null)
			updateRSArray = null;

		if (dayRooms[curRoom].openFunc != null)
			dayRooms[curRoom].openFunc();

		if (inWHITEHOUSE)
			// switchBGM((dayRooms[curRoom].newBGM != null ? dayRooms[curRoom].newBGM : 'base'));
			switchBGM('base');

		callForEach();
		new FlxTimer().start(roomTimeVar, function(tmr:FlxTimer) {
			canPressAnything = true;
		});
	});
}

// make functions
function makeArrow(pos:Array<Float>, anim:String, flipX:Bool):FlxSprite {
	var sprite:FlxSprite = new FlxSprite(pos[0], pos[1]);
	sprite.frames = Paths.getFrames(daPath + '/directionalarrows');
	sprite.animation.addByPrefix('anim', anim, 24, true);
	sprite.animation.play('anim');
	sprite.scale.set(1, 1);
	sprite.updateHitbox();
	sprite.flipX = flipX;
	sprite.antialiasing = sprite.visible = false;
	return sprite;
}

// update functions
function updateCameraStuffs(elapsed:Float) {
	var offset:Array<Float> = [-170, -200];
	var mouseIntensity:Float = 0.25;
	var cameraIntensity:Float = 0.5;
	if (canPressAnything && !isPaused) {
		mainCamera.scroll.x = FlxMath.lerp(mainCamera.scroll.x, FlxMath.lerp(offset[0], FlxG.mouse.screenX, mouseIntensity), cameraIntensity);
		mainCamera.scroll.y = FlxMath.lerp(mainCamera.scroll.y, FlxMath.lerp(offset[1], FlxG.mouse.screenY, mouseIntensity), cameraIntensity);
	}
}

function updateArrows(elapsed:Float) {
	for (arrow in [
		{spr: leftArrow, value: canPressLEFT},
		{spr: rightArrow, value: canPressRIGHT},
		{spr: upArrow, value: canPressUP},
		{spr: downArrow, value: canPressDOWN}
	]) {
		if (arrow.value == true && FlxG.mouse.overlaps(arrow.spr))
			arrow.spr.scale.set(1.25, 1.25);
		else
			arrow.spr.scale.set(1, 1);
	}

	if (FlxG.mouse.justPressed && canPressAnything && !isPaused) {
		if (FlxG.mouse.overlaps(leftArrow) && canPressLEFT) {
			loadRoom(dayRooms[curRoom].leftRoom);
			playSound((dayRooms[curRoom].leftRoomSound != null ? dayRooms[curRoom].leftRoomSound : 'fnaf4runsound'), 0.7);
		} else if (FlxG.mouse.overlaps(rightArrow) && canPressRIGHT) {
			loadRoom(dayRooms[curRoom].rightRoom);
			playSound((dayRooms[curRoom].rightRoomSound != null ? dayRooms[curRoom].rightRoomSound : 'fnaf4runsound'), 0.7);
		} else if (FlxG.mouse.overlaps(upArrow) && canPressUP) {
			loadRoom(dayRooms[curRoom].upRoom);
			playSound((dayRooms[curRoom].upRoomSound != null ? dayRooms[curRoom].upRoomSound : 'fnaf4runsound'), 0.7);
		} else if (FlxG.mouse.overlaps(downArrow) && canPressDOWN) {
			loadRoom(dayRooms[curRoom].downRoom);
			playSound((dayRooms[curRoom].downRoomSound != null ? dayRooms[curRoom].downRoomSound : 'fnaf4runsound'), 0.7);
		}
	}
}

// set functions
public function setArrowPos(defaultPos:Array<Array<Float>>) {
	var posVariableArray:Array<Array<Float>> = [];

	posVariableArray.push(dayRooms[curRoom].leftArrowPOS);
	posVariableArray.push(dayRooms[curRoom].rightArrowPOS);
	posVariableArray.push(dayRooms[curRoom].upArrowPOS);
	posVariableArray.push(dayRooms[curRoom].downArrowPOS);

	var spriteArray = [leftArrow, rightArrow, upArrow, downArrow];

	for (i => posVariable in posVariableArray) {
		var pos1:Float = (posVariable != null ? posVariable[0] : defaultPos[i][0]);
		var pos2:Float = (posVariable != null ? posVariable[1] : defaultPos[i][1]);
		spriteArray[i].setPosition(pos1, pos2);
	}
}

public function callForEach() {
	for (i in [inventoryItems, inventoryBoxes]) {
		i.forEach(function(spr:FlxSprite) {
			spr.scrollFactor.set(0.25, 0.25);
		});
	}
	subUIGRP.forEach(function(spr:FlxSprite) {
		spr.scrollFactor.set(0.5, 0.5);
	});
}

// sound/music functions
public function playSound(sound:String, volume:Float)
	FlxG.sound.play(Paths.sound(soundPath + "/" + sound), volume);

public function switchBGM(track:String) {
	if (bgmLIST.contains(track) && curTrack != track) {
		for (name in bgmLIST) {
			if (name == curTrack)
				dayshiftBGM[curTrack].fadeOut(0.7, 0);
			else if (name == track)
				dayshiftBGM[name].fadeIn(0.7, 0, desiredVolume);
		}
		curTrack = track;
		FlxG.watch.addQuick('CURTRACK', curTrack);
	}
}

public function volumeBGM(volume:Float, time:Float) {
	desiredVolume = volume;
	var oldVolume:Float = dayshiftBGM[curTrack]?.volume;
	if (oldVolume < volume)
		dayshiftBGM[curTrack].fadeIn(time, oldVolume, volume);
	else if (oldVolume > volume)
		dayshiftBGM[curTrack].fadeOut(time, volume);
}

// tape get functions
public function unlockTAPE(daTape:String, isSecret:Bool, tapeID:Int, ?closeFunc:Null<Void->Void> = null) {
	var info:{
		tape:String,
		secret:Bool,
		id:Int,
		closeFunc:Void->Void
	} = {
		tape: daTape,
		secret: isSecret,
		id: tapeID,
		closeFunc: closeFunc
	};
	var substate:ModSubState = new ModSubState('murica/minigame/TapeGet', {
		onOpen: function() {
			isPaused = true;
		},
		isTapeSecret: info.secret,
		onClose: function() {
			isPaused = false;
			unlockedTapes.push({songNAME: info.tape, isSecret: info.secret, id: info.id});
			if (info.closeFunc != null)
				info.closeFunc();
			updateTapeCount(info.secret);
		}
	});
	substate.cameras = [camHUD];
	openSubState(substate);
}

function updateTapeCount(secret:Bool) { // TODO: add pause menu stuff when get chance
	if (!secret)
		tapeCount += 1;
	tapeCountTxt.text = tapeCount + "/" + tapeAmt;

	for (i in [tapeCountSpr, tapeCountTxt]) {
		FlxTween.tween(i, {y: 0}, 0.6, {
			ease: FlxEase.quintOut,
			onComplete: function(twn:FlxTween) {
				new FlxTimer().start(0.6, function(tmr:FlxTimer) {
					FlxTween.tween(i, {y: -700}, 0.4, {ease: FlxEase.quintIn});
				});
			}
		});
	}
}

// inventory functions
public function itemGet(item:String) {
	if (!inventory.contains(item.toLowerCase())) {
		if (inventory1stTime == null)
			inventoryLabel.visible = inventory1stTime = true;
		inventory.push(item.toLowerCase());
		callInventorySprites();
		playSound('item_pickup', 0.7);
	}
}

public function itemLose(item:String) {
	if (inventory.contains(item.toLowerCase())) {
		inventory.remove(item.toLowerCase());
		callInventorySprites();
	}
}

public function toggleBoxes() {
	isInventoryUp = !isInventoryUp;

	if (inventory.length >= 1 && inventory1stTime)
		inventoryLabel.visible = inventory1stTime = false;

	for (i in [inventoryBoxes, inventoryItems]) {
		i.forEach(function(item:FlxSprite) {
			FlxTween.tween(item, {y: (isInventoryUp ? 630 : 800)}, 0.25, {ease: (isInventoryUp ? FlxEase.cubeIn : FlxEase.cubeOut)});
		});
	}

	// item selected stuff
	if (curItemSelected != null) {
		inventoryItems.forEach(function(item:FlxSprite) {
			if (curItemSelected == inventory[item.ID])
				item.scale.set(1, 1);
		});
		inventoryBoxes.forEach(function(box:FlxSprite) {
			if (curItemSelected == inventory[box.ID])
				box.alpha = 0.5;
		});
		curItemSelected = null;
		FlxG.watch.addQuick('CUR ITEM SELECTED', curItemSelected);
	}
}

public function callInventorySprites() {
	curItemSelected = null;
	FlxG.watch.addQuick('CUR ITEM SELECTED', curItemSelected);

	for (i in [inventoryBoxes, inventoryItems])
		i.clear();

	if (inventory.length >= 1) {
		for (i => item in inventory) {
			var splitNUM:Float = 110;
			var box:FlxSprite = new FlxSprite(0, 800);
			box.frames = Paths.getSparrowAtlas(daPath + "/ui/inventorybox");
			box.animation.addByPrefix('anim', 'inventorybox', 4);
			box.animation.play('anim');
			box.scale.set(1, 1);
			box.updateHitbox();
			box.ID = i;
			box.alpha = 0.5;
			inventoryBoxes.add(box);

			var item:FlxSprite = new FlxSprite(0, 800);
			item.loadGraphic(Paths.image(daPath + "/ui/items/" + inventory[i]));
			item.scale.set(1, 1);
			item.updateHitbox();
			item.screenCenter(FlxAxes.X);
			if (inventory.length > 1)
				item.x -= (splitNUM * i) - (splitNUM / 2);
			item.ID = i;
			inventoryItems.add(item);
			box.x = item.x;
		}
	}
	callForEach();
}

public function updateInventory(elapsed:Float) {
	if (FlxG.keys.justPressed.TAB)
		toggleBoxes();

	for (item in inventoryItems) {
		if (FlxG.mouse.overlaps(item)) {
			if (newInventory != item.ID || newInventory == null) {
				newInventory = item.ID;
				curInventorySelected = item.ID;
				inventoryBoxes.forEach(function(box:FlxSprite) {
					box.alpha = (box.ID == curInventorySelected ? 1 : 0.5);
				});
			}
			if (FlxG.mouse.justPressed) {
				var funnyScale:Float = (curItemSelected != inventory[item.ID] ? 1.2 : 1);
				FlxG.watch.addQuick('CUR ITEM SELECTED', curItemSelected);
				FlxTween.tween(item, {"scale.x": funnyScale, "scale.y": funnyScale}, 0.15,
					{ease: (curItemSelected != inventory[item.ID] ? FlxEase.cubeIn : FlxEase.cubeOut)});

				curItemSelected = (curItemSelected != inventory[item.ID] ? inventory[item.ID] : null);
			}
		}
	}
	if (!FlxG.mouse.overlaps(inventoryItems)) {
		newInventory = null;
		for (box in inventoryBoxes)
			box.alpha = 0.5;
	}
}

function pauseMenu() {
	var substate:ModSubState = new ModSubState('murica/minigame/WhiteHousePauseSubstate', {
		onOpen: function() {
			isPaused = true;
		},
		onClose: function() {
			isPaused = false;
		}
	});
	substate.cameras = [camHUD];
	openSubState(substate);
}

// dialogue
var curDial:Int = 0;
var curDialColor:String = '#ffffff';

public function startDialogue(dialogue:String) {
	if (FlxG.save.data.subtitlesGW) {
		var dialReps:Int = dayDial[dialogue].length - 1;
		curDial = 0;
		dialogueNextLine(dialogue, dialReps);
	}
}

var dialogueTimer:FlxTimer = null;

function dialogueNextLine(dialogue:String, totalReps:Int) {
	if (curDial >= totalReps + 1) {
		dialTxt.text = '';
		switchBGM('base');
		return;
	}

	var dialLine = dayDial[dialogue][curDial].line;
	var dialColor = dayDial[dialogue][curDial].color;
	setDialogueText(dialLine, dialColor);

	var dialTime = dayDial[dialogue][curDial].time;
	if (dialogueTimer != null && !dialogueTimer.finished)
		dialogueTimer.destroy();
	dialogueTimer = new FlxTimer().start(dialTime, function(tmr:FlxTimer) {
		curDial++;
		dialogueNextLine(dialogue, totalReps);
	});
}

function setDialogueText(dialogueLine:String, color:String) {
	dialTxt.text = dialogueLine;
	dialTxt.screenCenter(FlxAxes.X);
	dialTxt.scale.set(1.2, 1.2);
	FlxTween.tween(dialTxt, {"scale.x": 1, "scale.y": 1}, 0.05, {ease: FlxEase.linear});
	if (curDialColor != color && color != null) {
		curDialColor = color;
		dialTxt.color = FlxColor.fromString(curDialColor);
	}
}
