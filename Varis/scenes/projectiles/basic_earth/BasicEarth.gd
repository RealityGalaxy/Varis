extends Area2D

@export var travel_speed = 600
@export var damage = 10
var player = -1

func _physics_process(delta):
	position += transform.x * travel_speed * delta
	
func sub_tick(time: float):
	position += transform.x * travel_speed * time

func _on_body_entered(body):
	if (body is PlayerChar and body.player_num != player) or not body is PlayerChar:
		if body is PlayerChar:
			body.take_damage(damage)
		queue_free()
