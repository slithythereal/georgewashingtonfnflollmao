importScript('data/scripts/Flipped Healthbars');
importScript('data/scripts/VideoHandler');
importScript('data/scripts/Invisible HUD');

var ssg1:Character;
var ssg2:Character;
var ssg3:Character;
var ssg1old:FlxSprite;
var ssg2old:FlxSprite;
var ssg3old:FlxSprite;
var joeIntro:FunkinSprite;
var joeDrops:FunkinSprite;
var iceCreamDrop:FunkinSprite;
var ssgAnim:FunkinSprite;
var awesomeExplosivo:FunkinSprite;

function create(){
	window.title = "How to walk up the stairs";

    VideoHandler.load(["joestairscutscene"], true, function(){
        FlxG.camera.flash(FlxColor.WHITE);
        iceCreamDrop.visible = false;
        ssgAnim.visible = false; 

        for(i in [ssg1, ssg2, ssg3])
            i.visible = false;
        switchBG();
    });

    dad.flipX = true;

    ssg1old = stage.stageSprites['ssg1'];
    ssg1old.alpha = 0;
    ssg2old = stage.stageSprites['ssg2'];
    ssg2old.alpha = 0;
    ssg3old = stage.stageSprites['ssg3'];
    ssg3old.alpha = 0; 

    ssg1 = new Character(725, 175,"other/ssg1", false);
    insert(members.indexOf(ssg1old), ssg1);

    ssg2 = new Character(425, 250,"other/ssg2", false);
    insert(members.indexOf(ssg2old), ssg2);

    ssg3 = new Character(975, 125,"other/ssg3", false);
    insert(members.indexOf(ssg3old), ssg3);

    for(i in [ssg1, ssg2, ssg3])
    {
        i.scale.set(1.75, 1.75);
        i.updateHitbox();
        i.beatInterval = 1;
        i.playAnim('idle');
        i.visible = false;
    }

    ssgAnim = makeAnim('bidenicecream/securityguardanim', 'anim', 'ssganim', 110, 70, ssg2.scale.x, ssg2.scale.y);
    add(ssgAnim);

    joeIntro = makeAnim('joeintro', 'intro', 'joeintrosequence', 325, 267, dad.scale.x, dad.scale.y);
    add(joeIntro);

    joeDrops = makeAnim('bidenicecream/icecreamcutscfull', 'anim', 'joeanim', 260, 320, dad.scale.x, dad.scale.y);
    add(joeDrops);

    iceCreamDrop = makeAnim('bidenicecream/icecreamdrop', 'anim', 'icecreamdrop', 360, 275, dad.scale.x, dad.scale.y);
    add(iceCreamDrop);

    awesomeExplosivo = makeAnim('explosivo', 'explode', 'explosivo', -1250, -900, 5.65, 5.65);
    awesomeExplosivo.angle = 90;
    add(awesomeExplosivo);
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
        case 'intro':
            joeIntro.animation.play('intro');
            joeIntro.alpha = 1;
            dad.visible = false;
        case 'guardsdrop':
            for(i in [ssg1, ssg2, ssg3]){
                i.visible = true;
                i.playAnim('fall');
            }
        case 'jojo':
            stage.stageSprites['jojo'].visible = true;
            FlxTween.tween(stage.stageSprites['jojo'], {"scale.x": 1, "scale.y": 1}, 0.1, {ease:FlxEase.linear});
        case 'clear1':
            joeIntro.visible = false;
            dad.visible = true;
            dad.flipX = false;
            stage.stageSprites['jojo'].visible = false;
            for(i in [ssg1, ssg2, ssg3])
                i.playAnim('idle');
            
            remove(stage.stageSprites['jojo']);
        case 'iceC1':
            iceCreamDrop.alpha = 1;
            iceCreamDrop.animation.play('anim');
            for(i in [ssg1, ssg3])
                FlxTween.tween(i, {x: 3000}, 1, {ease:FlxEase.sineInOut});
        case 'iceC2':
            joeDrops.animation.play('anim');
            dad.visible = false;
            joeDrops.alpha = 1;
        case 'iceC3':
            ssg2.visible = false;
            ssgAnim.alpha = 1;
            ssgAnim.animation.play('anim');
        case 'iceC4':
            joeDrops.visible = false;
            dad.visible = true;
        case 'joedies':
            FlxTween.tween(dad, {x: -2000, y: -2000}, 2, {ease:FlxEase.linear, onComplete:function(twn:FlxTween){
                dad.visible = false;
            }});
        case 'bfdies':
            FlxTween.tween(boyfriend, {x: -2000, y: -2000}, 2, {ease:FlxEase.linear, onComplete: function(twn:FlxTween){
                boyfriend.visible = false;
            }});
        case 'explosivo':
            awesomeExplosivo.alpha = 1;
            awesomeExplosivo.animation.play('explode');
    }
}

function beatHit(curBeat:Int){
    switch(curBeat){
        case 212: VideoHandler.playNext();
        case 306 | 313: 
            awesomeExplosivo.alpha = 1;
            awesomeExplosivo.animation.play('explode');
    }  
}