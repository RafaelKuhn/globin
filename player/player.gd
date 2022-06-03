extends Spatial

var Globals = preload("res://globals.gd")
enum VerticalStates { DEFAULT, JUMPING, ROLLING }
enum HorizontalStates { RUNNING, SWITCHING }

export var lane_switch_delay := 0.3
export var lane_switch_allowed_gap := 0.7
export var jump_delay := 0.75
export var rolling_delay := 0.7
export var jump_height := 1.5

var vertical_state = VerticalStates.DEFAULT
var horizontal_state = HorizontalStates.RUNNING

var lane: int
var previous_lane: int

var lane_switch_progress := 0.0
var jump_progress := 0.0


##################### callbacks #####################
func _ready() -> void:
	previous_lane = 2
	lane = 2
	translation.x = lane

func _process(delta: float) -> void:
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


##################### vertical #####################
func try_jumping() -> void:
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.JUMPING
	# print("jumping")
	$JumpTimer.start(jump_delay)
	
func try_rolling() -> void:
	if vertical_state != VerticalStates.DEFAULT:
		return
	vertical_state = VerticalStates.ROLLING
	# print("rolling")
	$JumpTimer.start(rolling_delay)

func _on_JumpTimer_timeout() -> void:
	vertical_state = VerticalStates.DEFAULT


##################### horizontal #####################
func try_switching_right() -> void:
	if horizontal_state != HorizontalStates.RUNNING:
		return
	if lane == 3:
		return
	
	switch_right()
	horizontal_state = HorizontalStates.SWITCHING
	$LaneTimer.start(lane_switch_delay)
	
func try_switching_left() -> void:
	if horizontal_state != HorizontalStates.RUNNING:
		return
	if lane == 1:
		return
	
	switch_left()
	horizontal_state = HorizontalStates.SWITCHING
	$LaneTimer.start(lane_switch_delay)

# fim da troca de lane
func _on_LaneTimer_timeout() -> void:
	horizontal_state = HorizontalStates.RUNNING
	# print("trocou de lane, animation progress: %f " % lane_switch_progress)


# início da troca de lane
func switch_right() -> void:
	previous_lane = lane
	lane = lane + 1
	lane_switch_progress = 0.0
	# print("vai trocar de lane, animation progress: %f " % lane_switch_progress)

func switch_left() -> void:
	previous_lane = lane
	lane = lane - 1
	lane_switch_progress = 0.0
	# print("vai trocar de lane, animation progress: %f " % lane_switch_progress)

##################### animações (chamado todo frame) #####################
func update_horizontal_animation(delta: float) -> void:
	if horizontal_state != HorizontalStates.SWITCHING:
		return

	lane_switch_progress += delta * 1/lane_switch_delay
	translation.x = lerp(previous_lane, lane, lane_switch_progress)

func update_vertical_animation(_delta: float) -> void:
	match vertical_state:
		VerticalStates.JUMPING:
			$Sprite/Animated.animation = "jumping"
			jump_progress = 1.0 - $JumpTimer.time_left / $JumpTimer.wait_time
			translation.y = jump_height * tween_expo_in_out(jump_progress)
		VerticalStates.ROLLING:
			scale.y = 0.7
			scale.x = 1.5
		VerticalStates.DEFAULT:
			$Sprite/Animated.animation = "running"
			translation.y = 0
			scale.y = 1
			scale.x = 1

func tween_expo_in_out(x: float) -> float:
	# t remaps 0->1 to 0->1->0
	var t = 1 - abs(2 * fmod(x, 1) - 1)
	return 1 - pow(2, -10 * t)


##################### colisão dos objetos #####################
# quando algum objeto chega na posição z do player
func _on_any_obstacle_z_collision(lane_obstacle_x: int, obj_type) -> void:
	var is_obstacle_in_the_same_lane = lane_obstacle_x == lane
	var is_collision_while_switching_lanes = lane_obstacle_x == previous_lane && lane_switch_progress < lane_switch_allowed_gap
	if is_obstacle_in_the_same_lane || is_collision_while_switching_lanes:
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
