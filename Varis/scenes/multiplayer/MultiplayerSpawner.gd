extends MultiplayerSpawner

@export var playerScene : PackedScene
# Called when the node enters the scene tree for the first time.
var index = 0
func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		#spawn(2)
		
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

var players = {}

func spawnPlayer(data):
	var player = playerScene.instantiate()
	player.set_multiplayer_authority(data)
	player.use_spell.connect(get_node("../SpellManager").on_spell_fire)
	players[data] = player
	var spawnpoint
	if get_parent().find_child("Maps"):
		$"../Maps".set_map(0)
		spawnpoint = $"../Maps".map.get_child(0).get_child(index)
		player.scale = Vector2(0.4, 0.4)
	else:
		spawnpoint = $"../SpawnPoints".get_children().pick_random()
	player.position = spawnpoint.position
	index += 1;

	player.player_num = index;
	GameStatus.players.push_back(player.player_num)
	StatManager.add_player(player.player_num)

	return player

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)


