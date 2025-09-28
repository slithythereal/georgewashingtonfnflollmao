package whiteHouse; // Allow `package` declaration. Ignored by the interpreter.

import whiteHouse.InteractableThing;

class Items extends InteractableThing
{
    var itemName = "";
    var itemID = "";
    public function new(x:Float, y:Float, item:String, itemID:String) {
        super(x, y, null);
        itemName = item;
        this.itemID = itemID;
        //other code stuff
    }
}