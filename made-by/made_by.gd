extends Node


func _input(_evt):
	if Input.is_action_just_pressed("ui_1"):
		_on_rafa_press()
		return
	if Input.is_action_just_pressed("ui_2"):
		_on_mari_press()
		return

func _on_rafa_press():
	var __ = OS.shell_open("https://rafaelkuhn.com")

func _on_mari_press():
	var __ = OS.shell_open("https://www.behance.net/marianabiondo1")

