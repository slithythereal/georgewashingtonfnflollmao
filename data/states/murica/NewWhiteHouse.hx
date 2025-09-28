import whiteHouse.InteractableThing;
import whiteHouse.Arrow;
import whiteHouse.Arrow.ArrowDirections;
import whiteHouse.Portrait;
import whiteHouse.InteractableThing;

import flixel.text.FlxTextBorderStyle;
/*import whiteHouse.Room;

var coolRoom:Room;*/

final startRoom = "startroom";
public var curRoom:String = "startroom";

var roomSprite:FunkinSprite;
//var coolPortrait:Portrait;
var arrowGroups:FlxTypedGroup<Arrow> = new FlxTypedGroup<Arrow>();
var specialArrows:Map<String, Arrow> = [];

var objGroups:FlxTypedGroup<InteractableThing> = new FlxTypedGroup<InteractableThing>();
var objMap:Map<String, InteractableThing> = [];

var whiteHouseRooms:Map<String, Dynamic> = [];
//var roomsCustomData:Map<String, Dynamic> = [];

var isGameActive:Bool = true;
var clickTimer:Bool = 0;

function initRooms()
{
    var raw = Assets.getText(Paths.json("config/whiteHouseRooms"));
    var data = Json.parse(raw);
    for (entry in data)
    {
        whiteHouseRooms.set(entry.roomName, entry);
        //if (entry.customData != null) { roomsCustomData.set(entry.roomName, entry); }
        if (entry.objs != null) { createObj(entry.objs, entry.roomName); }
    }
}

function create()
{
    FlxG.mouse.visible = true;
    FlxG.sound.music.stop();

    roomSprite = new FunkinSprite(0, 0, Paths.image("minigames/whitehouse/day/" + 'startroom'));
	roomSprite.scale.set(2.35, 2.35);
	roomSprite.updateHitbox();
	roomSprite.screenCenter();
    add(roomSprite);

    add(objGroups);
    add(arrowGroups);
    
    initRooms();
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

    roomSprite.loadGraphic(Paths.image("minigames/whitehouse/day/" + whiteHouseRooms[curRoom].roomImage));
    roomSprite.updateHitbox();

    createArrows(whiteHouseRooms[curRoom].arrows);
    showNHideObj();

    postLoadRoom(roomName);
}

function update(elapsed:Float)
{
	updateCameraStuffs(elapsed);

    if(clickTimer > 0) clickTimer -= elapsed;

    if (FlxG.keys.justPressed.R)
    {
        objGroups.forEachAlive(T->T.destroy(), false);
        objGroups.clear();
        objMap.clear();
        initRooms();
        loadRoom(curRoom);
    }
}

function updateCameraStuffs(elapsed:Float) {
    if (!isGameActive) return;

	var offset:Array<Float> = [-roomSprite.width/7, -roomSprite.height/9];//-roomSprite.width/6, -roomSprite.height/6];
	var mouseIntensity:Float = 0.25;
	var cameraIntensity:Float = 0.5;

	FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, FlxMath.lerp(offset[0], FlxG.mouse.screenX, mouseIntensity), cameraIntensity);
	FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, FlxMath.lerp(offset[1], FlxG.mouse.screenY, mouseIntensity), cameraIntensity);
}

function createObj(objList, ?roomReside:String = "")
{
    if (objList == null) return;

    for (i in objList)
    {
        var obj:InteractableThing = new InteractableThing(i.position[0], i.position[1], i);
        obj.room = roomReside;
        if (i.image != null) {
            if (i.animations != null)
            {
                obj.frames = Paths.getSparrowAtlas(obj.path + "objects/" + i.image);
                obj.hoverType = 0;
                for (anim in i.animations) obj.setAnims(anim);
            }
            else 
                obj.loadGraphic(Paths.image(obj.path + "objects/" + i.image));
        }

        if (i.scale != null) obj.scale.set(i.scale, i.scale);
        if (i.updateHitbox != null && i.updateHitbox == true) obj.updateHitbox();

        obj.select = ()->{clickObj(i.name, obj.room, obj);};

        objGroups.add(obj);

        objMap.set(i.name, obj);

        postCreateObj(i.name, obj);
    }
}

