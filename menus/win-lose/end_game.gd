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
	$MenuScaler/YouWonLabel.text = "Try again?"
	$MenuScaler/GoBack/Label.text = "Retry"
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

func setup_lost_scene(difficulty):
	$MenuScaler/YouWonLabel.text = "Try again?"
	$MenuScaler/GoBack/Label.text = "Retry"
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


var cyan   = Color(0.000, 0.973, 1.000, 1.000)
var white  = Color(1.000, 1.000, 1.000, 1.000)
var orange = Color(1.000, 0.702, 0.000, 1.000)
var red    = Color(1.000, 0.165, 0.000, 1.000)



func _setup_won_baby_ui():
	print("WON ON BABY")
	$MenuScaler/Difficulty.add_color_override("font_color", cyan)
	$MenuScaler/Mode.add_color_override("font_color", cyan)
	$MenuScaler/Mode.text = "Baby"
	$MenuScaler/YouWonLabel.text = "Congratulations, now try doing it in a difficulty\nthat is not called \"baby mode\""
	$MenuScaler/GoBack/Label.text = " Ok..."

func _setup_won_easy_ui():
	print("WON ON eASY")
	$MenuScaler/Difficulty.add_color_override("font_color", white)
	$MenuScaler/Mode.add_color_override("font_color", white)
	$MenuScaler/Mode.text = "Easy"
	$MenuScaler/YouWonLabel.text = "Easy peasy lemon squeezy?\nCongratulations, now try beating the game\non a real difficulty"
	$MenuScaler/GoBack/Label.text = "Will do"

func _setup_won_medi_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", orange)
	$MenuScaler/Mode.add_color_override("font_color", orange)
	$MenuScaler/Mode.text = "Medium"
	$MenuScaler/YouWonLabel.text = "Did you know \"medium\" is a word for \"mediocre\"?\nTry doing it in the hard difficulty\n(if you think you're good enough)"
	$MenuScaler/GoBack/Label.text = "I am"

func _setup_won_hard_ui():
	$MenuScaler/Difficulty.add_color_override("font_color", red)
	$MenuScaler/Mode.add_color_override("font_color", red)
	$MenuScaler/Mode.text = "Hard"
	$MenuScaler/YouWonLabel.text = "You just beat the game on hard\nbut unfortunately for you,\nyou did nothing more than your obligation!"
	$MenuScaler/GoBack/Label.text = "I know"



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
