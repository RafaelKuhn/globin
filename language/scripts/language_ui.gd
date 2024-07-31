extends Control

const Language = preload("res://language/scripts/language_enum.gd")

onready var other_langs = $"OtherLangs";

onready var lang_item_tex = $"LangItem/LangTex" as TextureRect;
onready var lang_item_label = $"LangItem/LangLabel";

onready var lang_item1_tex = $"OtherLangs/Lang1/LangTex" as TextureRect;
onready var lang_item1_label = $"OtherLangs/Lang1/LangLabel";


onready var press_l_label = $"PressL";


const br_data = {
	"text": "BR",
	"icon": preload("res://language/icons/flag-br.png"),
}

const en_data = {
	"text": "EN",
	"icon": preload("res://language/icons/flag-en.png"),
}



func _ready():
	# print("language init: %s " % Translator.language)

	other_langs.visible = false
	press_l_label.visible = true
	_update_icons()

var amnt_hover := 0

func _input(_delta):
	if Input.is_action_just_pressed("L_key"):
		_cycle_language()

func _process(_delta):
	if amnt_hover > 0:
		other_langs.visible = true
		press_l_label.visible = false
	else:
		other_langs.visible = false
		press_l_label.visible = true


func _update_icons():
	match Translator.language:
		Language.EN:
			lang_item_label.text = en_data.text
			lang_item_tex.texture = en_data.icon

			lang_item1_label.text = br_data.text
			lang_item1_tex.texture = br_data.icon
			
		Language.BR:
			lang_item_label.text = br_data.text
			lang_item_tex.texture = br_data.icon

			lang_item1_label.text = en_data.text
			lang_item1_tex.texture = en_data.icon

		_:
			push_error("UNHANDLED LANGUAGE")
			return -1


func _on_hover():
	# print("hover, 1")
	_increment_amnt_hover()

func _on_hover_off():
	# print("hover off, 0")
	_decrement_amnt_hover()

func _on_hover_bg():
	# print("hover BG")
	_increment_amnt_hover()

func _on_hover_bg_off():
	# print("hover BG off")
	_decrement_amnt_hover()



func _cycle_language():
	# TODO: cycle correctly
	_on_click_lang_1();

func _on_click_lang_1():
	match Translator.language:
		Language.EN:
			Translator.change_language(Language.BR)
		Language.BR:
			Translator.change_language(Language.EN)
		_:
			push_error("UNHANDLED LANGUAGE")
			return -1

	_update_icons()
	_decrement_amnt_hover()


func _increment_amnt_hover():
	amnt_hover += 1

func _decrement_amnt_hover():
	amnt_hover -= 1
	if amnt_hover <= 0:
		amnt_hover = 0
