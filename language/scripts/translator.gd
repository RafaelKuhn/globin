extends Node


const Language = preload("res://language/scripts/language_enum.gd")

var language := Language.EN
signal language_changed


func _ready():
	_initialize_end_game_terms()

	if OS.is_debug_build():
		_sanity()

	var url_lang = JavaScript.eval("new URL(window.location.href).searchParams.get('lang')")
	if url_lang == null:
		return

	url_lang = url_lang.to_lower()
	# print("LANG : '%s'" % url_lang)

	match url_lang:
		"en":
			change_language(Language.EN)
		"br" || "pt" || "pt-br":
			change_language(Language.BR)
		_:
			print("unknown language: '%s' try 'en' or 'br'" % url_lang)


func change_language(new_lang):
	language = new_lang
	emit_signal("language_changed")


func get_term(term_key):
	var term_list = term_arr_by_key.get(term_key)
	if term_list == null:
		push_error("NULL ITEM %s" % term_key)
		return
	var lang_index = _lang_to_index(language)
	var term = term_list[lang_index]
	if term == null:
		push_error("NULL TERM ")
		return
	return term


func bind_label(label: Label, term_key):
	if label.get_child_count() == 0:
		push_error("no refresher found under %s/%s " % [ label.get_parent().name, label.name ])
		return

	var refresher = label.get_child(0)
	if OS.is_debug_build():
		if refresher.name.find("REFRESH_TRANSLATION") == -1:
			push_error("no refresher found under %s/%s " % [ label.get_parent().name, label.name ])
			return

	var term = get_term(term_key)
	if term == null:
		push_error("NULL ITEM")
		return
	label.text = term
	var __ = connect("language_changed", refresher, "refresh_label", [ term_key ])

func bind_label_dyn(label: Label, term_key, times_lost):
	if label.get_child_count() == 0:
		push_error("no refresher found under %s/%s " % [ label.get_parent().name, label.name ])
		return

	var refresher = label.get_child(0)
	if OS.is_debug_build():
		if refresher.name.find("REFRESH_TRANSLATION") == -1:
			push_error("no refresher found under %s/%s " % [ label.get_parent().name, label.name ])
			return

	var term = get_term(term_key)
	if term == null:
		push_error("NULL TERM? ")
		return

	# print(" BOUND language changed dyn!")
	label.text = term % times_lost
	var __ = connect("language_changed", refresher, "refresh_label_dyn", [ term_key, times_lost ])


func _refresh_dynamic_label(label, term_key):
	# print("refreshing dynamic label %s w term %s lang %s new term: %s" % [ label, term_key, Translator.language, get_term(term_key)])
	label.text = get_term(term_key)


func _lang_to_index(lang) -> int:
	match lang:
		Language.EN:
			return 0
		Language.BR:
			return 1
		_:
			push_error("UNHANDLED LANGUAGE %s" % lang)
			return -1


func _sanity():
	# TODO: check if all terms have "language.count" items
	pass

func _initialize_end_game_terms():
	for i in lost_hard_texts.size():
		var term_arr = lost_hard_texts[i]
		var key = "hard_lost_label_%s" % i;
		term_arr_by_key[key] = term_arr

	for i in lost_medi_texts.size():
		var term_arr = lost_medi_texts[i]
		var key = "medi_lost_label_%s" % i;
		term_arr_by_key[key] = term_arr

	for i in lost_easy_texts.size():
		var term_arr = lost_easy_texts[i]
		var key = "easy_lost_label_%s" % i;
		term_arr_by_key[key] = term_arr


	for i in lost_hard_answers.size():
		var term_arr = lost_hard_answers[i]
		var key = "hard_lost_answer_%s" % i;
		term_arr_by_key[key] = term_arr

	for i in lost_medi_answers.size():
		var term_arr = lost_medi_answers[i]
		var key = "medi_lost_answer_%s" % i;
		term_arr_by_key[key] = term_arr


