extends Spatial
class_name Obstacle

var Globals = preload("../globals.gd")

signal on_any_collision(lane, tipo)

# const OBSTACLE_TYPE = preload("res://obstacles/obstacle_type.gd")
# enum OBJ_TYPE { GIFA, PREDA, TOCO }
export(Globals.OBSTACLE_TYPE) var type

var speed := 5
var has_collided := false

func _process(delta: float):
	translate(Vector3(0, 0, delta * speed))
	if !has_collided && translation.z >= 0:
		has_collided = true
		emit_signal("on_any_collision", translation.x, type)