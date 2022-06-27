extends Spatial

signal damage_taken()

const Global = preload("res://global.gd")

enum VerticalState { DEFAULT, JUMPING, ROLLING }
enum HorizontalState { RUNNING, SWITCHING }

# constantes
const LEFTMOST_LANE := 1
const RIGHTMOST_LANE := 3

const LANE_SWITCH_DURATION := 0.3
const MIN_PERCENTAGE_TO_SWITCH_LANE_AGAIN := 0.35

const ROLLING_DURATION := 0.5
const JUMP_DURATION := 0.5
const JUMP_HEIGHT := 1.5

const SWITCHING_LANES_COLLISION_GAP := 0.7

# estado
var vertical_state = VerticalState.DEFAULT
var horizontal_state = HorizontalState.RUNNING

var lane: int
var previous_lane: int

var lane_switch_progress := 1.0
var jump_progress := 0.0

##################### callbacks #####################
func _ready() -> void:
	start_in_second_lane()

func start_in_second_lane():
	previous_lane = 2
	lane = 2
	translation.x = lane

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


##################### movimento vertical #####################
func try_jumping() -> void:
	if vertical_state != VerticalState.DEFAULT:
		return
	vertical_state = VerticalState.JUMPING
	$JumpTimer.start(Global.sync_inverse_game_speed(JUMP_DURATION))
	
func try_rolling() -> void:
	if vertical_state != VerticalState.DEFAULT:
		return
	vertical_state = VerticalState.ROLLING
	$JumpTimer.start(Global.sync_inverse_game_speed(ROLLING_DURATION))

func _on_JumpTimer_timeout() -> void:
	vertical_state = VerticalState.DEFAULT


##################### movimento horizontal #####################
func try_switching_right() -> void:
	if lane_switch_progress < MIN_PERCENTAGE_TO_SWITCH_LANE_AGAIN:
		return
	if lane == RIGHTMOST_LANE:
		return
	
	switch_right()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(Global.sync_inverse_game_speed(LANE_SWITCH_DURATION))
	
func try_switching_left() -> void:
	if lane_switch_progress < MIN_PERCENTAGE_TO_SWITCH_LANE_AGAIN:
		return
	if lane == LEFTMOST_LANE:
		return
	
	switch_left()
	horizontal_state = HorizontalState.SWITCHING
	$LaneTimer.start(Global.sync_inverse_game_speed(LANE_SWITCH_DURATION))

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

	lane_switch_progress += delta * 1.0 / Global.sync_inverse_game_speed(LANE_SWITCH_DURATION)
	translation.x = lerp(previous_lane, lane, tween_quad(lane_switch_progress))
	

func update_vertical_movement(_delta: float) -> void:
	match vertical_state:
		VerticalState.JUMPING:
			jump_progress = 1.0 - $JumpTimer.time_left / $JumpTimer.wait_time
			translation.y = JUMP_HEIGHT * tween_expo_in_out(jump_progress)
			$Sprite/Animated.animation = "jumping" if jump_progress < 0.8 else "falling"

		VerticalState.ROLLING:
			$Sprite/Animated.animation = "sliding"

		VerticalState.DEFAULT:
			translation.y = 0
			$Sprite/Animated.animation = "running"

func tween_expo_in_out(x: float) -> float:
	# t mapeia 0->1 para 0->1->0
	var t = 1 - abs(2 * fmod(x, 1) - 1)
	return 1 - pow(2, -10 * t)

func tween_quad(x: float) -> float:
	return 1 - (1 - x) * (1 - x)

##################### colisão dos objetos #####################
# callback para quando algum objeto 'obstacle' chega na posição z do player
func _on_any_obstacle_z_collision(lane_obstacle_x: int, obj_type) -> void:
	if obj_type == Global.OBSTACLE_TYPE.WIN:
		get_node(Global.GAME_MANAGER_PATH).win_game()
	
	var has_collided_in_current_lane = lane_obstacle_x == lane && lane_switch_progress > SWITCHING_LANES_COLLISION_GAP
	var has_collided_while_switching_lanes = lane_obstacle_x == previous_lane && lane_switch_progress < SWITCHING_LANES_COLLISION_GAP

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
