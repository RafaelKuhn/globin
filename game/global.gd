extends Node
# class_name Global

# enum OBSTACLE_TYPE { GIFA, PREDA, TOCO, WIN }

const GAME_Z_START := -12
const GAME_Z_END := 3.0

const PLAYER_Z_POSITION := 0.0

const ALPHA_INCREMENT_SPEED := 3.0

const GAME_MANAGER_PATH = "/root/Game"

const BABY_GAME_SPEED := 4.8
const EASY_GAME_SPEED := 8.0
const MEDI_GAME_SPEED := 10.0
const HARD_GAME_SPEED := 12.0



const CYAN   := Color(0.000, 0.973, 1.000, 1.000)
const WHITE  := Color(1.000, 1.000, 1.000, 1.000)
const GREEN  := Color(0.039, 0.988, 0.353, 1.000)
const ORANGE := Color(1.000, 0.702, 0.000, 1.000)
const YELLOW := Color(0.914, 0.988, 0.039, 1.000)
const RED    := Color(1.000, 0.165, 0.000, 1.000)


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
