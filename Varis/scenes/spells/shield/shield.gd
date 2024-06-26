extends Area2D

signal shield_change(status: bool)
var player_id
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.material = load("res://scenes/spells/shield/shield_mat.tres")
	$Sprite.material = $Sprite.material.duplicate()
	set_shader_value(1.0)
	shield_change.emit(true)
	appear()
	$Timer.start()
	
	
func appear():
	var tween = create_tween()
	tween.tween_property($Sprite, "modulate", Color("662dff7a"), 0.12)

func set_shader_value(value: float):
	$Sprite.material.set_shader_parameter("dissolve_value", value)

func expire():
	shield_change.emit(false)
	dissolve()

func dissolve():
	$Timer.stop()
	var tween = create_tween()
	
	tween.tween_method(set_shader_value, $Sprite.material.get_shader_parameter("dissolve_value"), 0.0, 0.5)
	
	await tween.finished
	queue_free()

func _on_timer_timeout():
	expire()


func _on_area_entered(area):
	if area.is_in_group("projectile") and area.player != player_id:
		area.queue_free()
		expire()
