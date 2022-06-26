extends Spatial

signal on_any_collision(lane, tipo)

const Global = preload("res://global.gd")
export(Global.OBSTACLE_TYPE) var type

onready var sprite = get_node("Sprite")

var has_collided := false


func _ready():
	if translation.z < Global.GAME_Z_START:
		sprite.modulate.a = 0.0

func _process(delta: float) -> void:
	translation.z += delta * Global.GAME_SPEED
	if !has_collided && translation.z >= 0:
		has_collided = true
		emit_signal("on_any_collision", round(translation.x), type)
	
	if translation.z > 3:
		queue_free()
	
	if translation.z > Global.GAME_Z_START:
		sprite.modulate.a += delta * Global.ALPHA_INCREMENT_SPEED

