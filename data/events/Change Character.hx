import haxe.ds.StringMap; //character change event by Rodney528 https://gamebanana.com/members/1729833

public var charMap:Array<Array<StringMap<Character>>> = [];
function charMapNullCheck(strumIndex:Int, charIndex:Int) {
	if (charMap[strumIndex] == null) charMap[strumIndex] = [];
	if (charMap[strumIndex][charIndex] == null) charMap[strumIndex][charIndex] = new StringMap();
}

// partially stole from gorefield lol
function postCreate() {
	// add preexisting
	for (strumLine in strumLines) {
		var strumIndex:Int = strumLines.members.indexOf(strumLine);
		for (char in strumLine.characters) {
			var charIndex:Int = strumLine.characters.indexOf(char);

			// null check
			charMapNullCheck(strumIndex, charIndex);
			
			// le code
			charMap[strumIndex][charIndex].set(char.curCharacter, char);
			trace('Preexisting index "' + charIndex + '" character "' + char.curCharacter + '" on strumLine "' + strumIndex + '".');
		}
	}
	// precache
	for (event in events)
		if (event.name == 'Change Character')
			precacheCharacter(event.params[0], event.params[1], event.params[2]);
}

public function precacheCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0) {
	// vars
	var strumLine:StrumLine = strumLines.members[strumIndex];
	var firstChar:Character = strumLine.characters[0];

	// null check
	charMapNullCheck(strumIndex, memberIndex);
	
	// precache process
	if (!charMap[strumIndex][memberIndex].exists(charName)) {
		var newCharacter:Character = new Character(firstChar.x, firstChar.y, charName, firstChar.isPlayer);
		charMap[strumIndex][memberIndex].set(newCharacter.curCharacter, newCharacter);
		newCharacter.active = newCharacter.visible = false;
		trace('Precached index "' + memberIndex + '" character "' + newCharacter.curCharacter + '" on strumLine "' + strumIndex + '".');

		// sometimes this works and other times it doesn't
		try {
			for (c in newCharacter.cameras) {
				newCharacter.drawComplex(c);
			}
		}
		catch(e:Dynamic) {
			trace('drawComplex didn\'t work this time for some reason');
		}

		// cam stage offsets
		switch (strumIndex) {
			case 0:
				newCharacter.cameraOffset.x += stage?.characterPoses['dad']?.camxoffset;
				newCharacter.cameraOffset.y += stage?.characterPoses['dad']?.camyoffset;
			case 1:
				newCharacter.cameraOffset.x += stage?.characterPoses['boyfriend']?.camxoffset;
				newCharacter.cameraOffset.y += stage?.characterPoses['boyfriend']?.camyoffset;
			case 2:
				newCharacter.cameraOffset.x += stage?.characterPoses['girlfriend']?.camxoffset;
				newCharacter.cameraOffset.y += stage?.characterPoses['girlfriend']?.camyoffset;
		}
	}
}

public function changeCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0, ?updateBar:Bool = true) {
	// vars
	var oldChar:Character = strumLines.members[strumIndex].characters[memberIndex];
	var newCharacter:Character = charMap[strumIndex][memberIndex].get(charName);

	// null check
	if (oldChar.curCharacter == newCharacter.curCharacter) return trace('It\'s the same character bro.');
	if (oldChar == null || newCharacter == null) return;

	// icon change + healthBar color update
	if (memberIndex == 0 && updateBar) {
		if (strumIndex == 0) { // opponent side
			iconP2.setIcon(newCharacter != null ? newCharacter.getIcon() : 'face');
			if (Options.colorHealthBar) healthBar.createColoredEmptyBar(newCharacter != null && newCharacter.iconColor != null ? newCharacter.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000));
		} else if (strumIndex == 1) { // player side
			iconP1.setIcon(newCharacter != null ? newCharacter.getIcon() : 'face');
			if (Options.colorHealthBar) healthBar.createColoredFilledBar(newCharacter != null && newCharacter.iconColor != null ? newCharacter.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33));
		}
	}

	// swaps old and new char
	var group = FlxTypedGroup.resolveGroup(oldChar);
	if (group == null) group = this;
	group.insert(group.members.indexOf(oldChar), newCharacter);
	newCharacter.active = newCharacter.visible = true;
	group.remove(oldChar);
	
	// fully apply change
	newCharacter.setPosition(oldChar.x, oldChar.y);
	newCharacter.playAnim(oldChar.animation?.name);
	newCharacter.animation?.curAnim?.curFrame = oldChar.animation?.curAnim?.curFrame;
	strumLines.members[strumIndex].characters[memberIndex] = newCharacter;
	trace('Character index "' + memberIndex + '" changed to "' + newCharacter.curCharacter + '" on strumLine "' + strumIndex + '"!');
}

function onEvent(event) {
	switch (event.event.name) {
		case 'Change Character':
			changeCharacter(event.event.params[0], event.event.params[1], event.event.params[2], event.event.params[3]);
	}
}