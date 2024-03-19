extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_sprite():
	$Gate.visible = true
	$Ball.visible = false
	$Hitbox.enabled = true

func _on_entered(body):
	if body is PlayerChar or body is Projectile:
		pass
