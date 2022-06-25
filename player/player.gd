extends Spatial

signal damage_taken()

const Global = preload("res://global.gd")
enum VerticalState { DEFAULT, JUMPING, ROLLING }
enum HorizontalState { RUNNING, SWITCHING }

# constantes
const lane_switch_delay := 0.3
const lane_switch_allowed_gap := 0.7
const jump_delay := 0.75
const rolling_delay := 0.7
const jump_height := 1.5

# estado
var vertical_state = VerticalState.DEFAULT
var horizontal_state = HorizontalState.RUNNING

var lane: int
var previous_lane: int

var lane_switch_progress := 0.0
var jump_progress := 0.0

##################### callbacks #####################
func _ready() -> void:
	start_in_second_lane()

func _input(_event) -> void:
	if Input.is_action_just_pressed("W_key"):
		try_jumping()
		
	if Input.is_action_just_pressed("S_key"):
		try_rolling()

	if Input.is_action_just_pressed("D_key"):
		try_switching_right()
	
	if Input.is_action_just_pressed("A_key"):
		try_switching_left()

func _process(delta: float) -> void:
	update_horizontal_movement(delta)
	update_vertical_movement(delta)

func start_in_second_lane():
	previous_lane = 2
	lane = 2
	translation.x = lane

##################### movimento vertical #####################
func try_jumping() -> void:
	if vertical_state != VerticalState.DEFAULT:
		return
	vertical_state = VerticalState.JUMPING
	$JumpTimer.start(jump_delay)
	
func try_rolling() -> void:
	if vertical_state != VerticalState.DEFAULT:
		return
	vertical_state = VerticalState.ROLLING
	$JumpTimer.start(rolling_delay)

func _on_JumpTimer_timeout() -> void:
	vertical_state = VerticalState.DEFAULT


##################### movimento horizontal #####################
func try_switching_right() -> void:
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 3:
		return
	
	switch_right()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(lane_switch_delay)
	
func try_switching_left() -> void:
	if horizontal_state != HorizontalState.RUNNING:
		return
	if lane == 1:
		return
	
	switch_left()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(lane_switch_delay)

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

# fim da troca de lane
func _on_LaneTimer_timeout() -> void:
	horizontal_state = HorizontalState.RUNNING
	# print("trocou de lane, animation progress: %f " % lane_switch_progress)

##################### movimento / animações (chamado todo frame) #####################
func update_horizontal_movement(delta: float) -> void:
	if horizontal_state != HorizontalState.SWITCHING:
		return

	lane_switch_progress += delta * 1/lane_switch_delay
	translation.x = lerp(previous_lane, lane, tween_quad(lane_switch_progress))
	

func update_vertical_movement(_delta: float) -> void:
	match vertical_state:
		VerticalState.JUMPING:
			jump_progress = 1.0 - $JumpTimer.time_left / $JumpTimer.wait_time
			translation.y = jump_height * tween_expo_in_out(jump_progress)
			$Sprite/Animated.animation = "jumping" if jump_progress < 0.8 else "falling"
			DEV_desamassa()
		VerticalState.ROLLING:
			$Sprite/Animated.animation = "running"
			DEV_amassa()
		VerticalState.DEFAULT:
			translation.y = 0
			$Sprite/Animated.animation = "running"
			DEV_desamassa()

func tween_expo_in_out(x: float) -> float:
	# t mapeia 0->1 para 0->1->0
	var t = 1 - abs(2 * fmod(x, 1) - 1)
	return 1 - pow(2, -10 * t)

func tween_quad(x: float) -> float:
	return 1 - (1 - x) * (1 - x)

func DEV_amassa() -> void:
	scale.y = 0.7
	scale.x = 1.5

func DEV_desamassa() -> void:
	scale.y = 1
	scale.x = 1

##################### colisão dos objetos #####################
# callback para quando algum objeto chega na posição z do player
func _on_any_obstacle_z_collision(lane_obstacle_x: int, obj_type) -> void:
	var has_collided_in_current_lane = lane_obstacle_x == lane && lane_switch_progress > lane_switch_allowed_gap
	var has_collided_while_switching_lanes = lane_obstacle_x == previous_lane && lane_switch_progress < lane_switch_allowed_gap

	if has_collided_in_current_lane || has_collided_while_switching_lanes:
		try_to_collide_based_on_type(obj_type)

func try_to_collide_based_on_type(obj_type):
	match obj_type:
		Global.OBSTACLE_TYPE.PREDA:
			lose_hp()
		Global.OBSTACLE_TYPE.GIFA:
			if (vertical_state != VerticalState.ROLLING):
				lose_hp()
		Global.OBSTACLE_TYPE.TOCO:
			if (vertical_state != VerticalState.JUMPING):
				lose_hp()

func lose_hp():
	emit_signal("damage_taken")
