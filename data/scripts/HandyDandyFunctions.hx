import funkin.game.PlayState;

public static var curVidData:{vid:String, daFunc:Void->Void} = []; // for vidstate
public static var brazilOn:Bool = false;

public var HandyDandy:T = {
	// can use whenever
	loadWeek: function(weekSongs:Array<String>, name:String, id:String)
	{
		var songArray:Array<WeekSong> = [];
		PlayState.deathCounter = 0;
		brazilOn = !(FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);

		for (song in weekSongs)
			songArray.push({name: song, hide: false});
		PlayState.loadWeek({
			name: name,
			id: id,
			sprite: null,
			chars: [null, null, null],
			songs: songArray,
			difficulties: ["normal"]
		}, "normal");

		FlxG.switchState(new PlayState());
	},
	loadSong: function(song:String)
	{
		PlayState.loadSong(song.toLowerCase(), "normal", false, false);
		brazilOn = !(FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);
		FlxG.switchState(new PlayState());
	},
	watch: function(obj:FlxObject)
	{
		FlxG.watch.add(obj, "x");
		FlxG.watch.add(obj, "y");
	},
	// mod specific
	saveMailData: function(mail_id:String, letter_id:String, read_:Bool, display_name:String)
	{
		var didRead:Bool = read_;

		// changes value to true if it has already been read before
		if (FlxG.save.data.mailRead.contains(mail_id) && !read_)
		{
			didRead = true;
			trace("already read before");
		}

		if (!FlxG.save.data.mailRead.contains(mail_id))
			FlxG.save.data.mailRead.push(mail_id);

		// marks down if this is new mail or nah
		if (!FlxG.save.data.mailObtained.contains(mail_id))
		{
			FlxG.save.data.mailObtained.push(mail_id);
			trace("you got mail");
		}

		// saves the data of the mail
		FlxG.save.data.mailInventory.set(mail_id, {
			mailID: mail_id,
			letterID: letter_id,
			read: didRead,
			displayName: display_name
		});
		FlxG.save.flush(); // saves the game
	},
	playMenuSong: function(isBrazilOn:Bool)
	{
		if (isBrazilOn)
		{
			if (FlxG.sound.music == null || !brazilOn)
			{
				trace("PLAYING BRAZIL");
				brazilOn = true;
				if(FlxG.sound.music != null)
					FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.music('brazil anthem'), true, 1, true, 102);
				FlxG.sound.music.persist = true;
			}
		}
		else
		{
			if (FlxG.sound.music == null || brazilOn)
			{
				trace("PLAYING AMERIKUHN");
				brazilOn = false;
				if(FlxG.sound.music != null)
					FlxG.sound.music.stop();
				CoolUtil.playMenuSong();
			}
		}
	}
}
