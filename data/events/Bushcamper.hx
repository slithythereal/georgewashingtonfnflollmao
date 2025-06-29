import funkin.game.Character;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxTextBorderStyle;
import funkin.game.PlayState;
import funkin.backend.system.Conductor;

// 9 beats until actual dodge starts
var testSpr:FlxSprite;
var bushCamperGrp:FlxTypedGroup<Character>;
var camperRightArray:Array<Bool> = [];
var camperRightMap:Map<Int, Bool> = []; // detects character via ID
var moveSpeed:Float = 400;
var camperDodgeStarted:Map<Int, Bool> = [];
var startPosLeft:Float = -1650;
var startPosRight:Float = 1950;
var restPosRight:Float = 1100;
var restPosLeft:Float = -1000;
var isDodgeON:Bool = false;
var isDodging:Bool = false;
var isDodgeEagON:Bool = false;
var dodgeCountEag:Int = 4;
var dodgeCountBF:Int = 4;
var spacebarDodge:FlxText;
var camperShotGun:Map<Int, Bool> = [];
var bfDodge:FlxSprite;
var eagDodge:FlxSprite;
var dodgingRN:Bool = false;
var eagCam:Array<Float> = [];
var bfCam:Array<Float> = [];
var oldCamPos:Array<Float> = [];

// IMPORTANT
var bushcamperIDArray:Array<Int> = [];
var bushcamperTotal:Int = 0;
var curCamper:Int = 0;
var camperMap:Map<Int, Character> = [];

// LOADING AND PRECACHING
function create()
{
	getCameraPos();
	testSpr = stage.stageSprites["bushcamper"];
	testSpr.alpha = 0;

	bushCamperGrp = new FlxTypedGroup();
	insert(members.indexOf(testSpr), bushCamperGrp);

	eagDodge = new FlxSprite(dad.x - 625, dad.y - 150);
	eagDodge.frames = Paths.getSparrowAtlas('mechanics/eagnitedodge');
	eagDodge.scale.set(dad.scale.x, dad.scale.y);
	eagDodge.animation.addByPrefix('dodge', 'dodge', 24, false);
	eagDodge.updateHitbox();
	add(eagDodge);
	eagDodge.visible = false;

	bfDodge = new FlxSprite(boyfriend.x, boyfriend.y + 375);
	bfDodge.frames = Paths.getSparrowAtlas('mechanics/boyfrienddodge');
	bfDodge.scale.set(boyfriend.scale.x, boyfriend.scale.y);
	bfDodge.animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);
	bfDodge.updateHitbox();
	add(bfDodge);
	bfDodge.visible = false;

	spacebarDodge = new FlxText(0, 525, 0, "");
	spacebarDodge.setFormat("fonts/fortnite.otf", 75, FlxColor.WHITE, "center");
	spacebarDodge.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 5);
	spacebarDodge.screenCenter(FlxAxes.X);
	add(spacebarDodge);
	spacebarDodge.cameras = [camHUD];
	spacebarDodge.visible = false;
}

function postCreate()
{
	for (event in PlayState.SONG.events) 
	{
		if (event.name == 'Bushcamper')
		{
			precacheCharacter(event.params[0]);
			trace(event.params[0]);
		}
	}

	bushcamperTotal = bushcamperIDArray.length;
	trace("BUSHCAMPER TOTAL: " + bushcamperTotal);
	for(camperID in bushcamperIDArray){
		trace('BUSH ID ' + camperID + "is set to " + camperRightMap[camperID]);
	}
}

function precacheCharacter(targetsBF:Bool)
{
	var characterNAME:String = 'bushcamper1';

	if (FlxG.random.int(0, 100) <= 50)
		characterNAME = 'bushcamper2';
	else if (FlxG.random.int(0, 100) <= 1)
		characterNAME = 'bushcamperS'; // SECRET
	else
		characterNAME = 'bushcamper1';

	var character:Character = new Character((targetsBF ? startPosRight : startPosLeft), 100, 'other/' + characterNAME, false);
	character.moves = true;
	character.scale.set(0.75, 0.75);
	character.updateHitbox();
	character.playAnim('move');
	character.flipX = targetsBF;
	bushCamperGrp.add(character);
	camperRightMap.set(character.ID, targetsBF);
	camperDodgeStarted.set(character.ID, false);
	camperShotGun.set(character.ID, false);
	bushcamperIDArray.push(character.ID);
	camperMap.set(character.ID, character);
	character.active = character.visible = false;
}

// SPAWNS BUSHCAMPER
function summonBushcamper()
{
	var character:Character = camperMap[bushcamperIDArray[curCamper]];
	character.active = character.visible = true;
	curCamper += 1;
	trace('Bushcamper Summoned');
	trace('cur camper: ' + curCamper);
	trace('TARGETS BOYFRIEND: ' + camperRightMap[character.ID]);
}

