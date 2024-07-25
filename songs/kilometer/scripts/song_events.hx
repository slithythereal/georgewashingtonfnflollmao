import funkin.game.PlayState;

importScript("data/scripts/VideoHandler");

function create(){
    VideoHandler.load(["kilometercutscene", "peak"], true, function(){
        FlxG.camera.flash(FlxColor.WHITE);
    });
    VideoHandler.playNext();
    VideoHandler.curVideo.visible = false;
    VideoHandler.curVideo.pause();
    camHUD.visible = false;
    camGame.visible = false;
}


function onSongStart(){
    VideoHandler.curVideo.visible = true;
    VideoHandler.curVideo.resume();
}

function beatHit(curBeat:Int){
    switch(curBeat){
        case 72:
            camHUD.visible = true;
            camGame.visible = true;

        case 132: transitionTOBG('white house', 'grand canyon');
        case 196: transitionTOBG('grand canyon', 'golden gate');
        case 260: transitionTOBG('golden gate', 'yellowstone');
        case 328: transitionTOBG('yellowstone', 'superbowl arena');
        case 396:
            FlxTween.tween(stage.stageSprites['superbowl arena'], {alpha: 0.001}, 0.5, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {
                stage.stageSprites['superbowl arena'].visible = false;
                stage.stageSprites['superbowl arena'].alpha = 1;
            }});
        case 437:
            stage.stageSprites['murica'].visible = true;
        case 445, 446, 447, 449, 451, 452: firework();
        case 464: transitionTOBG('murica', 'area 51');
        case 532: transitionTOBG('area 51', 'liberty statue');
        case 564: transitionTOBG('liberty statue', 'rushmore');
        case 596: transitionTOBG('rushmore', 'lincoln statue');
        case 628: transitionTOBG('lincoln statue', 'washington monument');
        case 664: transitionTOBG('washington monument', 'white house end');
        case 740: VideoHandler.playNext();
    }
}

function onSongEnd(){
    if(PlayState.isStoryMode){
        var songsToUnlock:Array<String> = ['patriot', 'god-and-country', 'kilometer'];
        for(song in songsToUnlock)
            if(!FlxG.save.data.songsUnlocked.contains(song))
                FlxG.save.data.songsUnlocked.push(song);
        trace("unlocked freeplaylandia (WINNER!!!)");
        trace(FlxG.save.data.songsUnlocked);
        if(!FlxG.save.data.freeplayUnlocked)
            FlxG.save.data.freeplayUnlocked = true;
        FlxG.save.flush();
    }
}
function transitionTOBG(oldBG:String, newBG:String){
    FlxTween.tween(camGame, {zoom: 0.8}, 0.6155, {ease:FlxEase.quadIn, onComplete: function(tmr:FlxTimer) {
        FlxTween.tween(camGame, {zoom: 0.4}, 0.6155, {ease:FlxEase.sineOut});
    }});
    FlxTween.tween(stage.stageSprites['mountain'], {x: -5000}, 1.75, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {
        stage.stageSprites['mountain'].x = 5000;
    }});
    new FlxTimer().start(0.62, function(tmr:FlxTimer){
        stage.stageSprites[oldBG].visible = false;
        stage.stageSprites[oldBG].velocity.x = (0);
        stage.stageSprites[newBG].visible = true;
        stage.stageSprites[newBG].velocity.x = (-60);
    });
}

function firework(){
    stage.stageSprites["firework"].alpha = 0;
    var firework:FlxSprite = new FlxSprite(FlxG.random.float(-FlxG.width, FlxG.width * 2), FlxG.height * 1.2).loadGraphic(Paths.image("stages/kilometer/firework"));
    firework.scale.set(0.2, 0.2);
    firework.scrollFactor.set(0.4, 0.4);
    firework.updateHitbox();
    firework.acceleration.y = 600;
    firework.velocity.y = -FlxG.random.float(800, 1600);
    firework.color = FlxG.random.color(FlxColor.WHITE, FlxColor.BLACK, null, false);
    insert(members.indexOf(stage.stageSprites["firework"]), firework);
    new FlxTimer().start(FlxG.random.float(0.8, 1.2), function(tmr:FlxTimer){
        firework.acceleration.y = 0;
        firework.velocity.y = 200;
        firework.scale.set(3, 3);
        FlxTween.tween(firework, {alpha: 0}, 2, {ease:FlxEase.linear, startDelay: FlxG.random.float(1.0, 2.25), onComplete: function(twn:FlxTween) {
            firework.destroy();
            firework.kill();
        }});
    });
}