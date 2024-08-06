extends Node


const Language = preload("res://language/scripts/language_enum.gd")

var language := Language.EN
signal language_changed


func _ready():
	_initialize_end_game_terms()

	if OS.is_debug_build():
		# TODO: sanity, check if all terms have "language.count" items
		pass

	_try_updating_language_from_get_lang_params()


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

func bind_label_dyn(label: Label, term_key, dynamic_variable):
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
	label.text = term % dynamic_variable
	var __ = connect("language_changed", refresher, "refresh_label_dyn", [ term_key, dynamic_variable ])


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

func _try_updating_language_from_get_lang_params():
	var url_lang = JavaScript.eval("new URL(window.location.href).searchParams.get('lang')")
	if url_lang == null:
		return

	url_lang = url_lang.to_lower()
	# print("LANG : '%s'" % url_lang)

	if url_lang == "en":
		change_language(Language.EN)
	elif url_lang == "br" || url_lang == "pt" || url_lang == "pt-br":
		change_language(Language.BR)
	else:
		print("unknown language: '%s' try 'en' or 'br'" % url_lang)


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
	"press_b": [ "(press ESC)", "(pressione ESC)" ],
	"playzao": [ "PLAY", "JOGAR" ],
	"press_space": [ "(press SPACE or ENTER)", "(pressione SPACE ou ENTER)" ],
	"difficulty": [ "Difficulty:", "Dificuldade:" ],
	"unsupported_mobile": [ "Unsupported\non\nmobile\nbrowsers!", "Indisponível\nem\nnavegadores\nmobile!" ],
	"ignore": [ "Ignore", "Ignorar" ],


	# Menu
	"play": [ "Play", "Jogar" ],
	"how_to": [ "How To Play", "Como Jogar?" ],
	"the_demo": [ "- The Demo -", "- A Demo -" ],
	"game_by": [ "Game By:", "Jogo:" ],
	"art_by":  [ "Art By:", "Arte:" ],
	"made_in": [ "Made In:", "Feito Em:" ],

	"press_h": [ "(press H)", "(pressione H)" ],
	"press_l": [ "(press L)", "(pressione L)" ],
	"press_1": [ "(press 1)", "(pressione 1)" ],
	"press_2": [ "(press 2)", "(pressione 2)" ],
	"press_3": [ "(press 3)", "(pressione 3)" ],


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

	"press_w": [ "(press W or ↑)", "(pressione W ou ↑)" ],
	"press_s": [ "(press S or ↓)", "(pressione S ou ↓)" ],


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

	"hard_win_label_lost_hp": [
		"You just beat the game on hard, but you have\nlost '%s' HP in the process, so I'll say you\ndid less than your obligation!",
		"Você venceu o game no difícil, mas perdeu '%s' vidas\nno processo, então eu diria que você fez\nmenos que sua obrigação!"
	],
	"hard_win_label_lost_1_hp": [
		"You just beat the game on hard, but you have\nlost '%s' HP in the process, so I'll say you\ndid nothing more than your obligation!",
		"Você venceu o game no difícil, mas perdeu '%s' vida\nno processo, então eu diria que você não\nfez mais que sua obrigação!"
	],
	"hard_win_ans_lost_hp": [ "I know", "Eu sei" ],
	"hard_win_label": [
		"How does it feel to be the king of the world?",
		"Parabéns, tu és oficialmente o bichão!"
	],
	"hard_win_ans": [ "Good", "Obrigado!" ],


	# Lose screen
	"you_lost": [ "YOU LOST!", "VOCÊ PERDEU!"],
	# "try_again": [ "Try again?", "Tentar novamente?"],
	"retry": [ "Continue", "Continuar"],
}



var lost_easy_texts = [
	# 0
	[ "Check the \"How to play\" section\nin the main menu",
	  "Confira a seção \"Como Jogar?\" no menu principal!" ],
	# 1
	[ "Trying leads to failure, but\nfailure leads to knowledge!\nKeep going!",
	  "A tentativa leva à falha, mas\na falha leva ao conhecimento!\nContinue tentando!" ],
	# 2
	[ "C'mon, you can do it!",
	  "Vamos lá, você consegue!" ],
	# 3
	[ "You almost did it this time!",
	  "Quase conseguiu dessa vez!" ],
	# 4
	[ "Push harder than yesterday if you\nwant a different tomorrow!",
	  "Faça melhor que ontem se você\nquiser um amanhã diferente!" ],
	# 5
	[ "Don't let your dreams be dreams\nJust do it!",
	  "Não deixe seus sonhos serem só sonhos\nApenas faça!" ],
	# 6
	[ "One must imagine Sysyphus happy",
	  "É preciso imaginar Sísifo feliz" ],
	# 7
	[ "If you fall again, I'll be there for you!\n(said the floor)",
	  "Se você cair, eu estarei lá por você\n(disse o chão)" ],
	# 8
	[ "If you keep following your dreams like this\nthey might go file a restraining order!",
	  "Se você continuar perseguindo seus sonhos assim\neles irão atrás de uma medida protetiva!" ],
	# 9
	[ "I've got nothing more to say\nBut you're doing great!\nKeep going!",
	  "Não tenho mais nada a dizer\nMas você está indo bem!\nContinue tentando!" ],
]

