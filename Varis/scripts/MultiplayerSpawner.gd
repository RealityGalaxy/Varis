extends MultiplayerSpawner

@export var playerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

var players = {}

func spawnPlayer(data):
	var player = playerScene.instantiate()
	player.set_multiplayer_authority(data)
	players[data] = player
	return player

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
