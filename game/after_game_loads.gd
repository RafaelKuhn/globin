extends Node


func _ready():
	_try_unsupported_scene_if_mobile_browser()


func _try_unsupported_scene_if_mobile_browser():
	# Game.open_unsupported_scene()
	# return

	var is_mobile_js = JavaScript.eval("new RegExp('Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini').test(navigator.userAgent)", true)
	if is_mobile_js:
		Game.open_unsupported_scene()
