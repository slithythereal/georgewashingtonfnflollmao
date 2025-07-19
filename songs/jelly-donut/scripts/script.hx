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
    FlxSpriteUtil.drawCircle(laserPointer, -1, -1, -1, 0x8fff0000);
    add(laserPointer);

    boyfriend.gameOverCharacter = 'jellydeath';
	lossSFX = 'gameover/jellydonutdeath';
}   

function stepHit(curStep:Int){
    switch(curStep){
        case 2446: 
            funnyEvent('shot');
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

function funnyEvent(event:String){
    var daEvent:String = event;
    switch(daEvent){
        case 'introstart':
            jfkIntro.animation.play('anim');
            jfkIntro.alpha = 1;
            dad.visible = false;
        case 'introoff':
            dad.visible = true;
            jfkIntro.visible = false;
        case 'ohno':
            stage.stageSprites['ohno'].velocity.x = -20;
        case 'lazer':
            FlxTween.tween(laserPointer, {x:880, y:400}, 1, {ease: FlxEase.quartIn});
        case 'shot':
            camHUD.shake();
            FlxG.camera.visible = false;
    }
}
