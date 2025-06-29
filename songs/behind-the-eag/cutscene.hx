import funkin.system.FunkinSprite;
var dadPos:Array<Float> = [];
var gfPos:Array<Float> = [];
var bfPos:Array<Float> = [];
function create(){
    var audience:FlxSound = new FlxSound();
    audience.loadEmbedded(Paths.sound('cutscenes/pplyapping'));
    FlxG.sound.list.add(audience);
    savePos();
    focusOn(game.boyfriend);
    game.camHUD.visible = false;
    game.gf.flipX = false;
    game.dad.x = -4000;
    FlxG.camera.zoom = 0.85; 
    FlxG.sound.play(Paths.sound('cutscenes/directorcut'));
    new FlxTimer().start(2.25, function(tmr:FlxTimer){
        audience.play();
        FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1.5, {ease:FlxEase.quartOut, onComplete: function(twn:FlxTween){
            focusOn(game.gf);
            new FlxTimer().start(0.9, function(tmr:FlxTimer){
                FlxG.sound.play(Paths.sound('eagle sound'));
                game.dad.playAnim('singRIGHT');    
                FlxTween.tween(game.dad, {x: dadPos[0]}, 0.75, {ease:FlxEase.quintOut, onComplete: function(twn:FlxTween){
                    game.gf.flipX = true;
                    game.gf.playAnim('singLEFT');
                    FlxG.sound.play(Paths.sound('cutscenes/realeaglecall'));
                    audience.fadeOut(1, 0, function(twn:FlxTween){
                        game.camHUD.visible = true;
                        close();
                    });
                }});      
            });

        }});
    });

}

function focusOn(char) {
    var camPos = char.getCameraPosition();
    game.camFollow.setPosition(camPos.x, camPos.y);
    camPos.put();
}

function savePos(){
    dadPos = [game.dad.x, game.dad.y];
    gfPos = [game.gf.x, game.gf.y];
    bfPos = [game.boyfriend.x, game.boyfriend.y];
}
