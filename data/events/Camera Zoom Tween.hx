
function onEvent(_){
    if(_.event.name == 'Camera Zoom Tween')
    {
        var timeVal:Float = Std.parseFloat(_.event.params[0]);
        var zoomVal:Float = Std.parseFloat(_.event.params[1]);
        FlxTween.tween(camGame, {zoom: zoomVal}, timeVal, {ease:FlxEase.sineOut, onComplete: function(twn:FlxTween){
            defaultCamZoom = camGame.zoom;
        }});
    }
}

function onSubStateOpen(event){
    for(tween in modchartTweens)
        tween.active = false;
}
function onSubStateClosed() {
    for(tween in modchartTweens)
        tween.active = true;
}