public var translation = [
	// main menu
	'play_C' => {eng: "PLAY", por: "JOGAR"},
	'freeplaylandia_C' => {eng: "FREEPLAYLANDIA", por: "TERRA DE LOGO GRÁTIS"},
	'options_C' => {eng: "OPTIONS", por: "OPÇÕES"},
	'credits_C' => {eng: "CREDITS", por: "CRÉDITOS"},
	// options menu
	'on_C' => {eng: "ON", por: 'LIGADO'},
	'off_C' => {eng: "OFF", por: "DESLIGADO"},
	'on_l' => {eng: "on", por: 'ligado'},
	'off_l' => {eng: "off", por: "desligado"},
	'warningscreen' => {eng: "Warning Screen", por: "Tela de aviso"},
	'subtitles' => {eng: "Subtitles", por: "Legendas"},
	'back' => {eng: "Back", por: "Retornar"},
	'engineoptions' => {eng: "Engine Options", por: "Opções Mecanismo Jogo"},
	'rsaved_C' => {por: "REDEFINIR DADOS SALVOS!", eng: "RESET SAVE DATA!"},
	// option descripions
	'rsaved_l' => {por: "Redefina seus dados salvos!", eng: "Reset your save data!"},
	'engoptdesc' => {
		eng: 'The options for the mod engine, you can find controls, gameplay settings, and more!',
		por: 'Nas opções do mecanismo de mod você pode encontrar controles, configurações de jogabilidade e muito mais!'
	},
	'backoptdesc' => {eng: "Go back to main menu", por: "Voltar ao menu principal"},
	'subtdesc' => {eng: 'Enable/Disable Subtitles for the mod!', por: 'Habilitar/Desabilitar legendas para o mod!'},
	'warningscreendesc' => {por: "Ative/desative a tela de aviso que aparece antes de você jogar o mod!",
		eng: "Enable/Disable the warning screen that pops up before you play the mod!"},
	'tabpress'=> {eng: "PRESS [TAB] TO TOGGLE DESCRIPTION", por: 'PRESSIONE [TAB] PARA ALTERAR A DESCRIÇÃO'}
];

// returns "on"/"off" in correct translation
public function returnONOFF(boolvar:Bool, lang:String) {
	return returnTrans((boolvar ? 'on_C' : 'off_C'), lang);
}

// returns translation
public function returnTrans(item:String, lang:String) {
	switch (lang) {
		case 'por' | 'brazil' | 'portuguese':
			return translation[item].por;
		default:
			return translation[item].eng;
	}
}

public static var curLang:String = 'eng';

// sets current language
public function setCurLang() {
	switch (FlxG.save.data.curCountry) {
		case 'brazil':
			curLang = 'por';
		default:
			curLang = 'eng';
	}
}
