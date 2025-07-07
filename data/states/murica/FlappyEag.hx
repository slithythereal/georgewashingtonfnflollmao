import flixel.FlxObject;
import flixel.sound.FlxSound;
import funkin.options.Options;
import flixel.text.FlxTextBorderStyle;

var player:FlxSprite;

var timer:Float = 1;
var maxTimer:Float = 1;
var pipes:FlxTypedGroup = new FlxTypedGroup();

var points:Int = 0;
var pointsText:FlxText;
var pressButton:FlxText;

var dead:Bool = false;
var gameStarted:Bool = false;

function create()
{
    //FlxG.sound.music.stop();
    FlxG.sound.playMusic(Paths.music('FlappyEag'), true, 1, true, 102);
	FlxG.sound.music.persist = true;

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("minigames/whitehouse/eagMicrogame/bg"));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    add(bg);

    add(pipes);

    player = new FlxSprite(200, FlxG.height/2).loadGraphic(Paths.image("minigames/whitehouse/eagMicrogame/eag"));
    player.scale.set(-5,5);
    player.maxVelocity.y = 2000;
    player.width *= 0.8;
    player.height *= 0.8;
    add(player);

    pointsText = new FlxText(16, 16, 0, "Points: " + points, 16);
    pointsText.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "center");
    pointsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(pointsText);

    pressButton = new FlxText(16, 16, 500, "Press [" + CoolUtil.keyToString(Options.P1_ACCEPT[0]) + "] to jump.", 25);
    pressButton.setFormat("fonts/VCR.ttf", 25, FlxColor.WHITE, "center");
    pressButton.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(pressButton);
}

var uglySin:Float = 0;
function update(elapsed:Float)
{
    var jump = controls.ACCEPT;
	if (jump && !dead)
    {
        if (!gameStarted)
        {
            gameStarted = true;
            player.acceleration.y = 1500;
        }
        
        player.velocity.y = -750;
        
        player.angle = -15;

        jumpSFX = FlxG.sound.load(Paths.sound("minigame/whitehouse_day/eagMicrogame/eagJump"), 5);
        jumpSFX.pitch = FlxG.random.float(0.9, 1.1);
        jumpSFX.play(true);
    }

    if (player.angle < 45 && gameStarted)
        player.angle += elapsed * 50;

    if (!gameStarted)
    {
        uglySin += elapsed*5;
        player.y = FlxG.height/2 + Math.sin(uglySin)*16;
    }
    else
    {
        pressButton.alpha -= elapsed * 5;
    }

    pressButton.y = player.y - 30 - 50;

    if (!dead && gameStarted)
        timer -= elapsed;
    if (timer<=0)
    {
        timer = maxTimer;
        createPipe(FlxG.random.float(-180, 180));
    }

    for (i in pipes.members)
    {
        if (FlxG.overlap(player, i) && !dead)
        {
            if (i.ID == 0)
            {
                die();
            }
            if (i.ID == 1)
            {
                i.ID = 2;
                passPipe(i.y + 150);
            }
        }
        
        if (i.x < -100)
        {
            i.kill();
            i.destroy();
        }
    }

    if ((player.y < -player.height * 2 || player.y > FlxG.height + (player.height * 2)) && !dead)
        die();
}

var jumpSFX:FlxSound;
function jump()
{
    player.velocity.y = -750;
    
    player.angle = -15;

    jumpSFX = FlxG.sound.load(Paths.sound("minigame/whitehouse_day/eagMicrogame/eagJump"), 5);
    jumpSFX.pitch = FlxG.random.float(0, 100);
    jumpSFX.play(true);

    trace("JUMP");
}

function die()
{
    for (i in pipes.members)
    {
        //i.velocity.x = 0;
    }

    FlxG.camera.shake(0.025, 0.5);
    FlxG.sound.play(Paths.sound("explosion_sfx"), 1);
    dead = true;
}

var passPipeSFX:FlxSound;
function passPipe(y:Float = 0)
{
    passPipeSFX = FlxG.sound.load(Paths.sound("minigame/whitehouse_day/eagMicrogame/eagPassPipe"), 5);
    passPipeSFX.pitch = FlxMath.lerp(1.25, 0.75,(y / FlxG.height));
    passPipeSFX.play(true);

    points += 1;
    pointsText.text = "Points: " + points;
    maxTimer -= maxTimer/100;
    trace(maxTimer);
}

function createPipe(y:Float = 0)
{
    var trigger = new FlxSprite(FlxG.width + 250 - (50/2), FlxG.height/2 + y - (300/2)).makeGraphic(50, 300, FlxColor.RED);
    trigger.offset.y = 0;
    trigger.velocity.x = -500;
    trigger.ID = 1;
    trigger.visible = true;
    pipes.add(trigger);

    var pipe = new FlxSprite(FlxG.width + 200, FlxG.height/2 + y + 150).loadGraphic(Paths.image("minigames/whitehouse/eagMicrogame/piep"));
    pipe.scale.set(-5,20);
    pipe.updateHitbox();
    pipe.velocity.x = -500;
    pipe.ID = 0;
    pipe.width *= 0.5;
    pipe.height *= 0.9;
    //pipe.offset.y += 25;
    pipes.add(pipe);
    var pipe2 = new FlxSprite(FlxG.width + 200, FlxG.height/2 + y - 550).loadGraphic(Paths.image("minigames/whitehouse/eagMicrogame/piep"));
    pipe2.scale.set(-5,-20);
    pipe2.updateHitbox();
    pipe2.velocity.x = -500;
    pipe2.ID = 0;
    pipe2.width *= 0.5;
    pipe2.height *= 0.9;
    //pipe2.offset.y -= 25;
    pipes.add(pipe2);
}