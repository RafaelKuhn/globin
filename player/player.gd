extends Spatial

enum VerticalStates { DEFAULT, JUMPING, ROLLING }
enum HorizontalStates { RUNNING, SWITCHING }

export var lane_switch_delay := 0.3
export var lane_switch_allowed_gap := 0.7
export var jump_delay := 0.85
export var rolling_delay := 0.7

var vertical_state = VerticalStates.DEFAULT
var horizontal_state = HorizontalStates.RUNNING

var lane: int
var previous_lane: int

var anim_h_progress := 0.0


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

	update_horizontal_animation(delta)
	update_vertical_animation(delta)


# vertical:
func try_jumping():
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.JUMPING
	print("jumping")
	$JumpTimer.start(jump_delay)
	
func try_rolling():
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.ROLLING
	print("rolling")
	$JumpTimer.start(rolling_delay)

func _on_JumpTimer_timeout():
	vertical_state = VerticalStates.DEFAULT
	print("time out vertical")


# horizontal:
func try_switching_right():
	if horizontal_state != HorizontalStates.RUNNING:
		return
	if lane == 3:
		return
	
	switch_right()
	horizontal_state = HorizontalStates.SWITCHING
	$LaneTimer.start(lane_switch_delay)
	
func try_switching_left():
	if horizontal_state != HorizontalStates.RUNNING:
		return
	if lane == 1:
		return
	
	switch_left()
	horizontal_state = HorizontalStates.SWITCHING
	$LaneTimer.start(lane_switch_delay)


# início da troca de lane
func switch_right():
	previous_lane = lane
	lane = lane + 1
	anim_h_progress = 0.0
	# print("vai trocar, animation progress: %f " % anim_h_progress)

func switch_left():
	previous_lane = lane
	lane = lane - 1
	anim_h_progress = 0.0
	# print("vai trocar, animation progress: %f " % anim_h_progress)


# fim da troca de lane
func _on_LaneTimer_timeout():
	horizontal_state = HorizontalStates.RUNNING
	# print("trocou, animation progress: %f " % anim_h_progress)


func update_horizontal_animation(delta: float):
	if horizontal_state != HorizontalStates.SWITCHING:
		return

	anim_h_progress += delta * 1/lane_switch_delay
	translation.x = lerp(previous_lane, lane, anim_h_progress)

func update_vertical_animation(_delta: float):
	match vertical_state:
		VerticalStates.JUMPING:
			$Sprite/Animated.animation = "jumping"
			translation.y = 2
		VerticalStates.ROLLING:
			scale.y = 0.7
			scale.x = 1.5		
		VerticalStates.DEFAULT:
			$Sprite/Animated.animation = "running"
			translation.y = 0
			scale.y = 1
			scale.x = 1
			


var Globals = preload("res://globals.gd")

# eventos
func _on_any_obstacle_z_collision(lane_obstacle_x: int, obj_type):
	var is_collision_in_the_same_lane = lane_obstacle_x == lane
	var is_coliision_while_switching_lanes = lane_obstacle_x == previous_lane && anim_h_progress < lane_switch_allowed_gap
	if is_collision_in_the_same_lane || is_coliision_while_switching_lanes:
		try_to_collide_based_on_type(obj_type)
		


func try_to_collide_based_on_type(obj_type):
	match obj_type:
		Globals.OBSTACLE_TYPE.PREDA:
			lose_hp()
		Globals.OBSTACLE_TYPE.GIFA:
			if (vertical_state != VerticalStates.ROLLING):
				lose_hp()
		Globals.OBSTACLE_TYPE.TOCO:
			if (vertical_state != VerticalStates.JUMPING):
				lose_hp()

func lose_hp():
	get_tree().quit()