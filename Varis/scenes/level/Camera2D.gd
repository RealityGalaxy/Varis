extends Camera2D

@onready var player = $"../MultiplayerSpawner".get_child(GameStatus.current_player - 1)

func _process(delta):
	set_position(player.get_position())
	pass
