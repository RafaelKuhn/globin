extends KinematicBody

enum VerticalStates { DEFAULT, JUMPING, ROLLING }
enum HorizontalState { RUNNING, SWITCHIG }

var vertical_state = VerticalStates.DEFAULT
var horizontal_state = HorizontalState.RUNNING

var lane: int


export var lane_switch_delay := 0.2


func _ready():
	lane = 2
	translation.x = lane

func _process(_delta):
	if Input.is_action_just_pressed("W_key"):
		try_jumping()
		
	if Input.is_action_just_pressed("S_key"):
		try_rolling()

	if Input.is_action_just_pressed("D_key"):
		try_switching_right()
	
	if Input.is_action_just_pressed("A_key"):
		try_switching_left()

			
func try_jumping():
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.JUMPING
	print("jumping")
	$JumpTimer.start(2.0)
	
func try_rolling():
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.ROLLING
	print("rolling")
	$JumpTimer.start(1.0)

func _on_JumpTimer_timeout():
	vertical_state = VerticalStates.DEFAULT
	print("time out vertical")


func try_switching_right():
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 3:
		return
	
	switch_right()
	horizontal_state = HorizontalState.SWITCHIG
	$LaneTimer.start(lane_switch_delay)
	
func try_switching_left():
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 1:
		return
	
	switch_left()
	horizontal_state = HorizontalState.SWITCHIG
	$LaneTimer.start(lane_switch_delay)

func _on_LaneTimer_timeout():
	horizontal_state = HorizontalState.RUNNING

func switch_right():
	lane = lane + 1
	translation.x = lane

func switch_left():
	lane = lane - 1
	translation.x = lane