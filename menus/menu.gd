extends Node

const Global = preload("res://global.gd")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_node(Global.GAME_MANAGER_PATH).load_game_scene();
		queue_free()


func _on_PlayButton_pressed():
	get_node(Global.GAME_MANAGER_PATH).load_game_scene();
	queue_free()