// UPDATE/BEATHIT FUNCTUIONS
function beatHit(curBeat:Int)
{
	bushCamperGrp.forEachAlive(function(bush:Character)
	{
		if (bush.active && bush.visible)
		{
			// bush moving
			if (curBeat % 4 == 0)
			{
				if (camperRightMap[bush.ID]) // BF DODGE
				{
					if (!camperDodgeStarted[bush.ID])
					{
						if (bush.x <= restPosRight)
						{
							bushAnimStuff(bush, "aim");
							dodgeCountBF = 4;
						}
						else
						{
							bush.playAnim('move');
							bush.velocity.x -= moveSpeed;
						}
					}
				}
				else // EAG DODGE
				{
					if (!camperDodgeStarted[bush.ID])
					{
						if (bush.x >= restPosLeft)
						{
							bushAnimStuff(bush, "aim");
							dodgeCountEag = 4;
						}
						else
						{
							bush.playAnim('move');
							bush.velocity.x += moveSpeed;
						}
					}
				}
			}
			else
				bush.velocity.x = 0;

			// DODGE
			if (camperDodgeStarted[bush.ID] && !camperShotGun[bush.ID])
			{
				if (curBeat % 2 == 0)
				{
					if (!camperRightMap[bush.ID])
					{
						// EAG DODGE
						if (dodgeCountEag > 0)
							dodgeCountEag -= 1;
						else
						{
							dodgingRN = true;
							oldCamPos = [camFollow.x, camFollow.y];
							camFollow.setPosition(eagCam[0], eagCam[1]);
							camperShotGun[bush.ID] = true;
							bushAnimStuff(bush, "shoot");
							FlxG.sound.play(Paths.sound('eagdodgesfx'));
							dad.visible = false;
							eagDodge.visible = true;
							eagDodge.animation.play('dodge');
							new FlxTimer().start(0.7, function(tmr:FlxTimer)
							{
								bushAnimStuff(bush, 'die');
							});
							eagDodge.animation.finishCallback = function()
							{
								dodgingRN = false;
								camFollow.setPosition(oldCamPos[0], oldCamPos[1]);
								eagDodge.visible = false;
								dad.visible = true;
							};
						}
					}
					else
					{
						// BF DODGE
						if (dodgeCountBF > 0)
							dodgeCountBF -= 1;
						else
						{
							bushAnimStuff(bush, "shoot");
							spacebarDodge.text = '';

							new FlxTimer().start(0.30, function(dbz:Flxtimer)
							{
								camperShotGun[bush.ID] = true;

								if (!isDodging)
									gameOver(boyfriend);
								else
								{
									isDodging = false;
									spacebarDodge.visible = false;

									bush.playAnim('move');
									new FlxTimer().start(0.25, function(dbz:FlxTimer)
									{
										dodgingRN = false;
										camFollow.setPosition(oldCamPos[0], oldCamPos[1]);
										FlxG.sound.play(Paths.sound('cartoonrun'));
										FlxTween.tween(bush, {x: 2000}, 0.7, {
											ease: FlxEase.linear,
											onComplete: function(twn:FlxTween)
											{
												bushAnimStuff(bush, "die");
											}
										});
									});
								}
							});
						}
						switch (dodgeCountBF)
						{
							case 3:
								spacebarDodge.color = FlxColor.WHITE;
								spacebarDodge.visible = true;
								spacebarDodge.text = "PREPARE TO DODGE";
								spacebarDodge.screenCenter(FlxAxes.X);
							case 2:
								spacebarDodge.visible = false;
							case 0:
								dodgingRN = true;
								oldCamPos = [camFollow.x, camFollow.y];
								camFollow.setPosition(bfCam[0], bfCam[1]);
								spacebarDodge.visible = true;
								spacebarDodge.text = "DODGE!";
								spacebarDodge.screenCenter(FlxAxes.X);
						}
					}
				}
			}
		}
	});
}

function update(elapsed:Float) // PRESS SPACEBAR
{
	if (FlxG.keys.justPressed.SPACE && !isDodging && dodgeCountBF == 0)
	{
		boyfriend.visible = false;
		bfDodge.visible = true;
		bfDodge.animation.play("dodge", true); // make bf invisible then make visible, make dodge visible then invisible
		isDodging = true;
		spacebarDodge.color = 0xFF09FF00;
		bfDodge.animation.finishCallback = function()
		{
			bfDodge.visible = false;
			boyfriend.visible = true;
		};
	}
}

function bushAnimStuff(bush:Character, move:String)
{
	switch (move)
	{
		case "aim":
			bush.playAnim('aim');
			camperDodgeStarted[bush.ID] = true;
		case "shoot":
			bush.playAnim('shoot');
			FlxG.sound.play(Paths.sound('cartoongun'));
		case 'die':
			bush.animation.play('die');
			bush.animation.finishCallback = function()
			{
				camperDodgeStarted.remove(bush.ID);
				camperRightMap.remove(bush.ID);
				camperShotGun.remove(bush.ID);
				bushCamperGrp.remove(bush, true);
				new FlxTimer().start(1, function(jjk:FlxTimer)
				{
					remove(bush);
					bush.destroy();
				});
			};
	}
}

// ON EVENTS
function onEvent(_)
	if (_.event.name == 'Bushcamper')
		summonBushcamper();

function onCameraMove(event)
	if (dodgingRN)
		event.cancel(true);

// DATA FUNCTIONS
function getCameraPos()
{
	for (c in strumLines.members[0].characters)
	{
		var cpos = c.getCameraPosition();
		eagCam = [cpos.x, cpos.y];
	}
	for (c in strumLines.members[1].characters)
	{
		var cpos = c.getCameraPosition();
		bfCam = [cpos.x, cpos.y];
	}
}
