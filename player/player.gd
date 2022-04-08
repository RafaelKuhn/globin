extends KinematicBody

enum HorizontalStates {DEFAULT, JUMPING, ROLLING}
#enum vertical_state {}
var horizontal_state = HorizontalStates.DEFAULT

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("W_key"):
		try_jumping()
		
	if Input.is_action_just_pressed("S_key"):
		try_rolling()
			
func try_jumping():
	if horizontal_state != HorizontalStates.DEFAULT:
		return
	horizontal_state = HorizontalStates.JUMPING
	print("started jumping")
	$JumpTimer.start(2.0)
	
func try_rolling():
	if horizontal_state != HorizontalStates.DEFAULT:
		return
	horizontal_state = HorizontalStates.ROLLING
	print("started rolling")
	$JumpTimer.start(1.0)


func _on_JumpTimer_timeout():
	horizontal_state = HorizontalStates.DEFAULT
	print("time out vertical")
	

