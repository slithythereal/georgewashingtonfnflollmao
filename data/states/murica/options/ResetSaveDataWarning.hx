import funkin.backend.utils.FunkinParentDisabler;
import flixel.text.FlxTextBorderStyle;
importScript('data/scripts/HandyDandyFunctions');
var parentDisabler:FunkinParentDisabler;
var yesButton:FlxText;
var noButton:FlxText;
function postCreate(){
    add(parentDisabler = new FunkinParentDisabler());

    this.data.onOpen != null ? this.data.onOpen() : null;

    var bg:FlxSprite = new FlxSprite();
    bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    add(bg);
    bg.alpha = 0.75;

    var txt:FlxText = new FlxText(0,50,FlxG.width - 250);
    txt.text = "ARE YOU SURE YOU WANT TO RESET YOUR SAVE DATA.\nANY PROGRESS YOU HAVE FOR THE MOD WILL BE LOST.\nTHIS WILL ALSO RESET YOUR GAME\nTHIS WILL NOT RESET CODENAME ENGINE SAVE DATA";
    txt.setFormat(Paths.font('VCR.ttf'), 55, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFFFF0000);
    txt.borderSize = 4;
    txt.screenCenter(FlxAxes.X);
    add(txt);

    yesButton = new FlxText(0, 425);
    yesButton.text = "YES";
    yesButton.setFormat(Paths.font('VCR.ttf'), 45, 0xFFffff, "center", FlxTextBorderStyle.OUTLINE , 0xFF000000);
    yesButton.borderSize = 4;
    yesButton.screenCenter(FlxAxes.X);
    add(yesButton);

    noButton = new FlxText(0, 500);
    noButton.text = "NO";
    noButton.setFormat(Paths.font('VCR.ttf'), 45, 0xFFffff, "center", FlxTextBorderStyle.OUTLINE , 0xFF000000);
    noButton.borderSize = 4;
    noButton.screenCenter(FlxAxes.X);
    add(noButton);
}

function postUpdate(elapsed:Float){
    if(FlxG.mouse.overlaps(yesButton)){
        yesButton.scale.set(1.2, 1.2);
        if(FlxG.mouse.justPressed)
            HandyDandy.resetSaveData();
    }
    else
        yesButton.scale.set(1,1);

    if(FlxG.mouse.overlaps(noButton)){
        noButton.scale.set(1.2, 1.2);
        if(FlxG.mouse.justPressed)
            closeThis();
    }
    else
        noButton.scale.set(1, 1);
    if(controls.BACK){
        closeThis();
    }
}

function closeThis(){
    this.data.onClose != null ? this.data.onClose() : null;
    close();
}