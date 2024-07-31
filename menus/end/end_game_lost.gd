extends Control


const Difficulty = preload("res://difficulty/difficulty_enum.gd")


func _input(_evt):
	if Input.is_action_just_pressed("ui_accept"):
		_on_lost_ok_click()

func _on_lost_ok_click():
	Game.load_difficulty_scene()


func setup_lost_scene(difficulty, times_lost_in_row):
	match difficulty:
		Difficulty.BABY:
			_setup_lost_baby_ui()
		Difficulty.EASY:
			_setup_lost_easy_ui()
		Difficulty.MEDI:
			_setup_lost_medi_ui()
		Difficulty.HARD:
			_setup_lost_hard_ui()
		_:
			push_error("UNHANDLED ENUM CASE: %s" % Game.game_difficulty)


func _setup_lost_baby_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.CYAN)
	$MenuScaler/Mode.add_color_override("font_color", Global.CYAN)
	Translator.bind_label($MenuScaler/Mode, "baby")
	Translator.bind_label($MenuScaler/YouWonLabel, "try_again")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")

func _setup_lost_easy_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.WHITE)
	$MenuScaler/Mode.add_color_override("font_color", Global.WHITE)
	Translator.bind_label($MenuScaler/Mode, "easy")
	Translator.bind_label($MenuScaler/YouWonLabel, "try_again")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")

func _setup_lost_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.ORANGE)
	$MenuScaler/Mode.add_color_override("font_color", Global.ORANGE)
	Translator.bind_label($MenuScaler/Mode, "medi")
	Translator.bind_label($MenuScaler/YouWonLabel, "try_again")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")

func _setup_lost_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Global.RED)
	$MenuScaler/Mode.add_color_override("font_color", Global.RED)
	Translator.bind_label($MenuScaler/Mode, "hard")
	Translator.bind_label($MenuScaler/YouWonLabel, "try_again")
	Translator.bind_label($MenuScaler/GoBack/Label, "retry")
