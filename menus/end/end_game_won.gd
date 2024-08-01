extends Control


const Difficulty = preload("res://difficulty/difficulty_enum.gd")


func _input(_evt):
	if Input.is_action_just_pressed("ui_accept"):
		_on_win_ok_click()

func _on_win_ok_click():
	Game.open_menu_scene()


func setup_won_scene(difficulty):
	match difficulty:
		Difficulty.BABY:
			_setup_won_baby_ui()
		Difficulty.EASY:
			_setup_won_easy_ui()
		Difficulty.MEDI:
			_setup_won_medi_ui()
		Difficulty.HARD:
			_setup_won_hard_ui()
		_:
			push_error("UNHANDLED ENUM CASE: %s" % Game.game_difficulty)


func _setup_won_baby_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.CYAN)
	$MenuScaler/Mode.add_color_override("font_color", Global.CYAN)
	Translator.bind_label($MenuScaler/Mode, "baby")
	Translator.bind_label($MenuScaler/YouWonLabel, "baby_win_label")
	Translator.bind_label($MenuScaler/GoBack/Label, "baby_win_ans")

func _setup_won_easy_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.GREEN)
	$MenuScaler/Mode.add_color_override("font_color", Global.GREEN)
	Translator.bind_label($MenuScaler/Mode, "easy")
	Translator.bind_label($MenuScaler/YouWonLabel, "easy_win_label")
	Translator.bind_label($MenuScaler/GoBack/Label, "easy_win_ans")

func _setup_won_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.YELLOW)
	$MenuScaler/Mode.add_color_override("font_color", Global.YELLOW)
	Translator.bind_label($MenuScaler/Mode, "medi")
	Translator.bind_label($MenuScaler/YouWonLabel, "medi_win_label")
	Translator.bind_label($MenuScaler/GoBack/Label, "medi_win_ans")

func _setup_won_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.ORANGE)
	$MenuScaler/Mode.add_color_override("font_color", Global.ORANGE)
	Translator.bind_label($MenuScaler/Mode, "hard")
	Translator.bind_label($MenuScaler/YouWonLabel, "hard_win_label")
	Translator.bind_label($MenuScaler/GoBack/Label, "hard_win_ans")




