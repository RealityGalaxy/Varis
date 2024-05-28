extends Control

@onready var buttons = [
	$MarginContainer/VBoxContainer/Keybinds/Spell1/Spell1,
	$MarginContainer/VBoxContainer/Keybinds/Spell2/Spell2,
	$MarginContainer/VBoxContainer/Keybinds/Spell3/Spell3,
	$MarginContainer/VBoxContainer/Keybinds/Spell4/Spell4,
	$MarginContainer/VBoxContainer/Keybinds/Spell5/Spell5,
]

func _on_back_pressed():
	Sfx.button_click()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")

func change_keybind(action, new_hotkey):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, new_hotkey)

var bind: String = ""

func _input(event):
	if bind != "" and event is InputEventKey and event.pressed and not event.echo:
		change_keybind(bind, event)
		change_button_text(bind, OS.get_keycode_string(event.keycode))
		bind = ""
		enable_buttons()
		
func change_button_text(button: String, newbind):
	match button:
		"spell1":
			buttons[0].text = newbind
		"spell2":
			buttons[1].text = newbind
		"spell3":
			buttons[2].text = newbind
		"spell4":
			buttons[3].text = newbind
		"spell5":
			buttons[4].text = newbind

func _on_spell_1_pressed():
	Sfx.button_click()
	bind = "spell1"
	change_button_text(bind, "Press a key")
	disable_buttons(1)


func _on_spell_2_pressed():
	Sfx.button_click()
	bind = "spell2"
	change_button_text(bind, "Press a key")
	disable_buttons(2)


func _on_spell_3_pressed():
	Sfx.button_click()
	bind = "spell3"
	change_button_text(bind, "Press a key")
	disable_buttons(3)


func _on_spell_4_pressed():
	Sfx.button_click()
	bind = "spell4"
	change_button_text(bind, "Press a key")
	disable_buttons(4)


func _on_spell_5_pressed():
	Sfx.button_click()
	bind = "spell5"
	change_button_text(bind, "Press a key")
	disable_buttons(5)
	
func disable_buttons(index):
	for i in range(buttons.size()):
		if not i == index-1:
			buttons[i].disabled = true
			
func enable_buttons():
	for button in buttons:
		button.disabled = false
