extends Node


const Language = preload("res://language/language_enum.gd")

var language := Language.EN
signal language_changed



func _ready():
	if OS.is_debug_build():
		sanity()

	# print(" READY TRANSLATOR")


func change_language(new_lang):
	language = new_lang
	emit_signal("language_changed")




func get_term(term_key):
	var term_list = dict.get(term_key)
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
			push_error("UNHANDLED LANGUAGE")
			return -1


func sanity():
	print(" SANITY CHECKS: ")
	# TODO: check if all terms have "language.count" items

var dict := {

	# Menu
	"play": [ "Play", "Jogar" ],
	"how_to": [ "How To Play", "Como Jogar?" ],
	"game_by": [ "Game By:", "Jogo:" ],
	"art_by":  [ "Art By:", "Arte:" ],

	"press_space": [ "(press SPACE or ENTER)", "(pressione SPACE ou ENTER)" ],
	"press_h": [ "(press H)", "(pressione H)" ],
	"press_l": [ "(press L)", "(pressione L)" ],
	"press_1": [ "(press 1)", "(pressione 1)" ],
	"press_2": [ "(press 2)", "(pressione 2)" ],

	# Outro
}