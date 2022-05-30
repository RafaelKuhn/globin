extends Node2D

export var max_hp := 2
export var current_hp := 2

const NodeHP = preload("res://hp/vida.tscn")
const NodeBlinkingHP = preload("res://hp/vida-piscando.tscn")
const NodeLostHP = preload("res://hp/vida-perdida.tscn")

var instanced_hp_amount := 0

# TODO: limpar os sprites, métodos para atualizar o HP máximo / atual

func _ready():
	update_heart_sprites()


func update_heart_sprites():
	# instancia o hp atual como um "sprite normal"
	for hp_index in current_hp:
		instance_hp()
	
	var lost_hps = max_hp - current_hp
	# instancia o último hp perdido como um "sprite piscando"
	if (lost_hps > 0):
		instance_blinking_hp()

	# instancia os hps perdidos como "sprites apagados"
	for hp_index in lost_hps - 1:
		instance_lost_hp()


func instance_hp():
	var hp_node = NodeHP.instance()
	add_child(hp_node)
	hp_node.position.x = 44 + (instanced_hp_amount * 61)
	instanced_hp_amount += 1

func instance_blinking_hp():
	var hp_node = NodeBlinkingHP.instance()
	add_child(hp_node)
	hp_node.position.x = 44 + (instanced_hp_amount * 61)
	instanced_hp_amount += 1

func instance_lost_hp():
	var hp_node = NodeLostHP.instance()
	add_child(hp_node)
	hp_node.position.x = 44 + (instanced_hp_amount * 61)
	instanced_hp_amount += 1
