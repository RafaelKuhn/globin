extends Node

const Global = preload("res://game/global.gd")

const Difficulty = preload("res://difficulty/difficulty_enum.gd")

const game_scene = preload("res://game/Game.tscn")

const win_scene  = preload("res://menus/win-lose/Won.tscn")
const lost_scene = preload("res://menus/win-lose/Lost.tscn")

const difficulty_scene = preload("res://difficulty/Difficulty.tscn")

#const how_to_scene = preload("res://how-to-play/HowToPlay.tscn")
#const menu_scene = preload("res://MainMenu.tscn")
#const difficulty_scene = preload("res://difficulty/Difficulty.tscn")



# UNUSED
const GAME_INSTANCE_NAME = "GAME_INSTANCE"
const WIN_INSTANCE_NAME  = "WIN_INSTANCE"
const LOST_INSTANCE_NAME = "LOST_INSTANCE"


var game_speed := Global.EASY_GAME_SPEED
var game_difficulty = Difficulty.EASY


var root = null;
var current_scene = null

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func lose_game():
	load_lost_scene()

func win_game():
	load_won_scene()


func open_menu_scene():
	var scene = ResourceLoader.load("res://MainMenu.tscn")
	call_deferred("_deferred_goto_scene", scene)

func open_how_to_scene():
	var scene = ResourceLoader.load("res://how-to-play/HowToPlay.tscn")
	call_deferred("_deferred_goto_scene", scene)

func load_difficulty_scene():
	call_deferred("_deferred_goto_scene", difficulty_scene)

func load_game_scene():
	call_deferred("_deferred_goto_scene", game_scene)

func load_won_scene():
	var win_scene_instance = win_scene.instance()
	win_scene_instance.setup_won_scene(game_difficulty)
	call_deferred("_deferred_goto_scene_instance", win_scene_instance)

	#var root = get_tree().get_root()
	#var bug = root.has_node(WIN_INSTANCE_NAME)
	#if bug:
	#	push_error("ERROR, ALREADY HAD A WON SCENE THERE")
	#	return;

	# var win_instance = win_scene.instance()
	# win_instance.name = WIN_INSTANCE_NAME

	#var game = root.get_node(GAME_INSTANCE_NAME)
	#game.queue_free()
	#root.add_child(win_instance)
	
	#current_scene = win_instance
	
	#print("\nafter load WON SCENE:")
	#Global.dump_tree(get_tree().get_root(), 2)

func load_lost_scene():
	var lost_scene_instance = lost_scene.instance()
	lost_scene_instance.setup_lost_scene(game_difficulty)
	call_deferred("_deferred_goto_scene_instance", lost_scene_instance)
	return
	
	#var lost_instance = lost_scene.instance()
	# lost_instance.name = LOST_INSTANCE_NAME
	#var root = get_tree().get_root()
	#var game = root.get_node(GAME_INSTANCE_NAME)
	#game.queue_free()
	#root.add_child(lost_instance)


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
