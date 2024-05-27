extends Control

func _ready():
	GlobalSteam.lobby_id = -1

func _on_singleplayer_pressed():
	Sfx.button_click()
	get_tree().change_scene_to_file("res://scenes/level/singleplayer_level.tscn")
	
func _on_multiplayer_pressed():
	Sfx.button_click()
	get_tree().change_scene_to_file("res://scenes/multiplayer/multiplayerScreen.tscn")

func _on_settings_pressed():
	Sfx.button_click()
	get_tree().change_scene_to_file("res://scenes/menus/settings/settings.tscn")

func _on_exit_pressed():
	Sfx.button_click()
	get_tree().quit()


