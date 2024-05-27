extends Area2D

class_name Projectile

@export var travel_speed = 600
@export var damage = 10
var id
var player = -1


func _physics_process(delta):
	position += transform.x * travel_speed * delta

func _on_body_entered(body):
	if (body is PlayerChar and body.player_num != player) or not body is PlayerChar:
		if body is PlayerChar:
			Sfx.hit()
			
			body.take_damage(damage, id)
		queue_free()
