extends Control
export (String) var term_key: String

func _ready():
	_update_term_by_key()
	var __ = Translator.connect("language_changed", self, "_on_language_changed")


func _on_language_changed():
	_update_term_by_key()


func _update_term_by_key():
	if term_key.empty():
		push_error("EMPTY TERM KEY ON TODO:")
		return
	# sanity check for empty term

	var parent = get_parent();
	if not (parent is Label):
		push_error(" PARENT IS NOT LABEL!")
		return

	var parent_label: Label = parent as Label

	var term = Translator.get_term(term_key);
	parent_label.text = term
	# print("GOT TERM %s" % term)
