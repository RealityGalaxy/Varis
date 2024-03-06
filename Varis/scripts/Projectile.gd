extends Area2D

@export var TRAVEL_SPEED = 600
@export var DAMAGE = 10


func _physics_process(delta):
	position += transform.x * TRAVEL_SPEED * delta

func _on_body_entered(body):
	# fill with logic to damage/kill enemies
	
	queue_free()
