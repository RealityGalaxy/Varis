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

func update_player_spawn(player):
	var spawnpoint
	if get_parent().find_child("Maps") && $"../Maps".map == null:
		$"../Maps".set_map(GlobalSteam.lobby_id % 3)
		spawnpoint = $"../Maps".map.get_child(0).get_child(index-1)
		player.scale = Vector2(0.4, 0.4)
	
	player.position = spawnpoint.position

func spawnPlayer(data):
	var player = playerScene.instantiate()
	player.set_multiplayer_authority(data)
	player.use_spell.connect(get_node("../SpellManager").on_spell_fire)
	players[data] = player
	var spawnpoint = Vector2(0,0)
	if get_parent().find_child("Maps") and GlobalSteam.lobby_id != -1:
		$"../Maps".set_map(GlobalSteam.lobby_id % 3)
		spawnpoint = $"../Maps".map.get_child(0).get_child(index).position
		player.scale = Vector2(0.4, 0.4)
	elif not get_parent().find_child("Maps") and GlobalSteam.lobby_id == -1:
		spawnpoint = $"../SpawnPoints".get_children().pick_random().position
	player.position = spawnpoint
	index += 1;

	player.player_num = index;
	GameStatus.players.push_back(player.player_num)
	StatManager.add_player(player.player_num, Steam.getPersonaName())

	return player

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)


