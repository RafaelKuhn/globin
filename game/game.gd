extends Node


const Difficulty = preload("res://difficulty/difficulty_enum.gd")

const game_scene = preload("res://game/Game.tscn")

const win_scene  = preload("res://menus/end/Won.tscn")
const lost_scene = preload("res://menus/end/Lost.tscn")

const difficulty_scene = preload("res://difficulty/Difficulty.tscn")

const menu_scene = preload("res://MainMenu.tscn")
#const how_to_scene = preload("res://how-to-play/HowToPlay.tscn")
#const difficulty_scene = preload("res://difficulty/Difficulty.tscn")


# var times_lost = {
# 	Difficulty.BABY: 0,
# 	Difficulty.EASY: 0,
# 	Difficulty.MEDI: 0,
# 	Difficulty.HARD: 0,
# }

# var times_won = {
# 	Difficulty.BABY: 0,
# 	Difficulty.EASY: 0,
# 	Difficulty.MEDI: 0,
# 	Difficulty.HARD: 0,
# }


var game_speed = Global.EASY_GAME_SPEED
var game_difficulty = Difficulty.EASY


var times_lost_in_same_diff_in_a_row := 0
var last_lost_difficulty = null


var root = null;
var current_scene = null

func _ready():
	OS.set_window_maximized(true)
	if OS.is_debug_build():
		OS.set_window_maximized(false)
		OS.window_position.x = 700
		OS.window_position.y = 170
		OS.window_size.x = 1920 - OS.window_position.x - 20
		OS.window_size.y = 1080 - OS.window_position.y - 80

	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func lose_game():
	var same_difficulty = last_lost_difficulty == game_difficulty
	if same_difficulty:
		times_lost_in_same_diff_in_a_row += 1
	else:
		times_lost_in_same_diff_in_a_row = 0

	last_lost_difficulty = game_difficulty
	print("lost in a new difficulty: %s, %s times in a row" % [ !same_difficulty, times_lost_in_same_diff_in_a_row ])
	load_lost_scene()

func win_game():
	last_lost_difficulty = null
	times_lost_in_same_diff_in_a_row = 0
	# print("times won: %s" % times_won)
	load_won_scene()

func open_how_to_scene():
	var scene = ResourceLoader.load("res://game-parts/how-to-play/HowToPlay.tscn")
	call_deferred("_deferred_goto_scene", scene)

func open_menu_scene():
	call_deferred("_deferred_goto_scene", menu_scene)


func load_difficulty_scene():
	call_deferred("_deferred_goto_scene", difficulty_scene)

func load_game_scene():
	call_deferred("_deferred_goto_scene", game_scene)


func load_won_scene():
	var win_scene_instance = win_scene.instance()
	win_scene_instance.setup_won_scene(game_difficulty)
	call_deferred("_deferred_goto_scene_instance", win_scene_instance)

func load_lost_scene():
	var lost_scene_instance = lost_scene.instance()
	lost_scene_instance.setup_lost_scene(game_difficulty, times_lost_in_same_diff_in_a_row)
	call_deferred("_deferred_goto_scene_instance", lost_scene_instance)


func _deferred_goto_scene(new_scene):
	var instance = new_scene.instance()
	current_scene.free()
	root.add_child(instance)
	current_scene = instance

func _deferred_goto_scene_instance(new_scene_instance):	
	current_scene.free()
	root.add_child(new_scene_instance)
	current_scene = new_scene_instance


func set_baby_difficulty():
	self.game_speed = Global.BABY_GAME_SPEED
	self.game_difficulty = Difficulty.BABY

func set_easy_difficulty():
	self.game_speed = Global.EASY_GAME_SPEED
	self.game_difficulty = Difficulty.EASY

func set_medi_difficulty():
	self.game_speed = Global.MEDI_GAME_SPEED
	self.game_difficulty = Difficulty.MEDI

func set_hard_difficulty():
	self.game_speed = Global.HARD_GAME_SPEED
	self.game_difficulty = Difficulty.HARD
