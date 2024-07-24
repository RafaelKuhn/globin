extends Control

#const Global = preload("res://game/global.gd")
const Difficulty = preload("res://difficulty/difficulty_enum.gd")


var game_node: Node

func _ready():
	game_node = get_node("/root/Game")

func _input(_evt):
	if Input.is_action_just_pressed("ui_accept"):
		_on_ok_click()

func _on_ok_click():
	game_node.load_difficulty_scene()	
	# print("\n\nok")
	# Global.dump_tree(get_tree().get_root(), 2)

#func _on_lost_ok_click():
#	print("\n\nLOST OK")
#	Global.dump_tree(get_tree().get_root(), 2)


func setup_won_scene(difficulty):
	# print("test %s" % Difficulty.debug(difficulty))
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
			push_error("UNHANDLED ENUM CASE: %s" % game_node.game_difficulty)

	$MenuScaler/YouWonLabel.text = "Try again?"
	$MenuScaler/GoBack/Label.text = "Retry"

func setup_lost_scene(difficulty):
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
			push_error("UNHANDLED ENUM CASE: %s" % game_node.game_difficulty)

	$MenuScaler/YouWonLabel.text = "Try again?"
	$MenuScaler/GoBack/Label.text = "Retry"


var cyan   = Color(0.000, 0.973, 1.000, 1.000)
var white  = Color(1.000, 1.000, 1.000, 1.000)
var orange = Color(1.000, 0.702, 0.000, 1.000)
var red    = Color(1.000, 0.165, 0.000, 1.000)



func _setup_won_baby_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", cyan)
	$MenuScaler/Mode.add_color_override("font_color", cyan)
	$MenuScaler/Mode.text = "Baby"
	# $MenuScaler/YouWonLabel.text = "Try again?"
	# $MenuScaler/GoBack/Label.text = "Retry"

func _setup_won_easy_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", white)
	$MenuScaler/Mode.add_color_override("font_color", white)
	$MenuScaler/Mode.text = "Easy"

func _setup_won_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", orange)
	$MenuScaler/Mode.add_color_override("font_color", orange)
	$MenuScaler/Mode.text = "Medium"

func _setup_won_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", red)
	$MenuScaler/Mode.add_color_override("font_color", red)
	$MenuScaler/Mode.text = "Hard"


func _setup_lost_baby_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", cyan)
	$MenuScaler/Mode.add_color_override("font_color", cyan)
	$MenuScaler/Mode.text = "Baby"
	# $MenuScaler/YouWonLabel.text = "Try again?"
	# $MenuScaler/GoBack/Label.text = "Retry"

func _setup_lost_easy_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", white)
	$MenuScaler/Mode.add_color_override("font_color", white)
	$MenuScaler/Mode.text = "Easy"

func _setup_lost_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", orange)
	$MenuScaler/Mode.add_color_override("font_color", orange)
	$MenuScaler/Mode.text = "Medium"

func _setup_lost_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", red)
	$MenuScaler/Mode.add_color_override("font_color", red)
	$MenuScaler/Mode.text = "Hard"