function showNHideObj() for (i in objMap) i.active = i.visible = i.exists = (i.room == curRoom);

function createArrows(arrowsList)
{
    arrowGroups.forEachAlive(T->T.destroy(), false);
    arrowGroups.clear();
    specialArrows.clear();

    for (i in arrowsList)
    {
        var dir = switch(i.direction) { case "left": ArrowDirections.LEFT; case "right": ArrowDirections.RIGHT; case "down": ArrowDirections.DOWN; case "up": ArrowDirections.UP; };
        var coolArrow = new Arrow(i.position[0], i.position[1], i, dir, i.roomName);
        coolArrow.select = () -> {
            if(clickTimer <= 0 && isGameActive)
            {
                FlxG.sound.play(Paths.sound('minigame/whitehouse_day/' + (coolArrow.stepSound != null ? coolArrow.stepSound : 'fnaf4runsound')), 0.7);
                loadRoom(coolArrow.roomFinal);
            }
        };
        specialArrows.set(i.id, coolArrow);
        arrowGroups.add(coolArrow);
    }
}

public function preLoadRoom(roomName:String)
{
    
}

public function postLoadRoom(roomName:String)
{
    if (roomName == "startroom")
    {
        if (!whiteHouseRooms[roomName].customData.initialized)
        {
            isGameActive = false;
            FlxG.camera.zoom = 2;
            FlxG.camera.alpha = 0;
            FlxG.sound.play(Paths.sound('minigame/whitehouse_day/riser'), 0.7);
            for (arrow in arrowGroups) arrow.visible = arrow.isSelectable = false;
            FlxTween.tween(FlxG.camera, {alpha: 1, zoom: 1}, 5, {
                ease: FlxEase.linear,
                onComplete: function(twn:FlxTween) {
                    new FlxTimer().start(2.5, function(tmr:FlxTimer) {
                        for (arrow in arrowGroups) arrow.visible = arrow.isSelectable = true;
                        whiteHouseRooms[roomName].customData.initialized = isGameActive = true;
                    });
                }
            });
        }
    }

    if (roomName == "1floorstairs")
    {
        var gateArrow = specialArrows["gate"];
        if (!whiteHouseRooms[roomName].customData.openedGate) gateArrow.isSelectable = gateArrow.visible = false;
    }
}

public function postCreateObj(objName:String, obj:InteractableThing)
{
    if (objName == "gate")
    {
        obj.origin.set(460, 125);
    }
}

public function clickObj(objName:String, objRoom:String, obj:InteractableThing)
{
    if (!isGameActive) return;
    if (curRoom != objRoom) return;

    if (objName == "clickableDoor")
    {
        funnyTextThing('get some tapes first...\n' + /* + tapeCount + "/" + tapeAmt + */" tapes collected", FlxPoint.get(520, 365), 0.75, 300, 25);
    }

    if (objName == "gate")
    {
        if (!whiteHouseRooms[objRoom].customData.openedGate)
        {
            clickTimer = 0.5;
            whiteHouseRooms[objRoom].customData.openedGate = true;
            var gateArrow = specialArrows["gate"];
            gateArrow.isSelectable = gateArrow.visible = true;
            obj.playAnim("doorlift", true);
        }
    }
}

public function funnyTextThing(txt:String, pos:FlxPoint, twnTime:Float, txtAcceleration:Float, ?size:Int = 45):FlxSprite
{
	var txt:FlxText = new FlxText(pos.x, pos.y, 0, txt);
	txt.setFormat("fonts/THE PRESIDENT.ttf", size, FlxColor.WHITE, "center");
	txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	txt.borderSize = 2;
	objGroups.add(txt);
	txt.moves = true;
	txt.acceleration.x = -txtAcceleration / 1000;
	txt.acceleration.y = txtAcceleration;
	txt.velocity.set(FlxG.random.float(25, -25));
	FlxTween.tween(txt, {alpha: 0}, twnTime, {
		ease: FlxEase.linear,
		onComplete: function() {
			objGroups.remove(txt);
		}
	});
}