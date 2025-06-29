function update(elapsed)
{
    for(note in strumLines.members[0].notes)
    {
        if (note.noteType == 'Dementia Note' && Conductor.songPosition + 250 >= note.strumTime)
        {
            note.alpha -= 5 * elapsed;
            note.strumTime += FlxMath.lerp(0, 250, note.alpha / note.alpha) * elapsed;

            if (note.alpha <= 0)
                note.strumLine.deleteNote(note);
        }
    }
}