extends Control


onready var tips = $MenuScaler/Tips

var visible_child_i := 0


func _ready():
	_show_only_visible_tip()

func _input(_delta):
	if Input.is_action_just_pressed("back_key"):
		_on_back_pressed()
	if Input.is_action_just_pressed("D_key"):
		_on_next_tip()
	if Input.is_action_just_pressed("A_key"):
		_on_prev_tip()


func _on_back_pressed():
	Game.open_menu_scene()


func _on_next_tip():
	var last_child_i = tips.get_child_count() - 1;
	if visible_child_i == last_child_i:
		return
	visible_child_i += 1
	_show_only_visible_tip()

func _on_prev_tip():
	if visible_child_i <= 0:
		return
	visible_child_i -= 1
	_show_only_visible_tip()


func _show_only_visible_tip():
	var children = tips.get_children()
	for ch in children:
		ch.visible = false
	children[visible_child_i].visible = true