var term_arr_by_key := {

	# General
	"go_back": [ "Go Back", "Voltar" ],
	"press_b": [ "(press B)", "(pressione B)" ],
	"playzao": [ "PLAY", "JOGAR" ],
	"press_space": [ "(press SPACE or ENTER)", "(pressione SPACE ou ENTER)" ],
	"difficulty": [ "Difficulty:", "Dificuldade:" ],


	# Menu
	"play": [ "Play", "Jogar" ],
	"how_to": [ "How To Play", "Como Jogar?" ],
	"game_by": [ "Game By:", "Jogo:" ],
	"art_by":  [ "Art By:", "Arte:" ],

	"press_h": [ "(press H)", "(pressione H)" ],
	"press_l": [ "(press L)", "(pressione L)" ],
	"press_1": [ "(press 1)", "(pressione 1)" ],
	"press_2": [ "(press 2)", "(pressione 2)" ],


	# How To Play
	"a_or": [ "(A or ←)", "(A ou ←)" ],
	"d_or": [ "(D or →)", "(D ou →)" ],

	"how_to_0": [
		"Press A or ← to go LEFT \nPress D or → to go RIGHT",
		"Pressione A ou ← para ir para a ESQUERDA\nPressione D ou → para ir para a DIREITA "
	],
	"how_to_1": [
		"Move in the three lanes to dodge\nincoming obstacles, like boulders",
		"Mova-se nas três linhas para desviar\ndos obstáculos, como pedregulhos"
	],

	"how_to_2": [
		"Press W or ↑ to JUMP\nJump over logs to avoid them",
		"Pressione W ou ↑ para PULAR\nPule sobre troncos para evitá-los"
	],
	"how_to_3": [
		"Press S or ↓ to SLIDE\nSlide under giraffes to avoid them",
		"Pressione S ou ↓ para DESLIZAR\nDeslize sob girafas para evitá-las"
	],

	"how_to_4": [
		"If you lose all your health by\ncolliding with obstacles, you lose!\nLost health regenerates in 5 seconds",
		"Ao perder todas as vidas em colisões com\nobjetos, você perde o jogo! A vida\nperdida regenera-se em 5 segundos"
	],
	"how_to_5": [
		"Win the game by getting to the finish line",
		"Vença o jogo ao chegar na linha de chegada"
	],

	# "how_to_6": [
	# 	"When you win, the message at end changes\nbased on the difficulty\n\nHave fun!",
	# 	"Ao vencer o game, a mensagem final muda\nde acordo com a dificuldade\n\nDivirta-se!"
	# ],
	"how_to_6": [
		"The message at end can change based on\nthe difficulty and consecutive losses\nin the same difficulty\n\nHave fun!",
		"A mensagem final pode mudar de acordo com\na dificuldade ou derrotas consecutivas\nna mesma dificuldade\n\nDivirta-se!"
	],


	# Difficulty
	"toggle_difficulty": [ "Toggle Difficulty:", "Trocar Dificuldade:" ],
	"baby": [ "Baby",   "Bebê" ],
	"easy": [ "Easy",   "Fácil" ],
	"medi": [ "Medium", "Médio" ],
	"hard": [ "Hard",   "Difícil" ],

	"press_w": [ "(press W)", "(pressione W)" ],
	"press_s": [ "(press S)", "(pressione S)" ],


	# Win screen
	"you_won": [ "YOU WON!", "VENCEU!" ],

	"baby_win_label": [
		"Congratulations, now try doing it in a difficulty\nthat is not called \"baby mode\"",
		"Parabéns, agora tente vencer o jogo\nem uma dificuldade que não\nse chama \"modo bebê\""
	],
	"baby_win_ans": [ "Ok...", "Ok..." ],

	"easy_win_label": [
		"Easy peasy lemon squeezy?\nCongratulations, now try beating the game\non a real difficulty",
		"Facinho facinho?\nParabéns, agora tente vencer o game\nem uma dificuldade de verdade"
	],
	"easy_win_ans": [ "Will do", "Farei" ],

	"medi_win_label": [
		"Did you know \"medium\" is a word for \"mediocre\"?\nTry doing it on the hard difficulty\n(if you think you're good enough)",
		"Você sabia que \"médio\" é sinônimo de \"medíocre\"?\nTente vencer no difícil\n(se você acha que é bom o bastante)"
	],
	"medi_win_ans": [ "I am", "Eu sou" ],

	"hard_win_label": [
		"You just beat the game on hard\nbut unfortunately for you,\nyou did nothing more than your obligation!",
		"Você acabou de vencer o game no difícil\nmas, infelizmente para você,\nnão fez mais que sua obrigação!"
	],
	"hard_win_ans": [ "I know", "Eu sei" ],


	# Lose screen
	"you_lost": [ "YOU LOST!", "VOCÊ PERDEU!"],
	# "try_again": [ "Try again?", "Tentar novamente?"],
	"retry": [ "Continue", "Continuar"],
}



