extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _init():
	spawn_function = _spawn_spell


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _spawn_spell(data):
	var spell = load(data).instantiate()
	return spell
	
