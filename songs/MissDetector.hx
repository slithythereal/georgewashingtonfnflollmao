import funkin.game.PlayState; //detects misses in a week and runs event

var funnySongs:Array<String> = [];
//might use this script for the future -slithy
function onSongEnd(){
    if(PlayState.isStoryMode && PlayState.storyPlaylist[0] == funnySongs[funnySongs.length-1] && PlayState.campaignMisses <= 0)
        trace("GIGGIDY");            
}

function create(){
    if(PlayState.isStoryMode){
        trace("script activate");
        funnySongs = [for(e in PlayState.storyWeek.songs) e.name];
    }
} 