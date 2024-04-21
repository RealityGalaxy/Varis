extends Area2D

signal touched_deathzone

func _on_body_entered(body):
	touched_deathzone.emit()
	if body is PlayerChar:
		$"../GameManager".show_player_win(body.player_num)
	else:
		body.queue_free()
