function postCreate()
{
	var mekanik:FlxSprite = new FlxSprite(1020, 475);
	mekanik.loadGraphic(Paths.image('menus/george mecahnic'));
	mekanik.scale.set(0.25, 0.15);
	mekanik.scrollFactor.set(0, 0);
	mekanik.updateHitbox();
	add(mekanik);
}
