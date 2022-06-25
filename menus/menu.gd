extends Node

const Global = preload("res://global.gd")

func _on_PlayButton_pressed():
	get_node(Global.ROOT_GAME_PATH).load_game_scene();
	queue_free()
	
