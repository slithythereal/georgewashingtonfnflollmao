import flixel.text.FlxTextBorderStyle;

// easier to have it in one variable than mutliple
var credits:Array<{name:String, link:String, desc:String}> = [
	{name: 'slithy', link: 'https://slithy.carrd.co', desc: 'director\ncoding\ncharting\nanimator\nvoice actor\ndirector stuff'},
	{name: 'mrmorian', link: 'https://mrmorian.newgrounds.com/', desc: 'codirector\nanimation\nart\ncoding assistance\ncodirector stuff'},
	{name: 'cakieyea', link: 'https://www.youtube.com/@cakieyea', desc: 'music guy\nMost songs\nbf (talking) voice'},
	{name: 'punmaster', link: 'https://twitter.com/PunMasterOff', desc: 'music guy\nEag man'},
	// {name: "micahstuff", link: "", desc: "music guy\nGrimace"},
	// {name: "kaegan1636", link: "", desc: "music guy\nDementia"},
	{name: 'capitnparrot', link: 'https://www.youtube.com/channel/UC08fJSpXa97QeISAYoYftgg', desc: 'moral support\njust the GOAT all around'},
];

var specialThanks:Array<{name:String, link:String, desc:String}> = [
	{name: 'marquis artuis', link: 'https://twitter.com/MarquisArtuis', desc: 'trump icons'},
	{name: 'g-nux', link: "https://g-nux.newgrounds.com", desc: "mod thumbnail"},
	{name: 'rodney528', link: "https://gamebanana.com/members/1729833", desc: 'Change Character Script\nin CNE discord'},
	{name: "hifish", link: "https://twitter.com/hifish__", desc: "Installer batchfile (.bat) script"},
	{name: 'rinsai', link: 'https://twitter.com/Rinsai_1', desc: "Eagle Fortnite default dance\n\nI TRIED FINDING IT EVERYWHERE,\nTHANK GOD SOMEONE HAD IT"},
	{name: 'vsgorefield', link: "https://gamebanana.com/mods/501201", desc: "i stole your videohandler script"},
	{name: 'dovlin', link: "https://scarletviolet.pokemon.com/en-us/", desc: "he's finally a reference..."}
];

var curSelected:Int = 0;
var curTag:Int = 0;
var curList = credits;
var creditImageGrp:FlxTypedGroup<FlxSprite>;
var georgeScroll, arrowDOWN, arrowUP, credIcon:FlxSprite;
var credName, credDescTxt, specialTxt:FlxText;

function create() {
	var isBrazil:Bool = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.curCountry == 'brazil');

	FlxG.mouse.visible = true;
	var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFF00802B;
	bg.screenCenter();
	add(bg);

	georgeScroll = new FlxSprite();
	georgeScroll.loadGraphic(Paths.image((isBrazil ? 'menus/credits/pedro' : 'menus/credits/gorge')));
	georgeScroll.scale.set(0.75, 0.75);
	georgeScroll.updateHitbox();
	georgeScroll.screenCenter();
	add(georgeScroll);

	credIcon = new FlxSprite(394, 344);
	credIcon.loadGraphic(Paths.image('menus/credits/credIcons/' + curList[curSelected].name));
	credIcon.scale.set(1, 1);
	credIcon.updateHitbox();
	add(credIcon);

	credName = new FlxText(394, 495);
	credName.text = curList[curSelected].name.toUpperCase();
	credName.setFormat("fonts/THE PRESIDENT.ttf", 25, FlxColor.BLACK, "left");
	credName.borderSize = 2;
	add(credName);

	credDescTxt = new FlxText(470, 360);
	credDescTxt.fieldWidth = 500;
	credDescTxt.text = 'Roles in thy mod\n' + curList[curSelected].desc;
	credDescTxt.setFormat("fonts/THE PRESIDENT.ttf", 25, FlxColor.BLACK, "center");
	credDescTxt.borderSize = 2;
	add(credDescTxt);

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
	
	specialTxt = new FlxText(FlxG.width /2 - 250, 575);
	specialTxt.fieldWidth = 500;
	specialTxt.text = 'Press [TAB] to see the Special Thanks.';
	specialTxt.setFormat("fonts/THE PRESIDENT.ttf", 20, FlxColor.BLACK, "center");
	specialTxt.borderSize = 2;
	add(specialTxt);

	changeCred();
	changeTag();
}

function update(elapsed:Float) {
	var upP = controls.UP_P;
    var downP = controls.DOWN_P;
	if (upP || downP) changeCred(0 - Std.int(upP) + Std.int(downP));
	if (FlxG.mouse.justPressed && (FlxG.mouse.overlaps(arrowUP) || FlxG.mouse.overlaps(arrowDOWN)))changeCred(0 - Std.int(FlxG.mouse.overlaps(arrowUP)) + Std.int(FlxG.mouse.overlaps(arrowDOWN)));
	
	var tab = FlxG.keys.justPressed.TAB;
	if (tab) changeTag(1);
	
	var accept = controls.ACCEPT;
	if (accept || FlxG.mouse.overlaps(credIcon) && FlxG.mouse.justPressed)
		CoolUtil.openURL(curList[curSelected].link); // opens credit link

	var back = controls.BACK;
	if (back) {
		FlxG.sound.play(Paths.sound('menu/cancel'));
		FlxG.switchState(new MainMenuState());
	}
}

function changeCred(cool:Int = 0) {
	curSelected = FlxMath.wrap(curSelected + cool, 0, curList.length-1);
	var arrow = null;
	if (cool < 0)
		arrow = arrowUP;
	if (cool > 0)
		arrow = arrowDOWN;

	if (arrow != null)
		FlxTween.tween(arrow, {"scale.x": 0.35, "scale.y": 0.25}, 0.05, {
			ease: FlxEase.quintInOut,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(arrow, {"scale.x": 0.25, "scale.y": 0.15}, 0.05, {ease: FlxEase.quintInOut});
			}
		});

	credIcon.loadGraphic(Paths.image('menus/credits/credIcons/' + curList[curSelected].name));
	credName.text = curList[curSelected].name.toUpperCase();
	credDescTxt.text = 'Roles in thy mod\n' + curList[curSelected].desc;
}

function changeTag(num:Int = 0)
{
	curTag = FlxMath.wrap(curTag + num, 0, 1);
	var cycle = [[credits, 'Press [TAB] to see the Special Thanks.'], [specialThanks, 'Press [TAB] to see the Credits.']];
	curList = cycle[curTag][0];
	specialTxt.text = cycle[curTag][1];
	curSelected = 0;
	changeCred();
}
