extends Spatial

signal on_any_collision(lane, tipo)

const Obstacle = preload("res://game-parts/obstacles/obstacle_type.gd")
export(Obstacle.Type) var type

onready var speed: float = get_node("/root/Game").game_speed

onready var sprite = get_node("Sprite")

var has_collided := false

# TODO: make this work with global positions
func _ready():
	# var global_pos = to_global(translation)
	var global_pos = translation
	if global_pos.z < Global.GAME_Z_START:
		sprite.modulate.a = 0.0

func _process(delta: float) -> void:
	if !self.is_visible():
		return

	var global_pos = translation
	translation.z += delta * speed
	if global_pos.z > Global.GAME_Z_END:
		has_collided = true
		queue_free()

	if !has_collided && global_pos.z >= Global.PLAYER_Z_POSITION:
		has_collided = true
		emit_signal("on_any_collision", round(translation.x), type)
	
	if global_pos.z > Global.GAME_Z_START:
		sprite.modulate.a += delta * Global.ALPHA_INCREMENT_SPEED
