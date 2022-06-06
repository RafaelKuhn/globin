extends Sprite3D

var time = 0

func _ready() -> void:
	material_override.set_shader_param("_intensity", 1.3)

func _process(delta: float) -> void:
	material_override.set_shader_param("_time", time)
	time += delta
