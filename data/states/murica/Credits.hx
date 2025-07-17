importScript('data/scripts/HandyDandyFunctions');
import flixel.text.FlxTextBorderStyle;

// easier to have it in one variable than mutliple
//TODO: Add brazil flag
var credits:Array<{name:String, link:String, desc:String}> = [
	{name: 'slithy', link: 'https://slithy.carrd.co', desc: 'director\ncoding\ncharting\nanimator\ndirector stuff'},
	{name: 'mrmorian', link: 'https://mrmorian.newgrounds.com/', desc: 'codirector\nanimation\nart\ncoding\ncodirector stuff'},
	{name: 'macyeah', link: 'https://www.youtube.com/@macyeahh', desc: 'codirector\nmusic guy\nMost songs\ncodirector stuff'},
	{name: 'punmaster', link: 'https://twitter.com/PunMasterOff', desc: 'music guy\nEag man'},
	{name: "micahstuff", link: "", desc: "music guy\nGrimace"},
	{name: "kaeganreal", link: "https://www.youtube.com/@kk-gaming-gaming-forever", desc: "music guy\nDementia"},
	{name: 'capitnparrot', link: 'https://www.youtube.com/channel/UC08fJSpXa97QeISAYoYftgg', desc: 'moral support\njust the GOAT all around'},
];

var specialThanks:Array<{name:String, link:String, desc:String}> = [
	{name: 'marquis artuis', link: 'https://twitter.com/MarquisArtuis', desc: 'trump icons'},
	{name: 'g-nux', link: "https://g-nux.newgrounds.com", desc: "mod thumbnail"},
	{name: 'rodney528', link: "https://gamebanana.com/members/1729833", desc: 'Change Character Script\nin CNE discord'},
	{name: "hifish", link: "https://twitter.com/hifish__", desc: "Installer batchfile (.bat) script"},
	{name: 'rinsai', link: 'https://twitter.com/Rinsai_1', desc: "Eagle Fortnite default dance\n\nI TRIED FINDING IT EVERYWHERE,\nTHANK GOD SOMEONE HAD IT"},
	{name: 'vsgorefield', link: "https://gamebanana.com/mods/501201", desc: "i stole your videohandler script"},
	{name: 'dovlin', link: "https://gamebanana.com/mods/585736", desc: "he's finally a reference..."}
];

var voiceActors:Array<{name:String, link:String, desc:String}> = [
	{name: "slithy", link: 'https://slithy.carrd.co', desc: "George, Trump, JFK, Biden, Kamala, Secret Service Guard #1, Reagan, Martha Washington"},
	{name: 'macyeah', link: 'https://www.youtube.com/@macyeahh', desc: 'Boyfriend'},
	{name: 'capitnparrot', link: 'https://www.youtube.com/channel/UC08fJSpXa97QeISAYoYftgg', desc: 'Grimace, Secret Service Guard #2'},
	{name: 'izzybelle', link: '', desc: 'Taft'},
	{name: 'ik3_', link: '', desc: 'Jimmy Carter'},
	{name: 'Muzfrg_Kintsugi', link: '', desc: 'James Monroe'},
];
//TODO: add voice actors list to credits menu

var curSelected:Int = 0;
var curTag:Int = 0;
var curList = credits;
var creditImageGrp:FlxTypedGroup<FlxSprite>;
var georgeScroll, arrowDOWN, arrowUP, credIcon:FlxSprite;
var credName, credDescTxt, specialTxt:FlxText;
var dollabillz:FlxTypedGroup<FlxSprite>;
var creditTypes:Array<String> = ['credits', 'special thanks' /*, 'voice actors'*/];
var dollaTxt:FlxTypedGroup<FlxText>;
var thy:Array<String> = ['Roles in thy mod', 'Contributions to thy mod', 'Characters voiced in thy mod'];

function create() {
	var isBrazil:Bool = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.curCountry == 'brazil');

	FlxG.mouse.visible = true;
	var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFF00802B;
	bg.screenCenter();
	add(bg);

	dollabillz = new FlxTypedGroup();
	add(dollabillz);

	dollaTxt = new FlxTypedGroup();
	add(dollaTxt);

	for (i => cred in creditTypes) {
		var dollaBill:FlxSprite = new FlxSprite(50 + (i * 880), 100);
		dollaBill.frames = Paths.getFrames('menus/credits/dolarbill');
		dollaBill.animation.addByPrefix("idle", "unselected", 1, false);
		dollaBill.animation.addByPrefix("selected", "selected", 24, false);
		dollaBill.animation.play("idle");
		dollaBill.scale.set(0.20, 0.10);
		dollaBill.updateHitbox();
		dollaBill.scale.set(0.25, 0.25);
		dollaBill.ID = i;
		dollabillz.add(dollaBill);
		var txt:FlxText = new FlxText(dollaBill.x, dollaBill.y + 100, dollaBill.width);
		txt.setFormat("fonts/Robot Socialista.ttf", 24, FlxColor.WHITE, "center");
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		txt.ID = i;
		txt.text = cred.toUpperCase();
		dollaTxt.add(txt);
	}

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
	credDescTxt.text = thy[curTag] + "\n" + curList[curSelected].desc;
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

	changeCred();
	changeTag(0);
}

function update(elapsed:Float) {
	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	if (upP || downP)
		changeCred(0 - Std.int(upP) + Std.int(downP));
	if (FlxG.mouse.justPressed && (FlxG.mouse.overlaps(arrowUP) || FlxG.mouse.overlaps(arrowDOWN)))
		changeCred(0 - Std.int(FlxG.mouse.overlaps(arrowUP)) + Std.int(FlxG.mouse.overlaps(arrowDOWN)));

	dollaTxt.forEach(function(i:FlxText) {
		if (FlxG.mouse.overlaps(i)) {
			i.scale.set(1.25, 1.25);
			if (FlxG.mouse.justPressed)
				changeTag(i.ID);
		} else
			i.scale.set(1, 1);
	});

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
	curSelected = FlxMath.wrap(curSelected + cool, 0, curList.length - 1);
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
	credDescTxt.text = thy[curTag] + "\n" + curList[curSelected].desc;
}

function changeTag(num:Int = 0) {
	curTag = num;
	var cycle = [credits, specialThanks, voiceActors];
	curList = cycle[curTag];
	curSelected = 0;

	credDescTxt.text = thy[curTag] + "\n" + curList[curSelected].desc;

	dollabillz.forEach(function(i:FlxText) {
		i.animation.play((i.ID == curTag ? 'selected' : 'idle'));
	});
	dollaTxt.forEach(function(i:FlxText) {
		i.color = (i.ID == curTag ? 0xFF00FF15 : 0xFFFFFF);
	});
	changeCred();
}
