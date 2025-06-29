importScript('data/scripts/Flipped Healthbars');


var jfkIntro:FunkinSprite;

function create(){
	window.title = "ich bin ein berliner";
    jfkIntro = makeAnim('jfkintrosegment', 'anim', 'jfkstartanim', dad.x - 90, dad.y + 132, dad.scale.x, dad.scale.y);
    add(jfkIntro);

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
            changeSpeed(2);
    }
}

function update(elapsed:Float){
    jfkIntro.x = (motorcade.x) - (Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * (85/2));
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
