function onEvent(event){
    if(event.event.name == 'Play Sound Effect'){
        if(event.event.params[0] != null)
            FlxG.sound.play(Paths.sound(event.event.params[0]), Std.parseFloat(event.event.params[1]));
    }
}