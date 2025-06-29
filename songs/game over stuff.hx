function create()
{
	if (boyfriend.xml.exists('lossSfx'))
		lossSFX = (boyfriend.xml.get('lossSfx'));
	if (boyfriend.xml.exists('gameOverMusic'))
		gameOverSong = (boyfriend.xml.get('gameOverMusic'));
	if (boyfriend.xml.exists('retrySfx'))
		retrySFX = (boyfriend.xml.get('retrySfx'));
}
