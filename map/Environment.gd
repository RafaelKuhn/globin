extends Spatial

var Global = preload("res://global.gd")

var speed := 5.0

var objects: Array
var objects_last_z_position: float


func _ready():
	if not Engine.editor_hint:
		objects = get_children()
		find_last_z_position_of_objects();


func _process(delta):
	for obj in objects:
		obj.translation.z += delta * Global.GAME_SPEED
		if obj.translation.z > Global.GAME_Z_END:
			obj.translation.z = objects_last_z_position

func find_last_z_position_of_objects():
	var lowest_position = objects[0].translation.z
	for obj in objects:
		if obj.translation.z < lowest_position:
			objects_last_z_position = obj.translation.z
