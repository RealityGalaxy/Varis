extends Node

func change_keybind(action, new_hotkey):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, new_hotkey)
	
