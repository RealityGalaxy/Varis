extends Node2D
@onready var multiplayerSpawner = $MultiplayerSpawner

var peer = SteamMultiplayerPeer.new()
var lobby_id = 0

func _ready():
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/multiplayerScreen.tscn")


func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$Background.hide()
	$MarginContainer.hide()
	$LobbyScrollContainer/Lobbies.hide()

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.requestLobbyList()
	
func _on_lobby_match_list(lobbies):
	
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var player_count = Steam.getNumLobbyMembers(lobby)
		
		if lobby_name == "godlobby":
			var button = Button.new()
			button.set_text(str(lobby_name, "| Player Count: ", player_count))
			button.set_size(Vector2(100, 5))
			button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			$MarginContainer/HBoxContainer/LobbyScrollContainer/Lobbies.add_child(button)
		else:
			var button = Button.new()
			button.set_text("no lobbies :(")
			button.set_size(Vector2(100, 5))		
			$MarginContainer/HBoxContainer/LobbyScrollContainer/Lobbies.add_child(button)
			return
