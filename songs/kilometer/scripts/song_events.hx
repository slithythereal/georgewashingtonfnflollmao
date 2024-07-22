import funkin.game.PlayState;

function beatHit(curBeat:Int){
    switch(curBeat){
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
        case 464: transitionTOBG('murica', 'area 51');
        case 532: transitionTOBG('area 51', 'liberty statue');
        case 564: transitionTOBG('liberty statue', 'rushmore');
        case 596: transitionTOBG('rushmore', 'lincoln statue');
        case 628: transitionTOBG('lincoln statue', 'washington monument');
        case 664: transitionTOBG('washington monument', 'white house end');
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
        FlxG.save.flush();
    }
}

function transitionTOBG(oldBG:String, newBG:String){
    FlxTween.tween(camGame, {zoom: 0.8}, 0.6155, {ease:FlxEase.linear, onComplete: function(tmr:FlxTimer) {
        FlxTween.tween(camGame, {zoom: 0.4}, 0.6155, {ease:FlxEase.linear});
    }});
    FlxTween.tween(stage.stageSprites['mountain'], {x: -5000}, 1.75, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {
        stage.stageSprites['mountain'].x = 5000;
    }});
    new FlxTimer().start(0.62, function(tmr:FlxTimer){
        stage.stageSprites[oldBG].visible = false;
        stage.stageSprites[newBG].visible = true;
    });
}