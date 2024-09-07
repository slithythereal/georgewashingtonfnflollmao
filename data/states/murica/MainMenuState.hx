import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.MusicBeatState;
import flixel.effects.FlxFlicker;
import funkin.game.Character;
import funkin.game.PlayState; 

importScript("data/scripts/HandyDandyFunctions");
var options:Array<String> = [];
var menuItems:FlxTypedGroup<FlxSprite>;
var textGrp:FlxTypedGroup<FlxText>;
var curSelected:Int = curMainMenuSelected;
var brazilON:Bool = false;

// decor
var bg:FlxSprite;
var barGradient:FlxSprite;
var checker:FlxSprite;
var bar:FlxSprite;
var arrow:FlxSprite;
var quitButton:FlxSprite;
var selectedSomethin:Bool = false;
var eagle:FlxSprite;
var eagleYArray:Array<Float> = [-35, 70, 250, 450];
var eagleActive:Bool = false;
var playIcon:FlxSprite;
var mailbox:Character;
var mailUnlocked:Bool = false;
var mailSelected:Bool = false;
var isMailHovered:Bool = false;
var newOption:Int;

function create()
{
	FlxG.mouse.visible = true;
	brazilON = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);
	DiscordUtil.changePresence("most american menu i've ever seen", "Main Menu");

	HandyDandy.playMenuSong(brazilON);
	
	mailUnlocked = FlxG.save.data.mailUnlocked;

	options.push('play');
	if (FlxG.save.data.freeplayUnlockedGW) 
		options.push('freeplaylandia');
	options.push('options');
	options.push('credits');

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/brazil' : 'menus/mainmenu/murica flag')));
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	playIcon = new FlxSprite();
	playIcon.loadGraphic(Paths.image('menus/mainmenu/playicons/icon_' + options[curSelected]));
	add(playIcon);
	playIcon.visible = false;

	menuItems = new FlxTypedGroup();
	add(menuItems);

	textGrp = new FlxTypedGroup();
	add(textGrp);

	for (i => option in options)
	{
		var menuItem:FlxSprite = new FlxSprite();
		menuItem.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/brazil' : 'menus/mainmenu/murica flag')));
		menuItem.scale.set(0.25, 0.15);
		menuItem.ID = i;
		menuItem.updateHitbox();
		menuItem.setPosition(0, ((menuItem.ID = i) * 175) + 25);
		menuItem.screenCenter(FlxAxes.X);
		menuItem.antialiasing = true;
		menuItems.add(menuItem);

		var txt:FlxText = new FlxText();
		txt.text = options[i].toUpperCase();
		txt.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
		txt.ID = i;
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
		txt.borderSize = 2;
		txt.setPosition(menuItem.x, menuItem.y + 50);
		txt.screenCenter(FlxAxes.X);
		textGrp.add(txt);
	}

	if (mailUnlocked)
	{ // mailbox unlocked when beating the week
		mailbox = new Character(1050, 450, "other/mailbox", false);
		mailbox.scale.set(0.25, 0.75);
		mailbox.updateHitbox();
		mailbox.scale.set(0.75, 0.75);
		mailbox.origin.set(-200, 0);
		add(mailbox);
		mailbox.playAnim("closedFR", false, null);
	}

	// eagle
	eagle = new FlxSprite(0, -1000);
	eagle.loadGraphic(Paths.image((brazilON ? 'menus/mainmenu/brazil/toucan' : 'menus/mainmenu/eagle')));
	eagle.scale.set(0.75, 0.75);
	eagle.updateHitbox();
	add(eagle);

	changeOption(0);
}

function update(elapsed:Float)
{
	if (!selectedSomethin)
	{
		#if !USA
		if (FlxG.keys.justPressed.SEVEN)
		{
			persistentUpdate = !(persistentDraw = true);
			openSubState(new EditorPicker());
		}
		if (controls.SWITCHMOD)
		{
			openSubState(new ModSwitchMenu());
			persistentUpdate = !(persistentDraw = true);
		}
		#end

		if (controls.UP_P)
			changeOption(-1);
		if (controls.DOWN_P)
			changeOption(1);

		if (controls.ACCEPT)
			transitionState(options[curSelected]);

		// eagle
		if (FlxG.random.int(1, 750) == 1 && !eagleActive)
			activateEagle();

		if (eagleActive && FlxG.mouse.overlaps(eagle) && FlxG.mouse.justPressed){
			if(brazilON)
				toucanPressed();
			else
				eaglePressed();
		}


		textGrp.forEach(function(txt:FlxText){
			if(FlxG.mouse.overlaps(txt)){
				if(newOption != txt.ID){
					newOption = txt.ID;
					curSelected = txt.ID;
					changeOptionEtc();
				}
				if(FlxG.mouse.justPressed && !FlxG.mouse.overlaps(eagle))
					transitionState(options[curSelected]);
			}
		});

		// mail
		if (mailUnlocked)
		{
			if (FlxG.mouse.overlaps(mailbox))
			{
				if (!isMailHovered)
				{
					isMailHovered = true;
					mailbox.playAnim("open");
					FlxG.sound.play(Paths.sound("ui/mailboxopen"));
				}
				if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(eagle))
				{
					selectedSomethin = true;
					FlxG.switchState(new ModState("murica/MailboxState"));
				}
			}
			else
			{
				if (isMailHovered)
				{
					isMailHovered = false;
					mailbox.playAnim("close");
					FlxG.sound.play(Paths.sound("ui/mailboxclose"));
				}
			}
		}
	}
}

