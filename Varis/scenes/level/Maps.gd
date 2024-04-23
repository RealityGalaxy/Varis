extends Node

var map

func _ready():
	map = get_children().pick_random()
	map.set_layer_enabled(0, true)
