import funkin.backend.utils.DiscordUtil;

/*	KOI!!! PLEASE CREATE THE APP :sob: i created it for testing but you should be the one that owns it
----> https://discord.com/developers/applications --> get clientID when u create it --> go to discord.json in files -> change clientID to the one on the website
*/

// i did it (after figuring out my discord was bugging after like two hours) !! thanks jr ur the best <3 -koi

// https://github.com/CodenameCrew/CodenameEngine/blob/main/source/funkin/backend/utils/DiscordUtil.hx
// restart game every single time when you update something here, im gonna kms

function onGameOver() {
	DiscordUtil.changePresence('Game Over', PlayState.SONG.meta.displayName);
}

function onDiscordPresenceUpdate(e) {
	//NOTE TO SELF: THESE BUTTONS DON'T SHOW UP FOR YOURSELF, I'VE SPENT AN HOUR BEING STUPID, RAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
	e.presence.button1Label = "Download";
	e.presence.button1Url = "https://gamebanana.com/mods/605482";
	e.presence.button2Label = "Twitter";
	e.presence.button2Url = "https://x.com/teamobscuro";

	//change to default stuff regardless
	e.presence.largeImageKey = "logo"; //LOGO KEY CAN ALSO BE A URL TO AN IMAGE OR GIF!!!
	e.presence.largeImageText = "RSM";
	if (PlayState.instance != null) { //exists in freeplay..? alr
		if (!FlxG.save.data.RSM_devMode) {
			e.presence.largeImageKey = PlayState.SONG.meta.name.toLowerCase().split(" ").join("-"); //SAME APPLIES HERE
			e.presence.largeImageText = PlayState.SONG.meta.displayName;
		} else {
			e.presence.largeImageKey = "https://raw.githubusercontent.com/JuniorNovoa1/discordRPCstuff/refs/heads/main/gifs/rickroll.gif"; //tee hee
			e.presence.largeImageText = "no leaking tee hee";
			e.presence.state = "no leaks!!";
		}
	}
}

function onPlayStateUpdate() {
	DiscordUtil.changeSongPresence(
		PlayState.instance.detailsText,
		(PlayState.instance.paused ? "Paused - " : "") + PlayState.SONG.meta.displayName,
		PlayState.instance.inst,
		PlayState.instance.getIconRPC() //doesnt work when exiting from song to main menu/freeplay
	);
}

function onMenuLoaded(name:String) {
	// Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
	switch(name) {
		case "Freeplay":
			DiscordUtil.changePresenceSince("In the Freeplay Menu", null);
		default:
			DiscordUtil.changePresenceSince("In the Menus", null);
	}
}

function onEditorTreeLoaded(name:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Choosing a Character", null);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Choosing a Chart", null);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Choosing a Stage", null);
	}
}

function onEditorLoaded(name:String, editingThing:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Editing a Character", editingThing);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Editing a Chart", editingThing);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Editing a Stage", editingThing);
	}
}