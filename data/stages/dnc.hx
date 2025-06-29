var curBG:String = '';

//sleigh
var sleighbounce:Float = 10;
var bounceDuration:Float = 0;
public var sleighFalling:Bool = false;

public var boyfriendNDadPos = [
    'sleigh' => {dad: [0, 0], boyfriend: [600, 325], zoom: 0.7},
    'dnc' => {dad: [0, 250], boyfriend: [600, 350], zoom: 0.8}
];
function create()
{
    for(c in strumLines.members[1].characters){
        var cpos = c.getCameraPosition();
        camFollow.setPosition(cpos.x, cpos.y);
    }
}

function postCreate() {
    bounceDuration = Conductor.stepCrochet * 2 / 1200;
    backgroundCreate('sleigh');
}
    
public function backgroundCreate(bg:String){
    curBG = bg;
    switch(bg){
        case 'dnc': 
            iconP2.visible = dad.visible = true;
            blacksky.velocity.set(0, 0);
            dnc.visible = true;
            blacksky.visible = sleigh.visible = false;

        case 'sleigh':
            dad.visible = false;
            boyfriend.moves = sleigh.moves = blacksky.moves = true;
            blacksky.velocity.set(25, 0);
            boyfriend.acceleration.y = 0;
            iconP2.visible = false;
            blacksky.visible = sleigh.visible = true;
            dnc.visible = false;
    }
    dad.setPosition(boyfriendNDadPos[curBG].dad[0],boyfriendNDadPos[curBG].dad[1]);
    boyfriend.setPosition(boyfriendNDadPos[curBG].boyfriend[0], boyfriendNDadPos[curBG].boyfriend[1]);
    defaultCamZoom = boyfriendNDadPos[curBG].zoom;
}

function beatHit(curBeat:Int){
    if(curBG == 'sleigh' && curBeat >= 0 && !sleighFalling){
        for(i in [boyfriend, sleigh]){
            FlxTween.tween(i,{y: i.y-sleighbounce}, bounceDuration, {ease:FlxEase.sineOut, onComplete: function(twn:FlxTween) {
                FlxTween.tween(i, {y: i.y + sleighbounce}, bounceDuration, {ease:FlxEase.sineIn});
            }});
        }
    }
}

function onCameraMove(event)
    if(sleighFalling)
        event.cancel(true);
