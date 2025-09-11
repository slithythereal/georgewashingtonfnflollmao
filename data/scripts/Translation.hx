public var translation = [ //ENG: English, POR: Portuguese
	// main menu
	'play_C' => {eng: "PLAY", por: "JOGAR"},
	'freeplaylandia_C' => {eng: "FREEPLAYLANDIA", por: "TERRA LIVRE"},
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
	'engineoptions' => {eng: "Engine Options", por: "Opções Da Engine"},
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
	'tabpress'=> {eng: "PRESS [TAB] TO TOGGLE DESCRIPTION", por: 'PRESSIONE [TAB] PARA ALTERAR A DESCRIÇÃO'},
	//resetsavedata
	'rsd_1' => {eng: "ARE YOU SURE YOU WANT TO RESET YOUR SAVE DATA?", por: 'TEM CERTEZA QUE DESEJA REINICIAR SEUS DADOS SALVOS?'},
	'rsd_2' => {eng: "ANY PROGRESS YOU HAVE FOR THE MOD WILL BE LOST.", por: "QUALQUER PROGRESSO QUE VOCÊ TENHA FEITO NO MOD SERÁ PERDIDO."},
	'rsd_3' => {eng: 'THIS WILL ALSO RESET YOUR GAME', por: 'ISTO TAMBÉM REINICIARÁ SEU JOGO'},
	'rsd_4' => {eng: "THIS WILL NOT RESET CODENAME ENGINE SAVE DATA", por: "ISTO NÃO REINICIARÁ OS DADOS DE SALVAMENTO DO CODENAME ENGINE"},
	'yes_C' => {eng: "YES", por: 'SIM'},
	'no_C' => {eng: "NO", por: 'NÃO'},
	//etc
	'special thanks_C' => {eng: "SPECIAL THANKS", por: 'AGRADECIMENTOS ESPECIAIS'},
	'voice actors_C' => {eng: "VOICE ACTORS", por: "DUBLADORES"},
	'bfmailbox' => {eng: "Boyfriend's Mailbox", por: "Caixa de correio do Boyfriend"},
	'credineng' => {eng: "credits in english", por: "créditos em inglês"}
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
