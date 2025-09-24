import funkin.game.PlayState;

public static var curVidData:{vid:String, daFunc:Void->Void} = []; // for vidstate
public static var brazilOn:Bool = false;
public static var curCountry:String = 'america';

public var HandyDandy:T = {
	// can use whenever
	loadWeek: function(weekSongs:Array<String>, name:String, id:String) {
		var songArray:Array<WeekSong> = [];
		PlayState.deathCounter = 0;
		// brazilOn = !(FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);

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
	insert_camera: function(newCamera:FlxCamera, position:Int, defaultDrawTarget = true):T {
		if (position < 0)
			position += FlxG.cameras.list.length;

		if (position >= FlxG.cameras.list.length)
			return FlxG.cameras.add(newCamera);

		final childIndex = FlxG.game.getChildIndex(FlxG.cameras.list[position].flashSprite);
		FlxG.game.addChildAt(newCamera.flashSprite, childIndex);

		FlxG.cameras.list.insert(position, newCamera);
		if (defaultDrawTarget)
			FlxG.cameras.defaults.push(newCamera);

		for (i in position...(FlxG.cameras.list.length))
			FlxG.cameras.list[i].ID = i;

		FlxG.cameras.cameraAdded.dispatch(newCamera);
		return newCamera;
	},
	loadSong: function(song:String) {
		PlayState.loadSong(song.toLowerCase(), "normal", false, false);
		FlxG.switchState(new PlayState());
	},
	watch: function(obj:FlxObject) {
		FlxG.watch.add(obj, "x");
		FlxG.watch.add(obj, "y");
	},
	// mod specific
	saveMailData: function(mail_id:String, letter_id:String, read_:Bool, display_name:String) {
		var didRead:Bool = read_;

		// changes value to true if it has already been read before
		if (FlxG.save.data.mailRead.contains(mail_id) && !read_) {
			didRead = true;
			trace("already read before");
		}

		if (!FlxG.save.data.mailRead.contains(mail_id) && didRead)
			FlxG.save.data.mailRead.push(mail_id);

		// marks down if this is new mail or nah
		if (!FlxG.save.data.mailObtained.contains(mail_id)) {
			FlxG.save.data.mailObtained.push(mail_id);
			FlxG.save.data.mailInTruck.push(mail_id);
			trace("you got mail");
		}

		// saves the data of the mail
		if (!FlxG.save.data.mailInventory.exists(mail_id)) {
			FlxG.save.data.mailInventory.set(mail_id, {
				mailID: mail_id,
				letterID: letter_id,
				read: didRead,
				displayName: display_name
			});
		}

		FlxG.save.flush(); // saves the game
	},
	playMenuSong: function(?country:String = 'america') {
		if (curCountry != country || FlxG.sound.music == null || !FlxG.sound.music.playing) {
			if (curCountry != country)
				trace("THEY AREN'T THE SAME");

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			switch (country) {
				case 'brazil':
					trace("PLAYING BRAZIL");

					FlxG.sound.playMusic(Paths.music('brazil anthem'), true, 1, true, 102);
					FlxG.sound.music.persist = true;
				default:
					trace("PLAYING AMERIKUHN");
					CoolUtil.playMenuSong();
			}
			curCountry = country;
		}
	},
	resetSaveData: function() {
		brazilOn = !(FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.brazilMode ? true : false);
		// general
		FlxG.save.data.showGWWarning = true;
		FlxG.save.data.freeplayUnlockedGW = [];
		FlxG.save.data.songsUnlockedGW = [];
		FlxG.save.data.songsFCd = [];
		FlxG.save.data.songsSFCd = [];
		FlxG.save.data.whiteHouseRisen = false;
		if (!FlxG.save.data.weirdRouteEnabled)
			FlxG.save.data.flappyEagDelivered = false;
		// mail
		FlxG.save.data.mailUnlocked = false;
		FlxG.save.data.mailObtained = [];
		FlxG.save.data.mailInventory = ["" => []];
		FlxG.save.data.mailRead = [];
		FlxG.save.data.mailSongs = [];
		FlxG.save.data.mailInTruck = [];
		FlxG.save.data.curCountry = 'america';
		FlxG.save.flush();
		FlxG.resetGame();
	},
	saveDataUpdate: function() {
		// updates save data to general
		if (FlxG.save.data.brazilMode != null) {
			FlxG.save.data.brazilMode = null;
			FlxG.save.data.curCountry = (FlxG.save.data.brazilMode ? 'brazil' : 'america');
		}
		if (FlxG.save.data.curVersionGW == null) {
			if (FlxG.save.data.songsUnlockedGW.length >= 1) // remove for night shift update
				HandyDandy.saveMailData('welcomeback', 'welcomeback', false, "WELCOME BACK OLD PLAYER!");
			FlxG.save.data.curVersionGW = '1.2';
		}
	},
	antiNuke: function() {
		FlxG.save.data.flappyEagDelivered = false;
		FlxG.save.data.weirdRouteEnabled = false;
		FlxG.save.data.launchCodesObtained = false;
	}
}
