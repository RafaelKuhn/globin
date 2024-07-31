extends Node


func _input(_evt):
	if Input.is_action_just_pressed("ui_1"):
		_on_rafa_press()
		return
	if Input.is_action_just_pressed("ui_2"):
		_on_mari_press()
		return


func _on_rafa_press():
	var folio_url = _get_folio_url()
	var __ = OS.shell_open(folio_url)

func _on_mari_press():
	var __ = OS.shell_open("https://www.behance.net/marianabiondo1")


func _get_folio_url() -> String:
	match Translator.language:
		Language.EN:
			return "https://rafaelkuhn.com"
		Language.BR:
			return "https://rafaelkuhn.com/br"
		_:
			return "https://rafaelkuhn.com"
