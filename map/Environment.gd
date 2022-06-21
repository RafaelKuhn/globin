extends Spatial

var Global = preload("res://global.gd")

var speed := 5.0

var objects: Array
var objects_last_z_position: float


func _ready():
	objects = get_children()
	find_last_z_position_of_objects();


func _process(delta):
	for obj in objects:
		obj.translation.z += delta * Global.GAME_SPEED
		if obj.translation.z > Global.GAME_Z_END:
			obj.translation.z = objects_last_z_position
			obj.get_child(0).modulate.a = 0.0
		
		obj.get_child(0).modulate.a += delta * Global.ALPHA_INCREMENT_SPEED



func find_last_z_position_of_objects():
	objects_last_z_position = objects[0].translation.z
	for obj in objects:
		if obj.get_child_count() > 1:
			print("%s ERRO! MAIS DE UM FILHO EM " % obj.name)
		if obj.translation.z < objects_last_z_position:
			objects_last_z_position = obj.translation.z

	print(objects_last_z_position) # TODO: sync with world end (Global const)
