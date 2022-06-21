extends Sprite3D

var Global = preload("res://global.gd")

var time := 0.0

var shader_relative_speed = Global.GAME_SPEED / 5.0 * 1.3

func _ready() -> void:
	material_override.set_shader_param("_intensity", shader_relative_speed)

func _process(delta: float) -> void:
	material_override.set_shader_param("_time", time)
	time += delta
