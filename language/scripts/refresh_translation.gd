extends Control


var label: Label


func _ready():
	var parent = get_parent();
	if not (parent is Label):
		push_error(" PARENT IS NOT LABEL!")
		return
	label = parent


func refresh_label(term_key):
	label.text = Translator.get_term(term_key)
