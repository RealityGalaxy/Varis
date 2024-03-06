extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var multiplayerSpawner = $MultiplayerSpawner

func _ready():
	multiplayerSpawner.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	
	
func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a


func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayerSpawner.spawn("res://scenes/level.tscn")
	$Background.hide()
	$MarginContainer.hide()
	
	
	
func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str("godlobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)


func _on_join_pressed():
	get_tree().change_scene_to_file("res://scenes/lobbiesScreen.tscn")
	$MarginContainer.hide()
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


