extends Control

const Global = preload("res://game/global.gd")
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
	$MenuScaler/Difficulty.add_color_override("font_color", Game.cyan)
	$MenuScaler/Mode.add_color_override("font_color", Game.cyan)
	$MenuScaler/Mode.text = Translator.get_term("baby")
	$MenuScaler/YouWonLabel.text = Translator.get_term("baby_win_label")
	$MenuScaler/GoBack/Label.text = Translator.get_term("baby_win_ans")

func _setup_won_easy_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Game.white)
	$MenuScaler/Mode.add_color_override("font_color", Game.white)
	$MenuScaler/Mode.text = Translator.get_term("easy")
	$MenuScaler/YouWonLabel.text = Translator.get_term("easy_win_label")
	$MenuScaler/GoBack/Label.text = Translator.get_term("easy_win_ans")

func _setup_won_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Game.orange)
	$MenuScaler/Mode.add_color_override("font_color", Game.orange)
	$MenuScaler/Mode.text = Translator.get_term("medi")
	$MenuScaler/YouWonLabel.text = Translator.get_term("medi_win_label")
	$MenuScaler/GoBack/Label.text = Translator.get_term("medi_win_ans")

func _setup_won_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", Game.red)
	$MenuScaler/Mode.add_color_override("font_color", Game.red)
	$MenuScaler/Mode.text = Translator.get_term("hard")
	$MenuScaler/YouWonLabel.text = Translator.get_term("hard_win_label")
	$MenuScaler/GoBack/Label.text = Translator.get_term("hard_win_ans")




