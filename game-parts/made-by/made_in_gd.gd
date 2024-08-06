extends Control


# func _input(_evt):
# 	if Input.is_action_just_pressed("ui_3"):
# 		_on_click_godot_btn()


func _on_click_godot_btn():
	var __ = OS.shell_open("https://godotengine.org/")

func _on_hover_godot_btn():
	$GodotBtn.modulate = Global.CYAN

func _on_hover_off_godot_btn():
	$GodotBtn.modulate = Global.WHITE
