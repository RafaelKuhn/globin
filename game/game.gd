extends Node


const Difficulty = preload("res://difficulty/difficulty_enum.gd")

const game_scene = preload("res://game/Game.tscn")

const win_scene  = preload("res://menus/win-lose/Won.tscn")
const lost_scene = preload("res://menus/win-lose/Lost.tscn")

const difficulty_scene = preload("res://difficulty/Difficulty.tscn")

#const how_to_scene = preload("res://how-to-play/HowToPlay.tscn")
const menu_scene = preload("res://MainMenu.tscn")
#const difficulty_scene = preload("res://difficulty/Difficulty.tscn")



var game_speed = Global.EASY_GAME_SPEED
var game_difficulty = Difficulty.EASY


var root = null;
var current_scene = null

func _ready():
	OS.set_window_maximized(true)
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func lose_game():
	load_lost_scene()

func win_game():
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
	lost_scene_instance.setup_lost_scene(game_difficulty)
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


var cyan   := Color(0.000, 0.973, 1.000, 1.000)
var white  := Color(1.000, 1.000, 1.000, 1.000)
var orange := Color(1.000, 0.702, 0.000, 1.000)
var red    := Color(1.000, 0.165, 0.000, 1.000)
