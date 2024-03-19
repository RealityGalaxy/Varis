extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var multiplayerSpawner = $MultiplayerSpawner

func _ready():
	
	multiplayerSpawner.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	
func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a


func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayerSpawner.spawn("res://scenes/level/level.tscn")
	$Background.queue_free()
	$MarginContainer.queue_free()


func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", "godlobby | %s" % $Steam.username)
		Steam.setLobbyJoinable(lobby_id, true)

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$Background.queue_free()
	$MarginContainer.queue_free()
	$MarginContainer/PopupPanel.queue_free()
	


func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.requestLobbyList()


func _on_lobby_match_list(lobbies):
	
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var player_count = Steam.getNumLobbyMembers(lobby)
		
		if lobby_name.begins_with("godlobby"):
			var button = Button.new()
			button.set_text(str(lobby_name.erase(0, 11), "| Players: ", player_count))
			button.set_size(Vector2(100, 5))
			button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			$MarginContainer/PopupPanel/LobbyScrollContainer/Lobbies.add_child(button)

func _on_join_pressed():

	for button in $MarginContainer/PopupPanel/LobbyScrollContainer/Lobbies.get_children():
		button.queue_free()
		
	open_lobby_list()
	$MarginContainer/PopupPanel.popup()
	

func _input(event):
		if Input.is_action_just_pressed("esc"):
			Steam.deleteLobbyData(lobby_id, "name")
			get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
