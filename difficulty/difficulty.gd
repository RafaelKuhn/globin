extends Node

const Difficulty = preload("res://difficulty/difficulty_enum.gd")

var game_node: Node

func _ready():
	game_node = get_node("/root/Game")
	match game_node.game_difficulty:
		Difficulty.BABY:
			baby_ui()
		Difficulty.EASY:
			easy_ui()
		Difficulty.MEDI:
			medi_ui()
		Difficulty.HARD:
			hard_ui()
		_:
			easy_ui()
			push_error("UNHANDLED ENUM CASE: %s" % game_node.game_difficulty)

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_play_pressed()
		return
	if Input.is_action_just_pressed("back_key"):
		_on_go_back()
		return
	if Input.is_action_just_pressed("W_key"):
		difficulty_down()
		return
	if Input.is_action_just_pressed("S_key"):
		difficulty_up()
		return


func _on_go_back():
	game_node.open_menu_scene()

func _on_play_pressed():
	game_node.load_game_scene()



func _on_baby():
	baby_ui()
	game_node.set_baby_difficulty()

func _on_easy():
	easy_ui()
	game_node.set_easy_difficulty()

func _on_medi():
	medi_ui()
	game_node.set_medi_difficulty()

func _on_hard():
	hard_ui()
	game_node.set_hard_difficulty()


func baby_ui():
	disable_btns()
	$BabyBtn.disabled = true
	dim_btns()
	$BabyBtn.modulate = Color.white
	disable_arrows_tooltips()
	$BabyToEasy.visible = true

func easy_ui():
	disable_btns()
	$EasyBtn.disabled = true
	dim_btns()
	$EasyBtn.modulate = Color.white
	disable_arrows_tooltips()
	$EasyToBaby.visible = true
	$EasyToMedi.visible = true

func medi_ui():
	disable_btns()
	$MediBtn.disabled = true
	dim_btns()
	$MediBtn.modulate = Color.white
	disable_arrows_tooltips()
	$MediToHard.visible = true
	$MediToEasy.visible = true

func hard_ui():
	disable_btns()
	$HardBtn.disabled = true
	dim_btns()
	$HardBtn.modulate = Color.white
	disable_arrows_tooltips()
	$HardToMedi.visible = true


func disable_btns():
	$BabyBtn.disabled = false
	$EasyBtn.disabled = false
	$MediBtn.disabled = false
	$HardBtn.disabled = false

func dim_btns():
	var dimmed_col = Color(0.73, 0.73, 0.73, 0.7)
	$BabyBtn.modulate = dimmed_col
	$EasyBtn.modulate = dimmed_col
	$MediBtn.modulate = dimmed_col
	$HardBtn.modulate = dimmed_col

func disable_arrows_tooltips():
	$BabyToEasy.visible = false
	$EasyToBaby.visible = false
	$EasyToMedi.visible = false
	$MediToEasy.visible = false
	$MediToHard.visible = false
	$HardToMedi.visible = false


func difficulty_up():
	if game_node.game_difficulty == Difficulty.HARD:
		return

	if game_node.game_difficulty == Difficulty.MEDI:
		_on_hard()
		return

	if game_node.game_difficulty == Difficulty.EASY:
		_on_medi()
		return

	if game_node.game_difficulty == Difficulty.BABY:
		_on_easy()
		return

	push_error("Unhandled difficulty %s" % self.game_difficulty)

func difficulty_down():
	if game_node.game_difficulty == Difficulty.BABY:
		return

	if game_node.game_difficulty == Difficulty.EASY:
		_on_baby()
		return
	
	if game_node.game_difficulty == Difficulty.MEDI:
		_on_easy()
		return
	
	if game_node.game_difficulty == Difficulty.HARD:
		_on_medi()
		return
	
	push_error("Unhandled difficulty %s" % self.game_difficulty)

