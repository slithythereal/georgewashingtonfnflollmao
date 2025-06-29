import funkin.backend.utils.FunkinParentDisabler;
var parentDisabler:FunkinParentDisabler;

var menuItems:Array<FlxText> = [];
var confirmItems:Array<FlxText> = [];
var options:Array<String> = ['Resume', 'Restart', 'Exit'];

var curSelected = 0;

function postCreate(){
    add(parentDisabler = new FunkinParentDisabler());
    this.data.onOpen != null ? this.data.onOpen() : null;

    var bg:FlxSprite = new FlxSprite();
	bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(bg);
	bg.alpha = 0.75;

    for (i=>option in options)
    {
        var item:FlxText = new FlxText(0, ((FlxG.height/2) - ((i * 100)/2)) + (i * 100) - (36), 0, option);
        item.setFormat("fonts/VCR.ttf", 36, FlxColor.WHITE, "center");
        item.screenCenter(FlxAxes.X);
        item.ID = i;
        add(item);
        menuItems.push(item);
    }
    changeOption(0);

    var comfirmMessage:FlxText = new FlxText(0, (FlxG.height/4*3), 0, "Are you sure?");
    comfirmMessage.setFormat("fonts/VCR.ttf", 40, FlxColor.WHITE, "center");
    comfirmMessage.screenCenter(FlxAxes.X);
    add(comfirmMessage);
    confirmItems.push(comfirmMessage);

    var comfirmNo:FlxText = new FlxText(0, (FlxG.height/4*3) + 60, 100, "No");
    comfirmNo.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "left");
    comfirmNo.screenCenter(FlxAxes.X);
    comfirmNo.x -= 50;
    comfirmNo.ID = 0;
    add(comfirmNo);
    confirmItems.push(comfirmNo);

    var comfirmYes:FlxText = new FlxText(0, (FlxG.height/4*3) + 60, 100, "Yes");
    comfirmYes.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "right");
    comfirmYes.screenCenter(FlxAxes.X);
    comfirmYes.x += 50;
    comfirmYes.ID = 1;
    add(comfirmYes);
    confirmItems.push(comfirmYes);

    for (item in confirmItems) item.visible = false;
}

function postUpdate(elapsed:Float){
    
    var upP = controls.UP_P;
    var downP = controls.DOWN_P;
    if ((upP || downP) && !isMessage) changeOption(0 - Std.int(upP) + Std.int(downP));
    var leftP = controls.LEFT_P;
    var rightP = controls.RIGHT_P;
    if ((leftP || rightP) && isMessage) changeOptionMessage(0 - Std.int(leftP) + Std.int(rightP));

    var accept = controls.ACCEPT;
    if (accept)
        if (!isMessage)
            selectOption(options[curSelected]);
        else
            selectMessage(curMessageSelected);

    if (FlxG.keys.justPressed.R) closeThis(); // debug thing if i get stuck
}

function changeOption(num:Int = 0)
{
    curSelected = FlxMath.wrap(curSelected + num, 0, options.length-1);
    for (i=>item in menuItems)
    {
        if (item.ID == curSelected)
            item.color = FlxColor.YELLOW;
        else
            item.color = FlxColor.WHITE;
    }
}

function selectOption(option:String)
{
    switch (option)
    {
        case "Resume":
            closeThis();
        case "Restart":
            if (isMessage)
                FlxG.switchState(new ModState('murica/WhiteHouseState'));
            else 
                showMessage();
        case "Exit":
            if (isMessage)
                FlxG.switchState(new MainMenuState());
            else 
                showMessage();
    }
}

var isMessage:Bool = false;
function showMessage()
{
    isMessage = true;
    for (item in menuItems) item.color = FlxColor.GRAY;
    for (item in confirmItems) item.visible = true;
    changeOptionMessage();
}

function selectMessage(num:Int)
{
    if (num == 1)
        selectOption(options[curSelected]);
    else
        closeMessage();
}

var curMessageSelected:Int = 0;
function changeOptionMessage(num:Int = 0)
{
    curMessageSelected = FlxMath.wrap(curMessageSelected + num, 0, 1);
    for (i=>item in confirmItems)
    {
        if (item.ID == curMessageSelected)
            item.color = FlxColor.YELLOW;
        else
            item.color = FlxColor.WHITE;
    }
}

function closeMessage()
{
    isMessage = false;
    for (item in confirmItems) item.visible = false;
    changeOption();
}

function closeThis(){
    this.data.onClose != null ? this.data.onClose() : null;
    close();
}