import funkin.game.PlayState;

importScript("data/scripts/VideoHandler");

function create(){
	window.title = "McDonald's Advertisement";

    VideoHandler.load(["how do you do it and what's your secret", "together grimace"], true, function()
        {
            FlxG.camera.flash(FlxColor.WHITE);
            camGame.visible = true;
        });
    //VideoHandler.playNext();
    camGame.visible = false;
}
function onSongStart()
    VideoHandler.playNext();

function beatHit(curBeat:Int){
    switch(curBeat){
        case 439:
            VideoHandler.playNext();
    }
}

function onGameOver(event){
    if(!camGame.visible)
        camGame.visible = true;
}