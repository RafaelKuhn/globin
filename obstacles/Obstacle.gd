extends Spatial

signal on_any_collision(lane, tipo)

var supeedo := 5
var has_collided := false

func _ready():
	pass



func _process(delta: float):
			# x y z
	translate(Vector3(0, 0, delta*supeedo))
	if !has_collided && translation.z >= 0:
		has_collided = true
		emit_signal("on_any_collision", translation.x, "preda")

