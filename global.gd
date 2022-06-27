extends Node
class_name Global

enum OBSTACLE_TYPE { GIFA, PREDA, TOCO, WIN }

const GAME_SPEED := 10.0

# TODO: sync with environment
const GAME_Z_START := -12
const GAME_Z_END := 3.0

const PLAYER_Z_POSITION := 0.0

const ALPHA_INCREMENT_SPEED := 3.0

const GAME_MANAGER_PATH = "/root/Game"

# TODO: deixar GAME_SPEED variável e usar 5.0 como DEFAULT_GAME_SPEED
static func sync_game_speed(input: float) -> float:
	return input * GAME_SPEED / 5.0

static func sync_inverse_game_speed(input: float) -> float:
	return input * 5.0 / GAME_SPEED