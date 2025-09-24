import whiteHouse.Arrow;
import whiteHouse.Arrow.ArrowDirections;
import whiteHouse.Portrait;
/*import whiteHouse.Room;

var coolRoom:Room;*/

final startRoom = "startroom";
public var curRoom:String = "startroom";

var roomSprite:FunkinSprite;
//var coolPortrait:Portrait;
var arrowGroups:FlxTypedGroup<Arrow> = new FlxTypedGroup<Arrow>();

var whiteHouseRooms:Map<String, Dynamic> = [];

var clickTimer = 0;

function initRooms()
{
    var raw = Assets.getText(Paths.json("config/whiteHouseRooms"));
    var data = Json.parse(raw);
    for (entry in data) whiteHouseRooms.set(entry.roomName, entry);
}

function create()
{
    FlxG.mouse.visible = true;
    FlxG.sound.music.stop();

    initRooms();

    roomSprite = new FunkinSprite(0, 0, Paths.image("minigames/whitehouse/day/" + 'startroom'));
	roomSprite.scale.set(2.35, 2.35);
	roomSprite.updateHitbox();
	roomSprite.screenCenter();
    add(roomSprite);

    /*coolPortrait = new Portrait(500, 100, "george");
    add(coolPortrait);*/

    add(arrowGroups);

    loadRoom(startRoom);

    FlxG.camera.setScrollBoundsRect(roomSprite.x, roomSprite.y, roomSprite.width, roomSprite.height);
}

function loadRoom(roomName:String = null)
{
    if (roomName == null || roomName == "") return;

    clickTimer = 0.01;

    preLoadRoom(roomName);

    var previousRoom = curRoom;
    curRoom = roomName;

    trace(roomName);

    roomSprite.loadGraphic(Paths.image("minigames/whitehouse/day/" + whiteHouseRooms[curRoom].roomImage));
    roomSprite.updateHitbox();

    createArrows(whiteHouseRooms[curRoom].arrows);

    postLoadRoom(roomName);
}

function update(elapsed:Float)
{
	updateCameraStuffs(elapsed);

    if(clickTimer > 0) clickTimer -= elapsed;
}

function updateCameraStuffs(elapsed:Float) {
	var offset:Array<Float> = [-roomSprite.width/7];//-roomSprite.width/6, -roomSprite.height/6];
	var mouseIntensity:Float = 0.25;
	var cameraIntensity:Float = 0.5;
	//if (canPressAnything && !isPaused) {
		FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, FlxMath.lerp(offset[0], FlxG.mouse.screenX, mouseIntensity), cameraIntensity);
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, FlxMath.lerp(offset[1], FlxG.mouse.screenY, mouseIntensity), cameraIntensity);
	//}
}

function createArrows(arrosList)
{
    arrowGroups.forEachAlive(T->T.destroy(), false);
    arrowGroups.clear();

    for (i in arrosList)
    {
        var dir = switch(i.direction) { case "left": ArrowDirections.LEFT; case "right": ArrowDirections.RIGHT; case "down": ArrowDirections.DOWN; case "up": ArrowDirections.UP; };
        var coolArrow = new Arrow(i.position[0], i.position[1], dir, i.roomName);
        coolArrow.select = ()->{if(clickTimer <= 0) {FlxG.sound.play(Paths.sound('minigame/whitehouse_day/' + (coolArrow.stepSound != null ? coolArrow.stepSound : 'fnaf4runsound')), 0.7); loadRoom(coolArrow.roomFinal);} };
        if (i.angle != null) coolArrow.angle = i.angle;
        arrowGroups.add(coolArrow);
    }
}

public function preLoadRoom(roomName:String)
{

}

public function postLoadRoom(roomName:String)
{

}