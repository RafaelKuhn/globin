extends Control


var label: Label


func _ready():
	var parent = get_parent();
	if not (parent is Label):
		push_error(" PARENT IS NOT LABEL!")
		return
	label = parent


func refresh_label(term_key):
	var term = Translator.get_term(term_key);
	if term == null:
		push_error("NULL TERM? ")
		return
	label.text = term

func refresh_label_dyn(term_key, times_lost):
	# print("refreshing label dyn")
	var term = Translator.get_term(term_key)
	if term.find("%s") == -1:
		push_error("no dynamic string in term '%s'" % term)
		return
	label.text = term % times_lost