function changeOption(cool:Int)
{
	curSelected += cool;
	if (curSelected >= options.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = options.length - 1;

	curMainMenuSelected = curSelected;

	changeOptionEtc();
}

function changeOptionEtc(){
	FlxG.sound.play(Paths.sound('menu/scroll'));

	menuItems.forEach(function(spr:FlxSprite)
	{
		spr.scale.set((spr.ID == curSelected ? 0.35 : 0.25), 0.15);
	});
	textGrp.forEach(function(txt:FlxText)
	{
		txt.size = (txt.ID == curSelected ? 50 : 25);
		txt.borderColor = (txt.ID == curSelected ? FlxColor.RED : FlxColor.BLACK);
		txt.borderSize = (txt.ID == curSelected ? 4.5 : 3);
		txt.screenCenter(FlxAxes.X);
	});
	playIcon.loadGraphic(Paths.image('menus/mainmenu/playicons/icon_' + options[curSelected]));
}

function transitionState(state:String)
{
	FlxG.mouse.visible = false;
	selectedSomethin = true;
	FlxG.sound.play(Paths.sound('menu/confirm'));

	playIcon.visible = true;

	if (mailUnlocked)
		FlxTween.tween(mailbox, {alpha: 0}, 0.4, {ease: FlxEase.quadOut}); // tweens mail
	menuItems.forEach(function(spr:FlxSprite)
	{ // tweens sprites and flickers chosen menuitem
		if (curSelected != spr.ID)
		{
			FlxTween.tween(spr, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					spr.destroy();
				}
			});
		}
		else
		{
			FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
			{
				spr.destroy();
				loadState(state);
			});
		}
	});
	textGrp.forEach(function(txt:FlxText)
	{ // same thing for text lol
		if (curSelected != txt.ID)
		{
			FlxTween.tween(txt, {x: (FlxG.random.int(1, 2) == 1) ? -1000 : 1500}, 0.4, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween)
				{
					txt.destroy();
				}
			});
		}
		else
		{
			FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker)
			{
				txt.destroy();
				loadState(state);
			});
		}
	});
}

function loadState(state:String)
{
	switch (state)
	{
		case 'play':
			if(brazilON)
				HandyDandy.loadWeek(['negotiations'], 'dom week', 'dom');
			else
				HandyDandy.loadWeek(['patriot', 'god-and-country', 'kilometer'], 'George Week', 'georgeW1');
		case 'freeplaylandia':
			FlxG.switchState(new FreeplayState());
		case 'options':
			FlxG.switchState(new OptionsMenu());
		case "credits":
			FlxG.switchState(new ModState("murica/Credits"));
		default:
			selectedSomethin = false;
			trace("no menu here lol");
			FlxG.switchState(new MainMenuState()); // reloads menustate for null option
	}
}

// eagle
function eaglePressed()
{
	selectedSomethin = true;
	trace("eagle pressed");

	FlxG.sound.music.stop();

	var bgBLACK:FlxSprite = new FlxSprite();
	bgBLACK.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	add(bgBLACK);

	var eagMew:FlxSprite = new FlxSprite();
	eagMew.loadGraphic(Paths.image('menus/mainmenu/eagle mewing'));
	eagMew.scale.set(2, 2);
	eagMew.updateHitbox();
	eagMew.screenCenter();
	add(eagMew);

	new FlxTimer().start(1, function(tmr:FlxTimer)
	{
		FlxG.sound.play(Paths.sound('bear5scream'));
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			HandyDandy.loadWeek(["eag"], "Eagle", "eagle");
		});
	});
}

function activateEagle()
{
	eagleActive = true;

	trace("EAGLE RAHHH");

	FlxG.sound.play(Paths.sound((brazilON ? 'toucan sound' : 'eagle sound')));

	var isLeft:Bool = (FlxG.random.int(1, 2) == 2 ? true : false);
	var eagleY:Float = FlxG.random.float(-35, 450);
	var twnVar:Float = FlxG.random.float(0.75, 1.5);
	eagle.x = (isLeft ? -1000 : 1500);
	eagle.y = eagleY;

	eagle.flipX = (isLeft ? false : true);

	FlxTween.tween(eagle, {y: (FlxG.random.int(1, 2) == 2 ? eagleY + 100 : eagleY - 200)}, twnVar, {ease: FlxEase.linear});
	FlxTween.tween(eagle, {x: (!isLeft ? -1000 : 1500)}, twnVar, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween)
		{
			eagleActive = false;
		}
	});
}

//brazil
function toucanPressed(){
	selectedSomethin = true;
	trace("TOUCAN PRESSED");
	FlxG.sound.music.stop();
	FlxG.sound.play(Paths.sound('toucanbigscary'));

	var toucanSCARY:FlxSprite = new FlxSprite();
	toucanSCARY.loadGraphic(Paths.image('menus/mainmenu/brazil/toucan scary'));
	toucanSCARY.scale.set(0.005, 0.005);
	toucanSCARY.updateHitbox();
	toucanSCARY.screenCenter();
	add(toucanSCARY);

	FlxTween.tween(toucanSCARY, {"scale.x": 1, "scale.y": 1}, 1.446, {ease:FlxEase.linear, onComplete: function(twn:FlxTween){
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		HandyDandy.loadWeek(["can"], "Toucan", "toucan");
	}});
}