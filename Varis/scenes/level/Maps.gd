extends Node

var map

func set_map(index):
	map = get_children(index)
	map.set_layer_enabled(0, true)
