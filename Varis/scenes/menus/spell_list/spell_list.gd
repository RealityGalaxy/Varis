extends Control


func _ready():
	for n in range(1, 6):
		changeLabel(n, translate(InputMap.action_get_events("spell%d" % n)[0].as_text()))

func translate(hotkey: String):
	if hotkey.ends_with("Mouse Button"):
		return hotkey[0] + "MB"
	if hotkey.ends_with("(Physical)"):
		return hotkey.trim_suffix("(Physical)")
	return hotkey

func changeImage(id, _path):
	var image
	match id:
		2: image = $Images/Image2
		3: image = $Images/Image3
		4: image = $Images/Image4
		5: image = $Images/Image5
		_: image = $Images/Image1
	
	image.texture = load(_path)
	image.visible = true

func changeLabel(id, _text):
	var label
	match id:
		2: label = $Labels/Label2
		3: label = $Labels/Label3
		4: label = $Labels/Label4
		5: label = $Labels/Label5
		_: label = $Labels/Label1
	
	label.text = _text