var lost_easy_texts = [
	[ "Check the \"How to play\" section\nin the main menu",
	  "Confira a seção \"Como Jogar?\" no menu principal!" ],
	[ "Trying leads to failure, but\nfailure leads to knowledge!\nKeep going!",
	  "A tentativa leva à falha, porém\na falha leva ao conhecimento!\nContinue tentando!" ],
	[ "C'mon, you can do it!",
	  "Vamos lá, você consegue!" ],
	[ "You almost did it this time!",
	  "Quase conseguiu dessa vez!" ],
	[ "Push harder than yesterday if you\nwant a different tomorrow!",
	  "Faça melhor que ontem se você\nquiser um amanhã diferente!" ],
	[ "Don't let your dreams be dreams\nJust do it!",
	  "Não deixe seus sonhos serem só sonhos\nApenas faça!" ],
	[ "One must imagine Sysyphus happy",
	  "É preciso imaginar Sísifo feliz" ],
	[ "If you fall again, I'll be there for you!\n(said the floor)",
	  "Se você cair, eu estarei lá por você\n(disse o chão)" ],
	[ "If you keep following your dreams like this\nthey might go file a restraining order!",
	  "Se você continuar perseguindo seus sonhos assim\neles irão atrás de uma medida protetiva!" ],
	[ "I've got nothing more to say\nBut you're doing great!\nKeep going!",
	  "Não tenho mais nada a dizer\nMas você está indo bem!\nContinue tentando!" ],
]

var lost_medi_texts = [
	[ "Can you really do it on medium? The frame time\nscale gets sped up by 20% or something",
	  "Você consegue mesmo fazer no médio? A escala de tempo\ndas frames é acelerada em uns 20% ou algo assim" ],
	[ "Maybe try the easy difficulty\nif you can't do it on medium...",
	  "Talvez tente na dificuldade fácil\nse você não consegue no médio!" ],
	[ "If you keep going, you will eventually\nmake it! ... Or will you?",
	  "Se você continuar tentando, eventualmente consegue!\n ... Ou será que consegue?" ],
	[ "Work hard, you will do it eventually\nIf you don't give up before it, that is",
	  "Trabalhe duro, talvez você consiga,\nisso se não desistir antes né" ],
	[ "C'mon, you're not so bad, you almost made it!\n... probably",
	  "Vamos lá você não é tão ruim, quase conseguiu!\n... provavelmente" ],
	[ "If you keep failing like this, I might\nsing a song to motivate you",
	  "Se você continuar tentando, talvez eu cante\numa música para motivar você" ],
	[ "♪♪ Quantas vezes ... como agora\nA reunião ... se estendeu\nAté que ... chegou a aurora\nE ... nos surpreendeu ♪♪",
	  "♪♪ Quantas vezes ... como agora\nA reunião ... se estendeu\nAté que ... chegou a aurora\nE ... nos surpreendeu ♪♪" ],
	[ "♪♪ As estrelas ... testemunham\nNosso amor ... e semelhança\nBoa noite ... meus amigos\nBoa noite ... vizinhança ♪♪",
	  "♪♪ As estrelas ... testemunham\nNosso amor ... e semelhança\nBoa noite ... meus amigos\nBoa noite ... vizinhança ♪♪" ],
	[ "Maybe try again later,\ngo get a drink first, or something",
	  "Talvez tente novamente mais tarde,\nvá pegar uma bebida antes, ou algo assim" ],
	[ "Well, if most of my dumb ass friends managed\nto do it on medium difficulty, maybe you have a shot",
	  "Bom, se a maioria dos meus amigos tontos conseguiu\n vencer no médio, talvez você tenha uma chance" ],
	[ "A couple of my friends even managed to beat it on hard\nBut if medium is too much for you...",
	  "Alguns amigos meus até conseguiram vencer no difícil,\nmas se o médio é de mais pra você..." ],
	[ "Looks like you're not having an excellent time\nMaybe don't try the hard difficulty after this, lol",
	  "Parece que você não está tendo o melhor dos seus dias,\ntalvez não tente o difícil não, lol" ],
	[ "Oh, you're still trying after 13 fails in a row?\nI'll just count and let you concentrate from now on",
	  "Oh, ainda tentando após 13 derrotas consecutivas?\nAgora só irei contar quantas foram,\ndeixarei você se concentrar" ],
	[ "%s fails in a row on medium, keep going tho!\nDon't let me hold you back!",
	  "%s derrotas consecutivas no médio, mas continue\ntentando, não me deixe te atrapalhar!" ],
]

