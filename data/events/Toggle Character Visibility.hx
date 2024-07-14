function onEvent(_) {
    if(_.event.name == 'Toggle Character Visibility')
        strumLines.members[_.event.params[0]].characters[0].alpha = (_.event.params[1] == true ? 1 : 0.001); //I lied >:)
}