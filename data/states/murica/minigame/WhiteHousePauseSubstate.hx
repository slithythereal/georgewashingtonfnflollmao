import funkin.backend.utils.FunkinParentDisabler;
importScript('data/scripts/HandyDandyFunctions');
var parentDisabler:FunkinParentDisabler;
var menuItems:Array<FlxText> = [];
var confirmItems:Array<FlxText> = [];
var options:Array<String> = ['Resume', 'Restart', 'Exit'];
var curSelected = 0;
var comfirmMessage:FlxText;

function postCreate() {
	add(parentDisabler = new FunkinParentDisabler());
	this.data.onOpen != null ? this.data.onOpen() : null;

	var bg:FlxSprite = new FlxSprite();
	bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(bg);
	bg.alpha = 0.75;

	for (i => option in options) {
		var item:FlxText = new FlxText(0, ((FlxG.height / 2) - ((i * 100) / 2)) + (i * 100) - (36), 0, option);
		item.setFormat("fonts/VCR.ttf", 36, FlxColor.WHITE, "center");
		item.screenCenter(FlxAxes.X);
		item.ID = i;
		add(item);
		menuItems.push(item);
	}
	changeOption(0);

	comfirmMessage = new FlxText(0, (FlxG.height / 4 * 3), 0, "Are you sure?");
	comfirmMessage.setFormat("fonts/VCR.ttf", 40, FlxColor.WHITE, "center");
	comfirmMessage.screenCenter(FlxAxes.X);
	add(comfirmMessage);

	var comfirmNo:FlxText = new FlxText(0, (FlxG.height / 4 * 3) + 60, 100, "No");
	comfirmNo.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "left");
	comfirmNo.screenCenter(FlxAxes.X);
	comfirmNo.x -= 50;
	comfirmNo.ID = 0;
	add(comfirmNo);
	confirmItems.push(comfirmNo);

	var comfirmYes:FlxText = new FlxText(0, (FlxG.height / 4 * 3) + 60, 100, "Yes");
	comfirmYes.setFormat("fonts/VCR.ttf", 30, FlxColor.WHITE, "right");
	comfirmYes.screenCenter(FlxAxes.X);
	comfirmYes.x += 50;
	comfirmYes.ID = 1;
	add(comfirmYes);
	confirmItems.push(comfirmYes);

	comfirmMessage.visible = false;
	for (item in confirmItems)
		item.visible = false;
}

function postUpdate(elapsed:Float) {
	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	if ((upP || downP) && !isMessage)
		changeOption(0 - Std.int(upP) + Std.int(downP));
	var leftP = controls.LEFT_P;
	var rightP = controls.RIGHT_P;
	if ((leftP || rightP) && isMessage)
		changeOptionMessage(0 - Std.int(leftP) + Std.int(rightP));

	if (isMessage) {
		for (item in confirmItems) {
			if (FlxG.mouse.overlaps(item)) {
				curMessageSelected = item.ID;
				changeOptionMessageStuff();
				if (FlxG.mouse.justPressed)
					selectMessage(curMessageSelected);
			}
		}
	} else {
		for (item in menuItems) {
			if (FlxG.mouse.overlaps(item)) {
				curSelected = item.ID;
				changeOptionStuff();
				if (FlxG.mouse.justPressed)
					selectOption(options[curSelected]);
			}
		}
	}

	var accept = controls.ACCEPT;
	if (accept)
		if (!isMessage)
			selectOption(options[curSelected]);
		else
			selectMessage(curMessageSelected);
}

function changeOption(num:Int = 0) {
	curSelected = FlxMath.wrap(curSelected + num, 0, options.length - 1);
	changeOptionStuff();
}

function changeOptionStuff() {
	for (i => item in menuItems)
		item.color = (item.ID == curSelected ? FlxColor.YELLOW : FlxColor.WHITE);
}

function selectOption(option:String) {
	switch (option) {
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

function showMessage() {
	isMessage = true;
	for (item in menuItems)
		item.color = FlxColor.GRAY;
	for (item in confirmItems)
		item.visible = true;
	comfirmMessage.visible = true;
	changeOptionMessage();
}

function selectMessage(num:Int) {
	if (num == 1)
		selectOption(options[curSelected]);
	else
		closeMessage();
}

var curMessageSelected:Int = 0;

function changeOptionMessage(num:Int = 0) {
	curMessageSelected = FlxMath.wrap(curMessageSelected + num, 0, 1);
	changeOptionMessageStuff();
}

function changeOptionMessageStuff() {
	for (i => item in confirmItems)
		item.color = (item.ID == curMessageSelected ? FlxColor.YELLOW : FlxColor.WHITE);
}

function closeMessage() {
	isMessage = false;
	for (item in confirmItems)
		item.visible = false;
	comfirmMessage.visible = false;
	changeOption();
}

function closeThis() {
	this.data.onClose != null ? this.data.onClose() : null;
	close();
}
