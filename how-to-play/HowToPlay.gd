extends Control

var game_node: Node


func _ready():
	game_node = get_node("/root/Game")

func _on_back_pressed():
	game_node.open_menu_scene()
