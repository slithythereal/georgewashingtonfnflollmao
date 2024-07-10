import flixel.text.FlxTextBorderStyle;

var subTitle:FlxText = null;
var subTitle2:FlxText = null;
function create(){
    if(FlxG.save.data.subtitles){
        subTitle = new FlxText(0, 525, 0, "");
        subTitle.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
        subTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
        subTitle.borderSize = 1;
        subTitle.screenCenter(FlxAxes.X);
        add(subTitle);
        watch(subTitle);
        subTitle.camera = camHUD;
    
        subTitle2 = new FlxText(0, 555, 0, "");
        subTitle2.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
        subTitle2.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
        subTitle2.borderSize = 1;
        subTitle2.screenCenter(FlxAxes.X);
        add(subTitle2);
        subTitle2.camera = camHUD;
    }
}

function onEvent(_){
    if(FlxG.save.data.subtitles){
        switch(_.event.name){
            case 'Add Subtitles':
                subTitle.text = _.event.params[0];
                subTitle.color = FlxColor.fromString(_.event.params[1]);
                subTitle.screenCenter(FlxAxes.X);
            case 'Add More Subtitles':
                subTitle2.text = _.event.params[0];
                subTitle2.color = FlxColor.fromString(_.event.params[1]);
                subTitle2.screenCenter(FlxAxes.X);
        }
    }
}

function watch(obj:FlxObject){
    FlxG.watch.add(obj, "x");
    FlxG.watch.add(obj, "y");
}