extends Node2D

const NodeHP = preload("res://hp/vida.tscn")
const NodeBlinkingHP = preload("res://hp/vida-piscando.tscn")
const NodeLostHP = preload("res://hp/vida-perdida.tscn")

const HP_REGEN_TIME_SEC := 5
const MAX_HP := 2

var instanced_hp_sprites := []
var current_hp := MAX_HP

const Global = preload("res://global.gd")

##################### callbacks #####################
func _ready() -> void:
	draw_current_hp_sprites()

func _on_Player_damage_taken():
	decrement_health()

##################### HP #####################
func decrement_health() -> void:
	current_hp -= 1
	if current_hp == 0:
		get_node(Global.ROOT_GAME_PATH).lose_game()
		
	update_heart_sprites()
	queue_hp_regen()

func regenerate_health() -> void:
	current_hp += 1
	update_heart_sprites()

func fill_health() -> void:
	current_hp = MAX_HP
	update_heart_sprites()

##################### mexe nos sprites #####################
func draw_current_hp_sprites() -> void:
	# instancia todo o hp atual como um "sprite normal"
	for hp_index in current_hp:
		instanced_hp_sprites.push_back(instance_hp())

func update_heart_sprites() -> void:
	for hp in instanced_hp_sprites:
		hp.queue_free()
	instanced_hp_sprites.clear()

	draw_current_hp_sprites()

	var lost_hps = MAX_HP - current_hp

	# o primeiro depois dos HPS acesos, deixa piscando
	if (lost_hps > 0):
		instanced_hp_sprites.push_back(instance_blinking_hp())

	# para todos os HPS perdidos - 1, instancia um HP apagado
	for _i in lost_hps - 1:
		instanced_hp_sprites.push_back(instance_lost_hp())
	
	
	

func instance_hp() -> Sprite:
	var hp_node = NodeHP.instance()
	add_child(hp_node)
	hp_node.position.x = get_hp_x_position(instanced_hp_sprites.size())
	return hp_node

func instance_blinking_hp() -> Sprite:
	var hp_node = NodeBlinkingHP.instance()
	add_child(hp_node)
	hp_node.position.x = get_hp_x_position(instanced_hp_sprites.size())
	return hp_node

func instance_lost_hp() -> Sprite:
	var hp_node = NodeLostHP.instance()
	add_child(hp_node)
	hp_node.position.x = get_hp_x_position(instanced_hp_sprites.size())
	return hp_node

func get_hp_x_position(current_hp_index: int) -> float:
	# gap inicial + ( índice * distância entre hps )
	return 44 + current_hp_index * 61.0


##################### regen de HP #####################
func queue_hp_regen() -> void:
	# primeiro para o timer, 
	$"HP Regen Timer".stop()
	$"HP Regen Timer".start(HP_REGEN_TIME_SEC)

func _on_HP_Regen_Timer_timeout():
	regenerate_health()
	if current_hp < MAX_HP:
		queue_hp_regen()
