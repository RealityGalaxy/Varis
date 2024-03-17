extends MultiplayerSpawner

@export var playerScene : PackedScene
# Called when the node enters the scene tree for the first time.
var index = 0
func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		spawn(2)
		
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

var players = {}

func spawnPlayer(data):
	var player = playerScene.instantiate()
	player.set_multiplayer_authority(data)
	StatManager.add_player(player.player_num)
	player.use_spell.connect(get_node("../SpellManager").on_spell_fire)
	players[data] = player

	for spawnpoint in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
		if spawnpoint.name == str(index):
			player.position = spawnpoint.position
	index += 1;

	player.player_num = index;

	return player

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)


