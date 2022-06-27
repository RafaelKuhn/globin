extends Node

const Global = preload("res://global.gd")

# func _ready():
# 	$"VeryEzTog".pressed = false
# 	$"EzTog".pressed = true
# 	$"MedTog".pressed = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_node(Global.GAME_MANAGER_PATH).load_game_scene();
		queue_free()


func _on_PlayButton_pressed():
	get_node(Global.GAME_MANAGER_PATH).load_game_scene();
	queue_free()


func _on_VeryEzTog_toggled(_is_pressed: bool):
	get_node("/root/Game").game_speed = 6.0

func _on_EzTog_toggled(_is_pressed: bool):
	get_node("/root/Game").game_speed = 8.0

func _on_MedTog_toggled(_is_pressed: bool):
	get_node("/root/Game").game_speed = 10.0

