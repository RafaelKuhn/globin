extends Control

func _ready():
	self.text = ""
	self.visible = false;

	if !OS.is_debug_build():
		return

	_test_agent()
	_test_mobile()
	_test_lang()

func _test_agent():
	var user_agent_js = JavaScript.eval("navigator.userAgent");
	if user_agent_js == null:
		self.text = "[javascript engine returned null]"
		return

	if user_agent_js:
		self.text += user_agent_js

func _test_mobile():
	var is_mobile_js = JavaScript.eval("new RegExp('Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini').test(navigator.userAgent)", true)
	if is_mobile_js:
		self.text += "\nis mobile"
	else:
		self.text += "\nis NOT mobile"

func _test_lang():
	self.text += "\n"

	var url_lang = JavaScript.eval("new URL(window.location.href).searchParams.get('lang')")
	if url_lang == null:
		self.text += "LANG ERROR JS RETURNED NULL"
		return

	self.text += url_lang
	return

	if Translator.language == Language.BR:
		self.text += "BR"
	else:
		self.text += "EN"

