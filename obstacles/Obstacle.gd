extends Spatial
class_name Obstacle

signal on_any_collision(lane, tipo)

var Globals = preload("../globals.gd")
export(Globals.OBSTACLE_TYPE) var type

var speed := 5
var has_collided := false

func _process(delta: float) -> void:
	translate(Vector3(0, 0, delta * speed))
	if !has_collided && translation.z >= 0:
		has_collided = true
		emit_signal("on_any_collision", translation.x, type)
