import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.FlxObject;

importScript("data/scripts/HandyDandyFunctions");
var mailArray:Array<String> = [];
var existingMailArray:Array<String> = ['potus', 'brazil', 'toucan'];
// mail data in one variable instead of making multiple variables for them
var mailInventory:Map<String,
	{
		mailID:String,
		letterID:String,
		read:Bool,
		displayName:String
	}> = [];

var mails:FlxTypedGroup<FlxSprite>;
var textbg:FlxSprite;
var displayTxt:FlxText;
var isViewingNote:Bool;
var curMailID:Int;
var isDisplayVisible:Bool = false;
var letter:FlxSprite;

// functions for when you close the letter for the 1st time
var mailCloseFuncs:Map<String, Void->Void> = [];

function create()
{
	loadData();
	CoolUtil.playMenuSong();

	var bg:FlxSprite = new FlxSprite(); // temp bg
	bg.loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFF4E98CA;
	bg.screenCenter();
	add(bg);

	mails = new FlxTypedGroup();
	add(mails);

	var mailTXT:FlxText = new FlxText(50, 25, 0, "Boyfriend's Mailbox", 32);
	mailTXT.setFormat("fonts/impact.ttf", 45, 0xFF1374CF, "center");
	mailTXT.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	mailTXT.borderSize = 2;
	mailTXT.screenCenter(FlxAxes.X);
	add(mailTXT);

	for (i in 0...mailArray.length)
	{
		var mail:FlxSprite = new FlxSprite(FlxG.random.float(0, 1130), FlxG.random.float(0, 580));
		mail.loadGraphic(Paths.image('menus/mailbox/mailIcons/' + mailArray[i] + "_mail"));
		mail.scale.set(1, 1);
		mail.updateHitbox();
		mail.ID = i;
		if (mailInventory[mailArray[i]].read == false) // makes unread mail yellow to avoid confusion
			mail.color = FlxColor.YELLOW;
		mails.add(mail);
		HandyDandy.watch(mail);
	}

	textbg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	textbg.alpha = 0.6;
	add(textbg);

	displayTxt = new FlxText(50, 600, 1180, "", 32);
	displayTxt.setFormat("fonts/impact.ttf", 25, FlxColor.WHITE, "center");
	displayTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5, 25);
	displayTxt.borderSize = 2;
	displayTxt.screenCenter(FlxAxes.X);
	add(displayTxt);

	letter = new FlxSprite();
	letter.screenCenter();
	letter.visible = false;
	add(letter);
}

function update(elapsed:Float)
{
	if (!isViewingNote)
	{
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		mails.forEach(function(mail:FlxSprite)
		{
			if (FlxG.mouse.overlaps(mail))
			{
				toggleDisplayTxt(mail, true);
				if (FlxG.mouse.justPressed)
					openLetter(mailInventory[mailArray[mail.ID]].letterID, mail.ID); // opening mail function
			}
			else
				toggleDisplayTxt(mail, false);
		});
	}
	else
		if (controls.BACK)
			closeLetter();
	
}

function toggleDisplayTxt(mail:FlxSprite, isON:Bool) {
	if(isON){
		mail.scale.set(1.15, 1.15);
		var plswork:Int = mail.ID;
		if (!mailInventory[mailArray[plswork]].read) // makes text yellow when not been read yet
		{
			displayTxt.color = FlxColor.YELLOW;
			displayTxt.text = "(UNREAD) " + mailInventory[mailArray[plswork]].displayName;
		}
		else
		{
			displayTxt.text =  '' + mailInventory[mailArray[plswork]].displayName;
			displayTxt.color = FlxColor.WHITE;
		}
		textbg.setPosition(displayTxt.x - 10, displayTxt.y - 10);
		textbg.setGraphicSize(Std.int(displayTxt.width + 20), Std.int(displayTxt.height + 25));
		textbg.updateHitbox();
	}
	else{
		mail.scale.set(1, 1);
	}
}

function loadData()
{
	var saveMailArray:Array<String> = [];
	FlxG.mouse.visible = true;
	// takes mail stuff from savedata
	saveMailArray = FlxG.save.data.mailObtained;
	mailInventory = FlxG.save.data.mailInventory;

	for(mail in saveMailArray)
		if(existingMailArray.contains(mail))
			mailArray.push(mail);
	trace(mailArray);
	trace(mailInventory);
}

function openLetter(curletter:String, mailID:Int) // opens the letter
{
	FlxG.sound.play(Paths.sound("ui/paper"));
	letter.loadGraphic(Paths.image("menus/mailbox/letters/" + curletter + "_letter"));
	letter.scale.set(1, 1);
	letter.updateHitbox();
	letter.screenCenter();
	letter.visible = true;
	isViewingNote = true;
	curMailID = mailID;
}

function closeLetter() // closes the letter
{
	FlxG.sound.play(Paths.sound("ui/paper2"));
	var funnyRead:Bool;
	letter.visible = false;
	var mailid:String = mailArray[curMailID]; // makes string variable to make it easy to read
	var firstTimeRead:Bool = false;

	funnyRead = mailInventory[mailid].read;
	if (!funnyRead)
		firstTimeRead = true; // detects if read for the first time
	mails.forEach(function(mail:FlxSprite)
	{
		if (mail.ID == curMailID)
		{
			if (!mailInventory[mailid].read) // makes mail white when read
			{
				mail.color = FlxColor.WHITE;
				funnyRead = true;
			}
		}
	});

	// puts mail in savedata
	HandyDandy.saveMailData(mailInventory[mailid].mailID, mailInventory[mailid].letterID, funnyRead, mailInventory[mailid].displayName);

	// sets variables
	mailInventory.set(mailid, {
		mailID: mailInventory[mailid].mailID,
		letterID: mailInventory[mailid].letterID,
		read: funnyRead,
		displayName: mailInventory[mailid].displayName
	});

	// runs function for when mail is closed, only applied to some mail
	if (mailCloseFuncs.exists(mailid) && firstTimeRead)
		mailCloseFuncs[mailid]();

	isViewingNote = false;
}
