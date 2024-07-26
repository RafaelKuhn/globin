extends Control

const BASE_W := 1920
const BASE_H := 1080

func _ready():
	_fix_relative_rect_scale()

func _process(_delta):
	_fix_relative_rect_scale()


func _fix_relative_rect_scale():
	var size = get_viewport_rect().size;
	var relative_x = size.x/BASE_W
	var relative_y = size.y/BASE_H

	var min_relative = min(relative_x, relative_y);

	# var aspect = size.x / size.y

	# simplest solution
	self.rect_scale.x = min_relative
	self.rect_scale.y = min_relative
	# print("w %s  h %s, rel w %s  rel h %s  MIN: %s " % [ size.x, size.y, relative_x, relative_y, min_relative ] )
