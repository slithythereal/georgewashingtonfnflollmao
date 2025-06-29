import flixel.util.FlxSpriteUtil;

importScript('data/scripts/Flipped Healthbars');


var jfkIntro:FunkinSprite;
var laserPointer:FunkinSprite;
var laserVel:Float = 100;

function create(){
	window.title = "ich bin ein berliner";
    jfkIntro = makeAnim('jfkintrosegment', 'anim', 'jfkstartanim', dad.x - 90, dad.y + 132, dad.scale.x, dad.scale.y);
    add(jfkIntro);
    
    laserPointer = new FunkinSprite(2000, -1000).makeGraphic(10, 10, FlxColor.TRANSPARENT);
    FlxSpriteUtil.drawCircle(laserPointer, -1, -1, -1, 0xb1ff2727);
    add(laserPointer);

    boyfriend.gameOverCharacter = 'jellydeath';
	lossSFX = 'gameover/jellydonutdeath';
}   
function onSongStart(){
    jfkIntro.animation.play('anim');
    jfkIntro.alpha = 1;
    dad.visible = false;
}

function beatHit(curBeat:Int){
    switch(curBeat){
        case 64: 
            dad.visible = true;
            jfkIntro.visible = false;
        case 400:
            stage.stageSprites["animeLines"].visible = true;
            changeSpeed(2);
        case 528:
            stage.stageSprites["animeLines"].visible = false;
            changeSpeed(1);
            stage.stageSprites['ohno'].velocity.x = -40;
        case 606:
            FlxTween.tween(laserPointer, {x:880, y:400}, 1, {ease: FlxEase.quartIn});
    }
}

function stepHit(curStep:Int){
    switch(curStep){
        case 2446: 
            camHUD.shake();
            FlxG.camera.visible = false;
    }
}

function update(elapsed:Float){
    jfkIntro.x = (stage.stageSprites['motorcade'].x + 200) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2));

    if (curBeat >= 606)
        laserVel = FlxMath.lerp(laserVel, 0, 0.01);

    var ammount = FlxG.random.float(laserVel,laserVel + 16);
    laserPointer.frameOffset.x = FlxG.random.float(-ammount, ammount);
    laserPointer.frameOffset.y = FlxG.random.float(-ammount, ammount);
}
function makeAnim(file:String, anim:String, xml:String, ?x:Float = 0, ?y:Float = 0, ?scalex:Float = 1, ?scaley:Float = 1):FunkinSprite{
    var char:FunkinSprite = new FunkinSprite(x, y);
    char.frames = Paths.getFrames('mid song anims/' + file);
    char.animation.addByPrefix(anim, xml, 24, false);
    char.scale.set(scalex, scaley);
    char.updateHitbox();
    char.alpha = 0.001;
    return char;
}
