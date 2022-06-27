extends Node

const game_scene = preload("res://Game.tscn")

const win_scene = preload("res://menus/Won.tscn")
const lost_scene = preload("res://menus/Lost.tscn")

const GAME_INSTANCE_NAME = "GAME_INSTANCE"

const WIN_INSTANCE_NAME = "WIN_INSTANCE"
const LOST_INSTANCE_NAME = "LOST_INSTANCE"

var game_speed := 8.0


func lose_game():
	load_lost_scene()

func win_game():
	load_won_scene()

# TODO: [prod]: nunca se volta pra cena do menu
# a cena do menu limpa a si mesma, já o game não

func load_game_scene():
	var game_instance = game_scene.instance()
	game_instance.name = GAME_INSTANCE_NAME
	get_tree().get_root().add_child(game_instance)

func load_won_scene():
	var win_instance = win_scene.instance()
	win_instance.name = WIN_INSTANCE_NAME
	var root = get_tree().get_root()
	root.remove_child(root.get_node(GAME_INSTANCE_NAME))
	root.add_child(win_instance)

func load_lost_scene():
	var lost_instance = lost_scene.instance()
	lost_instance.name = LOST_INSTANCE_NAME
	var root = get_tree().get_root()
	root.remove_child(root.get_node(GAME_INSTANCE_NAME))
	root.add_child(lost_instance)
