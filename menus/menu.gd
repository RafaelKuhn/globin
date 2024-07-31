extends Node

const Global = preload("res://game/global.gd")

# EXPORT EXAMPLES
# export (String) var game_dif: String
# export var player_path := @""; onready var player := get_node(player_path) as Node2D


func _input(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_PlayButton_pressed()
	if Input.is_action_just_pressed("H_key"):
		_on_how_to_play_pressed()


func _on_PlayButton_pressed():
	Game.load_difficulty_scene();

func _on_how_to_play_pressed():
	# get_tree().get_root().print_tree()
	Game.open_how_to_scene()

