importScript("data/scripts/HandyDandyFunctions");
var allMail:Array<String> = ["mcdonalds"];
var allLetters:Array<String> = ["grimace"];
var allDescriptions:Array<String> = ["Hiring Letter from MCDONALDS"];

public var MailUtil:T = {
	newRandomMail: function(curSong:String)
	{
		if (!FlxG.save.data.mailSongs.contains(curSong.toLowerCase()))
		{
			FlxG.save.data.mailSongs.push(curSong.toLowerCase());

            var mailObtained:Array<String> = FlxG.save.data.mailObtained;
            var containedMail:Array<String> = [];
            for (mail in allMail)
            {
                if (!mailObtained.contains(mail))
                    containedMail.push(mail.toLowerCase());
            }
        
            var needMail:Bool = (containedMail.length < 0 ? false : true);
            trace(needMail);
            if(needMail){
                var mailNum:Int = FlxG.random.int(0, containedMail.length - 1);
                HandyDandy.saveMailData(allMail[mailNum], allLetters[mailNum], false, allDescriptions[mailNum]);
            }
		}
	}
}

