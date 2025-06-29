function onEvent(event){
    if(event.event.name == 'Taunt'){
        if(event.event.params[0])
            boyfriend.playAnim('taunt_' + FlxG.random.int(1, 3), true);
        else
            dad.playAnim('taunt_' + FlxG.random.int(1, 3), true);
    }
}