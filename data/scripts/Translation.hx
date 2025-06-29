public var portugese:Map<String, String> = [
    'PLAY' => 'JOGAR',
    'FREEPLAYLANDIA' => 'TERRA DE LOGO GRÁTIS',
    'OPTIONS' => 'OPÇÕES',
    'CREDITS' => 'CRÉDITOS',
];

public function returnPortugese(word:String):String { 
    if(portugese.exists(word))
        return portugese[word];
}