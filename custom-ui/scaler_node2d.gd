extends Node2D

const BASE_W := 1920
const BASE_H := 1080

var initial_scale_x := self.scale.x
var initial_scale_y := self.scale.y

func _ready():
	_fix_relative_rect_scale()

func _process(_delta):
	_fix_relative_rect_scale()


func _fix_relative_rect_scale():
	var size = get_viewport_rect().size;
	var relative_x = size.x/BASE_W
	var relative_y = size.y/BASE_H

	var min_relative = min(relative_x, relative_y);

	self.scale.x = min_relative * initial_scale_x
	self.scale.y = min_relative * initial_scale_y
