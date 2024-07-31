extends Node


const Language = preload("res://language/language_enum.gd")

var language := Language.EN
signal language_changed


func _ready():
	if OS.is_debug_build():
		sanity()

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
	return term_list[lang_index]


func _lang_to_index(lang) -> int:
	match lang:
		Language.EN:
			return 0
		Language.BR:
			return 1
		_:
			push_error("UNHANDLED LANGUAGE %s" % lang)
			return -1


func sanity():
	# TODO: check if all terms have "language.count" items
	# print(" SANITY CHECKS: ")
	pass

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

	"how_to_6": [
		"When you win, the message at end changes\nbased on the difficulty\n\nHave fun!",
		"Ao vencer o game, a mensagem final muda\nde acordo com a dificuldade\n\nDivirta-se!"
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
		"Did you know \"medium\" is a word for \"mediocre\"?\nTry doing it in the hard difficulty\n(if you think you're good enough)",
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
	"try_again": [ "Try again?", "Tentar novamente?"],
	"retry": [ "Retry", "Tentar"],
}
