extends Node

const game_scene = preload("res://Game.tscn")
const menu_scene = preload("res://Menu.tscn")

const GAME_INSTANCE_NAME = "GAME_INSTANCE"
const MENU_INSTANCE_NAME = "MENU_INSTANCE"

func load_game_scene(): # TODO [prod]: menu limpa a si mesmo, o game não (ver)
	var game_instance = game_scene.instance()
	game_instance.name = GAME_INSTANCE_NAME
	get_tree().get_root().add_child(game_instance)

func load_menu_scene():
	var menu_instance = menu_scene.instance()
	menu_instance.name = MENU_INSTANCE_NAME
	var root = get_tree().get_root()
	root.remove_child(root.get_node(GAME_INSTANCE_NAME))
	root.add_child(menu_instance)

func lose_game():
	load_menu_scene()

func win_game():
	print("bom")