var lost_medi_answers = [
	[ "I Can",
	  "Consigo" ],
	[ "Nah Im good",
	  "Nah to bem" ],
	[ "Will do",
	  "Conseguirei" ],
	[ "Let's go",
	  "Vamos lá" ],
	[ "Not so bad?",
	  "Tão ruim?" ],
	[ "Let's hear",
	  "Vamos ouvir" ],
	[ "♪ ♪ ♪",
	  "♪ ♪ ♪" ],
	[ "El Chavo..",
	  "Chaves..." ],
	[ "Something?",
	  "Algo assim?" ],
	[ "I Do!",
	  "Eu Tenho!" ],
	[ "Is it?",
	  "É??" ],
	[ ":(",
	  ":(" ],
	[ "Please do",
	  "Por favor" ],
	[ "Try again",
	  "Continuar" ],
]

var lost_hard_texts = [
	[ "Lol you can't do it on hard",
	  "Lol tu não consegue no difícil" ],
	[ "Are you really going to try it?\nGive up",
	  "Vai realmente tentar no difícil?\nDesiste logo" ],
	[ "Don't worry if you can't do it on hard\nThere's always babymode for you!",
	  "Não se preocupe por não conseguir fazer no difícil\nHá sempre um \"Modo bebê\" pra essas horas!" ],
	[ "Just so you know, the developer\nmanaged to beat this on second try",
	  "Antes que pergunte, o desenvolvedor conseguiu\nvencer no difícil na segunda tentativa" ],
	[ "If you keep trying you might end up\ngetting bitten by a space snake",
	  "Se você continuar tentando, talvez você acabe\nsendo mordido por uma cobra do espaço" ],
	[ "C'mon, this is getting tiresome\nI'll count the times you failed\nJust for fun, let's start: 6",
	  "Isso está me cansando, vou contar as vezes\nconsecutivas que você falhou no difícil\nVai ser divertido, vamos lá: 6" ],
	[ "You failed to do it seven times in a row\nSeven is my favorite number!",
	  "Você falhou sete vezes consecutivas,\nsete é meu número preferido!" ],
	[ "You failed to do it eight times in a row\nEight is the amount of bits in a byte!",
	  "Você falhou oito vezes consecutivas,\noito é o número de bits em um byte!" ],
	[ "You failed to do it nine times in a row\nThat's the amount of planets in the solar system!",
	  "Você falhou nove vezes consecutivas,\nessa é a quantidade de planetas no sistema solar!" ],
	[ "You failed to do it ten times in a row\nThat's the amount of hands in your fingers\n(no... wait!)",
	  "Você falhou dez vezes consecutivas,\nessa é a quantidade de mãos nos seus dedos\n(não... pera)" ],
	[ "You failed to do it eleven times in a row\nThat's more than the amount\nof fucks I give lol",
	  "Você falhou ONZE vezes consecutivas,\nessa é uma quantidade maior que as vezes\nque eu dei a mínima pra você hoje" ],
	[ "You failed to do it a dozen times in a row\nThat's the amount of eggs in a dozen eggs",
	  "Você falhou uma dúzia de vezes consecutivas,\nessa é a quantidade de ovos em uma dúzia de ovos" ],
	[ "Just failed 13 times in a row\nPapyrus is very sad with you",
	  "Acabou de falhar treze vezes consecutivas,\nPapyrus está muito triste com você" ],
	[ "Ok, I'll just count from now on\nHere we go: 14 fails in a row",
	  "Ok, vou só contar daqui pra frente\nVamos lá: 14 derrotas consecutivas" ],
	[ "%s fails in a row...\nStill waiting for you to give up :)",
	  "%s derrotas consecutivas...\nAinda estou esperando você desistir :)" ],
]

var lost_hard_answers = [
	[ "I Can",
	  "Consigo" ],
	[ "Will not",
	  "Eu não" ],
	[ "Thx lol",
	  "Valeu kk" ],
	[ "He good",
	  "Ele é bom" ],
	[ "Ok Morty",
	  "Ok Morty" ],
	[ "Oh God",
	  "Oh Deus" ],
	[ "Really?",
	  "Sério?" ],
	[ "Nerd",
	  "Nerdola" ],
	[ "Pluto?",
	  "Plutão?" ],
	[ "Drunk",
	  "Bêbado" ],
	[ "Spare me",
	  "Poupe-me" ],
	[ "Omelette",
	  "Omelete" ],
	[ "Nyeh heheh",
	  "Nyeh heheh" ],
	[ "Already?",
	  "Mas já?" ],
	[ "Will not",
	  "Não irei" ],
]


