function postCreate() {
	var isBrazil:Bool = (FlxG.save.data.mailRead.contains("brazil") && FlxG.save.data.curCountry == 'brazil');
	var path:String = (isBrazil ? 'menus/mainmenu/brazil/pedromechanic' : 'menus/george mecahnic');

	var mekanik:FlxSprite = new FlxSprite((isBrazil ? 900 : 1020), 475);
	mekanik.loadGraphic(Paths.image(path));
	mekanik.scale.set(0.25, 0.15);
	mekanik.scrollFactor.set(0, 0);
	mekanik.updateHitbox();
	add(mekanik);
}
