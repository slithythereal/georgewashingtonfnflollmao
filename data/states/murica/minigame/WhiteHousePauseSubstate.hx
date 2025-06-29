import funkin.backend.utils.FunkinParentDisabler;
var parentDisabler:FunkinParentDisabler;

function postCreate(){
    add(parentDisabler = new FunkinParentDisabler());
    this.data.onOpen != null ? this.data.onOpen() : null;
}

function postUpdate(elapsed:Float){
    if(controls.BACK)
        closeThis();
}

function closeThis(){
    this.data.onClose != null ? this.data.onClose() : null;
    close();
}