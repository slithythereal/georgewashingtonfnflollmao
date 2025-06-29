function onPlayerHit(event)
{
	if (event.noteType != "Eagle Sing")
	{
		changeIcon(false);
		return;
	}
	changeIcon(true);
	event.character = gf;
}

function onPlayerMiss(event)
{
	if (event.noteType != "Eagle Sing")
		return;

	event.animCancelled = true;
	gf.playAnim("miss", false, null);
}

function changeIcon(isEag:Bool) // changes icon
{
	if (isEag)
	{
		iconP1.setIcon(gf != null ? gf.getIcon() : 'face');
		if (Options.colorHealthBar)
			healthBar.createColoredFilledBar(gf != null && gf.iconColor != null ? gf.iconColor : 0xFF66FF33);
	}
	else
	{
		iconP1.setIcon(boyfriend != null ? boyfriend.getIcon() : 'face');
		if (Options.colorHealthBar)
			healthBar.createColoredFilledBar(boyfriend != null && boyfriend.iconColor != null ? boyfriend.iconColor : 0xFF66FF33);
	}
}
