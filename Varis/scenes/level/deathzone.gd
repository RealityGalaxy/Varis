extends Area2D

signal touched_deathzone

func _on_body_entered(body):
	touched_deathzone.emit()
	body.queue_free()