var lost_medi_texts = [
	# 0
	[ "Can you really do it on medium? The frame time\nscale gets sped up by 20% or something",
	  "Você consegue mesmo fazer no médio? A escala de tempo\ndas frames é acelerada em uns 20% ou algo assim" ],
	# 1
	[ "Maybe try the easy difficulty\nif you can't do it on medium...",
	  "Talvez tente na dificuldade fácil\nse você não consegue no médio!" ],
	# 2
	[ "If you keep going, you will eventually\nmake it! ... Or will you?",
	  "Se você continuar tentando, eventualmente consegue!\n ... Ou será que consegue?" ],
	# 3
	[ "Work hard, you will do it eventually\nIf you don't give up beforehand",
	  "Trabalhe duro, talvez você consiga,\nisso se não desistir antes, né" ],
	# 4
	[ "C'mon, you're not so bad, you almost made it!\n... probably",
	  "Vamos lá, você não é tão ruim, quase conseguiu!\n... provavelmente" ],
	# 5
	[ "If you keep failing like this, I might\nsing a song to motivate you",
	  "Se você continuar tentando, talvez eu cante\numa música para motivar você" ],
	# 6
	[ "♪♪ Quantas vezes ... como agora\nA reunião ... se estendeu\nAté que ... chegou a aurora\nE ... nos surpreendeu ♪♪",
	  "♪♪ Quantas vezes ... como agora\nA reunião ... se estendeu\nAté que ... chegou a aurora\nE ... nos surpreendeu ♪♪" ],
	# 7
	[ "♪♪ As estrelas ... testemunham\nNosso amor ... e semelhança\nBoa noite ... meus amigos\nBoa noite ... vizinhança ♪♪",
	  "♪♪ As estrelas ... testemunham\nNosso amor ... e semelhança\nBoa noite ... meus amigos\nBoa noite ... vizinhança ♪♪" ],
	# 8
	[ "Maybe try again later,\ngo get a drink first, or something",
	  "Talvez tente novamente mais tarde,\nvá pegar uma bebida antes, ou algo assim" ],
	# 9
	[ "Well, if most of my dumb ass friends managed\nto do it on medium difficulty, maybe you have a shot",
	  "Bom, se a maioria dos meus amigos tontos conseguiu\n vencer no médio, talvez você tenha uma chance" ],
	# 10
	[ "A couple of my friends even managed to beat it on hard\nBut if medium is too much for you...",
	  "Alguns amigos meus até conseguiram vencer no difícil,\nmas se o médio é de mais pra você..." ],
	# 11
	[ "Looks like you're not having an excellent time\nMaybe don't try the hard difficulty after this, lol",
	  "Parece que você não está tendo o melhor dos seus dias,\ntalvez não tente o difícil não, lol" ],
	# 12
	[ "Oh, you're still trying after 13 failures in a row?\nI'll just count and let you concentrate from now on",
	  "Oh, ainda tentando após 13 derrotas consecutivas?\nVou só contar quantas foram e deixar você se concentrar!" ],
	# 13
	[ "%s failures in a row on medium, keep going tho!\nDon't let me hold you back!",
	  "%s derrotas consecutivas no médio, mas continue\ntentando, não me deixe te atrapalhar!" ],
]

var lost_medi_answers = [
	# 0
	[ "I Can",
	  "Consigo" ],
	# 1
	[ "Nah Im good",
	  "Nah to bem" ],
	# 2
	[ "Will do",
	  "Conseguirei" ],
	# 3
	[ "Let's go",
	  "Vamos lá" ],
	# 4
	[ "Not so bad?",
	  "Tão ruim?" ],
	# 5
	[ "Let's hear",
	  "Ouvirei" ],
	# 6
	[ "♪ ♪ ♪",
	  "♪ ♪ ♪" ],
	# 7
	[ "El Chavo..",
	  "Chaves..." ],
	# 8
	[ "Something?",
	  "Algo assim?" ],
	# 9
	[ "I Do!",
	  "Eu Tenho!" ],
	# 10
	[ "Is it?",
	  "É??" ],
	# 11
	[ ":(",
	  ":(" ],
	# 12
	[ "Please do",
	  "Por favor" ],
	# 13
	[ "Try again",
	  "Continuar" ],
]

