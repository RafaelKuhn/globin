extends Node

const Global = preload("res://game/global.gd")

# EXPORT EXAMPLES
# export (String) var game_dif: String
# export var player_path := @""; onready var player := get_node(player_path) as Node2D


var game_node: Node

func _ready():
	game_node = get_node("/root/Game")
	OS.set_window_maximized(true)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_PlayButton_pressed()
	if Input.is_action_just_pressed("H_Key"):
		_on_how_to_play_pressed()


func _on_PlayButton_pressed():
	game_node.load_difficulty_scene();

func _on_how_to_play_pressed():
	# get_tree().get_root().print_tree()
	game_node.open_how_to_scene()

