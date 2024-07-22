extends Control

const BASE_W := 1920
const BASE_H := 1080

func _process(delta):
	var size = get_viewport_rect().size;
	var aspect_x = size.x/BASE_W
	var aspect_y = size.y/BASE_H
	var min_aspect = min(aspect_x, aspect_y);
	self.rect_scale = Vector2(min_aspect, min_aspect)
	# print("w %s  h %s, as w %s  as h %s  MIN: %s" % [ size.x, size.y, aspect_x, aspect_y, min_aspect ] )
