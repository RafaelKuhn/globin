extends KinematicBody

enum VerticalStates { DEFAULT, JUMPING, ROLLING }
enum HorizontalState { RUNNING, SWITCHING }

var vertical_state = VerticalStates.DEFAULT
var horizontal_state = HorizontalState.RUNNING

export var lane_switch_delay := 0.2

var lane: int
var previous_lane: int

var anim_progress := 0.0


func _ready():
	previous_lane = 2
	lane = 2
	translation.x = lane

func _process(delta: float):
	if Input.is_action_just_pressed("W_key"):
		try_jumping()
		
	if Input.is_action_just_pressed("S_key"):
		try_rolling()

	if Input.is_action_just_pressed("D_key"):
		try_switching_right()
	
	if Input.is_action_just_pressed("A_key"):
		try_switching_left()

	update_animation(delta)


# vertical:
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


# horizontal:
func try_switching_right():
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 3:
		return
	
	switch_right()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(lane_switch_delay)
	
func try_switching_left():
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 1:
		return
	
	switch_left()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(lane_switch_delay)


# início da troca de lane
func switch_right():
	previous_lane = lane
	lane = lane + 1
	anim_progress = 0.0
	# print("vai trocar, animation progress: %f " % anim_progress)

func switch_left():
	previous_lane = lane
	lane = lane - 1
	anim_progress = 0.0
	# print("vai trocar, animation progress: %f " % anim_progress)


# fim da troca de lane
func _on_LaneTimer_timeout():
	horizontal_state = HorizontalState.RUNNING
	# print("trocou, animation progress: %f " % anim_progress)


func update_animation(delta: float):
	if horizontal_state != HorizontalState.SWITCHING:
		return

	anim_progress += delta * 1/lane_switch_delay
	translation.x = lerp(previous_lane, lane, anim_progress)


# eventos
func _on_any_obstacle_z_collision(lane_obstacle_x, _obj_type):
	print("chegou no Z")
	if lane_obstacle_x == lane:
		print("colidiu")
	# deve checar tbm se é a msm lane que ele estava && interval < 0.5
