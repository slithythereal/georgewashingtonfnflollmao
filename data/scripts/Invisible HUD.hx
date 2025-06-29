function postCreate(){
	executeEvent({time: 0, name: "Tween HUD Alpha", params: [0, 0.001]});

    for (strum in strumLines)
        {
            for (i => strumLine in strumLines.members)
            {
                for (strumNote in strumLine.members)
                    strumNote.visible = false;
            }
        }
}
function onSongStart() {
    for (strum in strumLines)
		{
			for (i => strumLine in strumLines.members)
			{
				for (strumNote in strumLine.members){
					strumNote.alpha = 0;
					strumNote.visible = true;
				}
			}
		}
}