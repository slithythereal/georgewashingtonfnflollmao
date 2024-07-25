import flixel.text.FlxTextBorderStyle;

var subTitle:FlxText = null;
function create(){
    if(FlxG.save.data.subtitlesGW){
        subTitle = new FlxText(0, 525, 0, "");
        subTitle.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
        subTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
        subTitle.borderSize = 1;
        subTitle.screenCenter(FlxAxes.X);
        add(subTitle);
        subTitle.camera = camHUD;
    }
}

function onEvent(_){
    if(FlxG.save.data.subtitlesGW && _.event.name == 'Add Subtitles'){
        subTitle.text = _.event.params[0];
        subTitle.color = FlxColor.fromString(_.event.params[1]);
        subTitle.screenCenter(FlxAxes.X);
    }
}
