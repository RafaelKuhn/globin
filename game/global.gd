extends Node
class_name Global

enum OBSTACLE_TYPE { GIFA, PREDA, TOCO, WIN }

# TODO: sync with environment
const GAME_Z_START := -12
const GAME_Z_END := 3.0

const PLAYER_Z_POSITION := 0.0

const ALPHA_INCREMENT_SPEED := 3.0

const GAME_MANAGER_PATH = "/root/Game"

const BABY_GAME_SPEED := 4.8
const EASY_GAME_SPEED := 8.0
const MEDI_GAME_SPEED := 10.0
const HARD_GAME_SPEED := 12.0

# TODO: deixar GAME_SPEED variável e usar 5.0 como DEFAULT_GAME_SPEED
#static func sync_game_speed(input: float, new_speed: float) -> float:
#	return input * new_speed / 5.0

static func sync_inverse_game_speed(input: float, new_speed: float) -> float:
	return input * 5.0 / new_speed



# debug
static func dump_tree(node, depth):
	dump_tree2(node, depth, "")

static func dump_tree2(node, depth, tabs):
	print("%s%s" % [ tabs, node ])
	tabs += "| "
	if depth == 0:
		if len(node.get_children()) > 0:
			print("%s%s" % [ tabs, "..." ])
		return
	
	for i in node.get_children():
		dump_tree2(i, depth-1, tabs)
