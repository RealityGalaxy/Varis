extends Line2D

var length = 30
var parent

func _ready():
	parent = get_parent()
	set_as_top_level(true)
	clear_points() # editor points
	
func _physics_process(delta):
	add_point(parent.global_position)
	
	if points.size() > length:
		remove_point(0)
