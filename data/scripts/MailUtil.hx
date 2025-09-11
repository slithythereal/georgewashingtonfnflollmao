importScript("data/scripts/HandyDandyFunctions");
public var randomMail:Array<String> = ["brazil", "whitehouse"]; // random mail string

/*MAIL ORDER
 * potus: beat week 1
 * brazil: random
 * toucan: beat negotiations
 * whitehouse: random
 * welcomeback: have save file with previous version or null value
 */
public var allMailEver = [
	'potus' => {mailID: "potus", letterID: "eag", desc: "Letter from George Washington"},
	'toucan' => {mailID: "toucan", letterID: "toucan", desc: "Another Letter from the Brazilian government"},
	'brazil' => {mailID: "brazil", letterID: "brazil", desc: "Letter from Brazilian government"},
	'whitehouse' => {mailID: "whitehouse", letterID: "whitehouse", desc: "Letter from the White House"},
	'welcomeback' => {mailID: "welcomeback", letterID: "welcomeback", desc: "WELCOME BACK OLD PLAYER!"}
];

// used for random mail
public var mailData = [
	'brazil' => {letterID: "brazil", desc: "Letter from Brazilian government"},
	'whitehouse' => {letterID: "whitehouse", desc: "Letter from the White House"},
	'arcade' => {letterID: "arcade", desc: "Arcade Machine Delivery Notice"},
	'welcomeback' => {letterID: "welcomeback", desc: "WELCOME BACK OLD PLAYER!"}
];

public var allMail:Array<String> = ['potus', 'toucan', 'brazil', 'whitehouse', 'welcomeback', 'arcade'];

public var MailUtil:T = {
	newSingleMail: function(newMail:String) {
		HandyDandy.saveMailData(newMail, mailData[newMail].letterID, false, mailData[newMail].desc);
	},
	newRandomMail: function(curSong:String) {
		trace(FlxG.save.data.mailSongs);
		trace(FlxG.save.data.mailObtained);
		var inMailSongs:Bool = FlxG.save.data.mailSongs.contains(curSong.toLowerCase());
		if (!inMailSongs) {
			FlxG.save.data.mailSongs.push(curSong.toLowerCase());

			var mailObtained:Array<String> = FlxG.save.data.mailObtained;
			var containedMail:Array<String> = [];
			for (mail in randomMail)
				if (!mailObtained.contains(mail))
					containedMail.push(mail.toLowerCase());
			trace(containedMail);

			var needMail:Bool = (containedMail.length < 0 ? false : true);
			trace("UNLOCKED MAIL? " + needMail);
			trace(containedMail.length - 1);
			if (needMail) {
				var mailNum:Int = FlxG.random.int(0, containedMail.length - 1);
				var mail:String = containedMail[mailNum];
				HandyDandy.saveMailData(mail, mailData[mail].letterID, false, mailData[mail].desc);
				trace("MAIL SAVED " + mail + " " + mailData[mail].letterID + ": " + mailData[mail].desc);
			}
		}
	},
	traceMailData: function() {
		trace("MAIL INVENTORY: " + FlxG.save.data.mailInventory);
		trace("MAIL SONGS: " + FlxG.save.data.mailSongs);
		trace("MAIL OBTAINED: " + FlxG.save.data.mailObtained);
		trace("MAIL READ: " + FlxG.save.data.mailRead);
		trace("MAIL SONGS: " + FlxG.save.data.mailSongs);
		trace("MAIL IN TRUCK: " + FlxG.save.data.mailInTruck);
	},
	unlockALLMAIL: function() {
		for (mail in allMail)
			HandyDandy.saveMailData(allMailEver[mail].mailID, allMailEver[mail].letterID, false, allMailEver[mail].desc);

		trace("ALL MAIL UNLOCKED");
	}
}
