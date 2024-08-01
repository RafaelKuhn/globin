extends Control


const Difficulty = preload("res://difficulty/difficulty_enum.gd")
const Language = preload("res://language/scripts/language_enum.gd")


func _input(_evt):
	if Input.is_action_just_pressed("ui_accept"):
		_on_lost_ok_click()

func _on_lost_ok_click():
	Game.load_difficulty_scene()


func setup_lost_scene(difficulty, times_lost_in_row: int):
	match difficulty:
		Difficulty.BABY:
			_setup_lost_baby_ui(times_lost_in_row)
		Difficulty.EASY:
			_setup_lost_easy_ui(times_lost_in_row)
		Difficulty.MEDI:
			_setup_lost_medi_ui(times_lost_in_row)
		Difficulty.HARD:
			_setup_lost_hard_ui(times_lost_in_row)
		_:
			push_error("UNHANDLED ENUM CASE: %s" % Game.game_difficulty)

	# print("lost in row %s, lang %s br %s" % [ times_lost_in_row, Translator.language, Language.BR ])
	if times_lost_in_row == 13-1 && Translator.language == Language.BR:
		yield(self, "ready")
		$LanguageScaler/Language/PressL.text = "(faz o L)"


func _setup_lost_baby_ui(times_lost: int):
	$MenuScaler/Difficulty.add_color_override("font_color", Global.CYAN)
	$MenuScaler/Mode.add_color_override("font_color", Global.CYAN)
	Translator.bind_label($MenuScaler/Mode, "baby")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")
	_setup_lost_baby_and_easy_label_text_dynamic(times_lost)

func _setup_lost_easy_ui(times_lost: int):
	$MenuScaler/Difficulty.add_color_override("font_color", Global.GREEN)
	$MenuScaler/Mode.add_color_override("font_color", Global.GREEN)
	Translator.bind_label($MenuScaler/Mode, "easy")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")
	_setup_lost_baby_and_easy_label_text_dynamic(times_lost)

func _setup_lost_medi_ui(times_lost: int):
	$MenuScaler/Difficulty.add_color_override("font_color", Global.YELLOW)
	$MenuScaler/Mode.add_color_override("font_color", Global.YELLOW)
	Translator.bind_label($MenuScaler/Mode, "medi")
	_bind_medi_button_answers(times_lost)
	_setup_lost_medi_label_text_dynamic(times_lost)

func _setup_lost_hard_ui(times_lost: int):
	$MenuScaler/Difficulty.add_color_override("font_color", Global.ORANGE)
	$MenuScaler/Mode.add_color_override("font_color", Global.ORANGE)
	Translator.bind_label($MenuScaler/Mode, "hard")
	_setup_lost_hard_label_text_dynamic(times_lost)
	_bind_hard_button_answers(times_lost)


func _setup_lost_baby_and_easy_label_text_dynamic(times_lost: int):
	var last_i = len(Translator.lost_easy_texts) - 1
	times_lost = last_i if times_lost >= last_i else times_lost
	Translator.bind_label($MenuScaler/YouWonLabel, "easy_lost_label_%s" % times_lost)

func _setup_lost_medi_label_text_dynamic(times_lost: int):
	var arr_len = len(Translator.lost_medi_texts)
	var last_i = arr_len - 1

	var got_to_the_last_el_or_beyond = times_lost >= last_i
	if got_to_the_last_el_or_beyond:
		Translator.bind_label_dyn($MenuScaler/YouWonLabel, "medi_lost_label_%s" % last_i, times_lost + 1)
	else:
		Translator.bind_label($MenuScaler/YouWonLabel, "medi_lost_label_%s" % times_lost)

func _setup_lost_hard_label_text_dynamic(times_lost: int):
	var arr_len = len(Translator.lost_hard_texts)
	var last_i = arr_len - 1

	var got_to_the_last_el_or_beyond = times_lost >= last_i
	if got_to_the_last_el_or_beyond:
		#print("times_lost %s >= len %s BINDING" % [ times_lost, arr_len ])
		Translator.bind_label_dyn($MenuScaler/YouWonLabel, "hard_lost_label_%s" % last_i, times_lost + 1)
	else:
		Translator.bind_label($MenuScaler/YouWonLabel, "hard_lost_label_%s" % times_lost)


func _bind_hard_button_answers(times_lost: int):
	var last_i = len(Translator.lost_hard_answers) - 1
	times_lost = last_i if times_lost >= last_i else times_lost
	Translator.bind_label($MenuScaler/GoBack/Label, "hard_lost_answer_%s" % times_lost)

func _bind_medi_button_answers(times_lost: int):
	var last_i = len(Translator.lost_medi_answers) - 1
	times_lost = last_i if times_lost >= last_i else times_lost
	Translator.bind_label($MenuScaler/GoBack/Label, "medi_lost_answer_%s" % times_lost)
