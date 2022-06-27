extends Sprite3D

var time := 0.0

func _ready() -> void:
	var shader_speed = get_node("/root/Game").game_speed / 5.0 * 1.3
	material_override.set_shader_param("_intensity", shader_speed)

func _process(delta: float) -> void:
	material_override.set_shader_param("_time", time)
	time += delta
