extends Spatial

var obstacles := []

func _ready():
	var children = get_children()
	for obstacle in children:
		obstacles.push_back(obstacle)
		# TODO: connect to signal
	
	print("amount of obstacles %d " % obstacles.size())
