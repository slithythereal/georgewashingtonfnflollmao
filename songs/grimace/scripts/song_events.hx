import funkin.game.PlayState;

function create() {
	window.title = "McDonald's Advertisement";
	camGame.visible = false;
}

function onGameOver(event) {
	if (!camGame.visible)
		camGame.visible = true;
}

function yo()
	camGame.visible = true;
