import flixel.text.FlxTextBorderStyle;

var credits:Array = [
	{name: 'slithy', link: 'https://slithy.carrd.co', desc: 'director\ncoding\ncharting\nsome assets\ngeorge and trump voice\ndirector stuff'},
	{name: 'mrmorian', link: 'https://mrmorian.newgrounds.com/', desc: 'codirector\nanimation\nart\ncoding assistance\ncodirector stuff'},
	{name: 'cakieyea', link: 'https://www.youtube.com/@cakieyea', desc: 'music guy\nPatriot\nKilometer\nbf (talking) voice'},
	{name: 'punmaster', link: 'https://x.com/PunMasterOff', desc: 'music guy\nGod and Country\nEag.'},
	{name: 'capitnparrot', link: 'https://www.youtube.com/channel/UC08fJSpXa97QeISAYoYftgg', desc: 'moral support\njust the GOAT all around'},
	{name: 'marquis artuis', link: 'https://x.com/MarquisArtuis', desc: 'trump icons'},
	{name: 'g-nux', link: "https://g-nux.newgrounds.com", desc: "mod thumbnail"},
	{name: 'rodney528', link: "https://gamebanana.com/members/1729833", desc: 'Change Character Script\nin CNE discord'},
	{name: 'vsgorefield', link: "https://gamebanana.com/mods/501201", desc: "i stole your videohandler script"},
	{name: 'dovlin', link: "https://scarletviolet.pokemon.com/en-us/", desc: "he's finally a reference..."}
];

var curSelected:Int = 0;

var creditImageGrp:FlxTypedGroup<FlxSprite>;
var georgeScroll:FlxSprite;
var arrowDOWN:FlxSprite;
var arrowUP:FlxSprite;
var credIcon:FlxSprite;
var credName:FlxText;
var credDescTxt:FlxText;

function create(){
    FlxG.mouse.visible = false;
	var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFF00802B;
	bg.screenCenter();
	add(bg);

	georgeScroll = new FlxSprite();
	georgeScroll.loadGraphic(Paths.image('menus/credits/gorge'));
	georgeScroll.scale.set(0.75, 0.75);
	georgeScroll.updateHitbox();
	georgeScroll.screenCenter();
	add(georgeScroll);

	credIcon = new FlxSprite(394, 344);
	credIcon.loadGraphic(Paths.image('menus/credits/credIcons/' + credits[curSelected].name));
	credIcon.scale.set(1, 1);
	credIcon.updateHitbox();
	add(credIcon);

	credName = new FlxText(394, 495);
	credName.text = credits[curSelected].name.toUpperCase();
	credName.setFormat("fonts/THE PRESIDENT.ttf", 25, FlxColor.BLACK, "left");
	credName.borderSize = 2;
	add(credName);

	credDescTxt = new FlxText(470, 360);
	credDescTxt.fieldWidth = 500;
	credDescTxt.text = 'Roles in thy mod\n' + credits[curSelected].desc;
	credDescTxt.setFormat("fonts/THE PRESIDENT.ttf", 25, FlxColor.BLACK, "center");
	credDescTxt.borderSize = 2;
	add(credDescTxt);

	var devTime:FlxText = new FlxText(696, 564, 0,"Development Time\n7/4/2024-7/25/2024");
	devTime.setFormat("fonts/THE PRESIDENT.ttf", 25, FlxColor.BLACK, "center");
	add(devTime);
	watch(devTime);

	arrowDOWN = new FlxSprite(570, 605);
	arrowDOWN.loadGraphic(Paths.image('menus/arrow'));
	arrowDOWN.flipY = true;
	arrowDOWN.scale.set(0.25, 0.15);
	arrowDOWN.updateHitbox();
	add(arrowDOWN);

	arrowUP = new FlxSprite(570, 240);
	arrowUP.loadGraphic(Paths.image('menus/arrow'));
	arrowUP.scale.set(0.25, 0.15);
	arrowUP.updateHitbox();
	add(arrowUP);
}

function update(elapsed:Float){
	if(controls.UP_P)
	{
		changeCred(-1);
		FlxTween.tween(arrowUP, {"scale.x": 0.35, "scale.y": 0.25}, 0.05, {ease:FlxEase.quintInOut, onComplete: function(twn:FlxTween){
			FlxTween.tween(arrowUP, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease:FlxEase.quintInOut});
		}});
	}
	else if (controls.DOWN_P){
		changeCred(1);
		FlxTween.tween(arrowDOWN, {"scale.x": 0.35, "scale.y": 0.25}, 0.05, {ease:FlxEase.quintInOut, onComplete: function(twn:FlxTween){
			FlxTween.tween(arrowDOWN, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease:FlxEase.quintInOut});
		}});
	}
	if(controls.ACCEPT)
		CoolUtil.openURL(credits[curSelected].link);
	if(controls.BACK){
		FlxG.sound.play(Paths.sound('menu/cancel'));
		FlxG.switchState(new MainMenuState());
	}
}

function changeCred(cool:Int){
	curSelected += cool;
    if(curSelected >= credits.length)
        curSelected = 0;
    if(curSelected < 0)
        curSelected = credits.length - 1;

	credIcon.loadGraphic(Paths.image('menus/credits/credIcons/' + credits[curSelected].name));
	credName.text = credits[curSelected].name.toUpperCase();
	credDescTxt.text = 'Roles in thy mod\n' + credits[curSelected].desc;
}

function watch(obj:FlxObject){
	FlxG.watch.add(obj, "x");
	FlxG.watch.add(obj, "y");
}