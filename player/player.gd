extends Spatial

enum VerticalStates { DEFAULT, JUMPING, ROLLING }
enum HorizontalState { RUNNING, SWITCHING }

export var lane_switch_delay := 0.2
export var lane_switch_allowed_gap := 0.7

var vertical_state = VerticalStates.DEFAULT
var horizontal_state = HorizontalState.RUNNING

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


var Globals = preload("res://globals.gd")

# eventos
func _on_any_obstacle_z_collision(lane_obstacle_x: int, obj_type):
	var is_collision_in_the_same_lane = lane_obstacle_x == lane
	var is_coliision_while_switching_lanes = lane_obstacle_x == previous_lane && anim_progress < lane_switch_allowed_gap
	if is_collision_in_the_same_lane || is_coliision_while_switching_lanes:
		try_to_collide_based_on_type(obj_type)
		


func try_to_collide_based_on_type(obj_type):
	match obj_type:
		Globals.OBSTACLE_TYPE.PREDA:
			print("preda pegou você, se fudeu")
		Globals.OBSTACLE_TYPE.GIFA:
			print("girafa pegou você, ta abaixado meo?")
		Globals.OBSTACLE_TYPE.TOCO:
			print("toco pegou você, ta pulando meo?")
