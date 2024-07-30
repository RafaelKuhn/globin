extends Camera

const SHAKE_DURATION := 0.1
onready var start_translation := translation

var shake_timeout := SHAKE_DURATION
var is_shaking := false


func _process(delta):
	translation = start_translation
	if is_shaking:
		shake()
		shake_timeout -= delta		
		if shake_timeout <= 0.0:
			is_shaking = false

func _on_HP_needs_to_shake_camera():
	reset_shake_timeout()
	is_shaking = true


func reset_shake_timeout():
	shake_timeout = SHAKE_DURATION

func shake():
	translation.x += rand_range(-0.5, 0.5)
	translation.y += rand_range(-0.5, 0.5)
