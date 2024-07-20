import hxvlc.flixel.FlxVideo;
import Sys;
var funnyVideo:FlxVideo;

function postCreate(){
    funnyVideo = new FlxVideo();
    funnyVideo.load(Assets.getPath(Paths.video('eagle jumpsacre')));
    add(funnyVideo);
    funnyVideo.play();
    funnyVideo.onEndReached.add(function(){
        funnyVideo.dispose();
        Sys.exit(1);
    });
}