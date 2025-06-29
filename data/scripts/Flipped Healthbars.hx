import funkin.game.PlayState;

function postCreate()
    healthBar.flipX = iconP1.flipX = iconP2.flipX = true;

function postUpdate(elapsed){
    var hbCenter:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 100, 0, 1, 0);

    iconP1.x = hbCenter - (iconP1.width - 26);
    iconP2.x = hbCenter - 26;
}