var lost_hard_texts = [
	# 0
	[ "Lol you can't do it on hard",
	  "Lol tu não consegue no difícil" ],
	# 1
	[ "Are you really going to try it?\nHa ha give up",
	  "Vai realmente tentar no difícil?\nHa ha desiste logo" ],
	# 2
	[ "Don't worry if you can't do it on hard\nThere's always \"babymode\" for you!",
	  "Não se preocupe por não conseguir fazer no difícil\nHá sempre um \"modo bebê\" pra essas horas!" ],
	# 3
	[ "Just so you know, the developer managed\nto beat this on second try",
	  "Antes que pergunte, o desenvolvedor conseguiu\nvencer no difícil na segunda tentativa" ],
	# 4
	[ "If you keep trying you might end up\ngetting bitten by a space snake",
	  "Se você continuar tentando, talvez você acabe\nsendo mordido por uma cobra do espaço" ],
	# 5
	[ "Six failures in a row! I think someone is\nnot as good as they thought they were",
	  "Seis derrotas consecutivas e subindo! Acho que alguém\nnão é tão bom assim quanto achava que era!" ],
	# 6
	[ "You failed to do it seven times in a row,\nSe7en is my favorite number!",
	  "Você falhou sete vezes consecutivas,\nsete é meu número preferido!" ],
	# 7
	[ "You failed to do it eight times in a row,\neight is the amount of bits in a byte!",
	  "Você falhou oito vezes consecutivas,\noito é o número de bits em um byte!" ],
	# 8
	[ "You failed to do it nine times in a row, that's\nthe amount of planets in the solar system!",
	  "Você falhou nove vezes consecutivas, essa é a\nquantidade de planetas no sistema solar!" ],
	# 9
	[ "You failed to do it ten times in a row,\nthere are only 10 types of people in the world, those\nwho understand binary and those who don't!",
	  "Você falhou dez vezes consecutivas,\nhá apenas 10 tipos de pessoas no mundo, as que\nentendem binário e as que não entendem" ],
	# 10
	[ "You failed to do it eleven times in a row,\nthat's more than the amount\nof fucks I give lol",
	  "Você falhou ONZE vezes consecutivas, essa é uma\nquantidade maior que as vezes que\neu dei a mínima pra você hoje" ],
	# 11
	[ "You failed to do it a dozen times in a row, that's\n the amount of eggs in a dozen eggs",
	  "Você falhou uma dúzia de vezes consecutivas, essa é\na quantidade de ovos em uma dúzia de ovos" ],
	# 12
	[ "Just failed 13 times in a row\nPapyrus is very sad with you",
	  "Acabou de falhar treze vezes consecutivas,\nPapyrus está muito triste com você" ],
	# 13
	[ "Ok, I'll just count from now on\nHere we go: 14 failures in a row\nCongratulations!",
	  "Ok, vou só contar daqui pra frente\nVamos lá: 14 derrotas consecutivas\nMeus parabéns!" ],
	# 14
	[ "%s failures in a row...\nStill waiting for you to give up :)",
	  "%s derrotas consecutivas...\nAinda estou esperando você desistir :)" ],
]
#  79 #
var lost_hard_answers = [
	# 0
	[ "I Can",
	  "Consigo" ],
	# 1
	[ "Will not",
	  "Eu não" ],
	# 2
	[ "Thx lol",
	  "Valeu kk" ],
	# 3
	[ "He good",
	  "Ele é bom" ],
	# 4
	[ "Ok Morty",
	  "Ok Morty" ],
	# 5
	[ "Oh God",
	  "Oh Deus" ],
	# 6
	[ "Really?",
	  "Sério?" ],
	# 7
	[ "Nerd",
	  "Nerdola" ],
	# 8
	[ "Pluto?",
	  "Plutão?" ],
	# 9
	[ "59 45 53",
	  "53 49 4D" ],
	# 10
	[ "Spare me",
	  "Poupe-me" ],
	# 11
	[ "Omelette",
	  "Omelete" ],
	# 12
	[ "Nyeh heheh",
	  "Nyeh heheh" ],
	# 13
	[ "Already?",
	  "Mas já?" ],
	# 14
	[ "Will not",
	  "Não irei" ],
]


