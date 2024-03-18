extends Control



func _on_mouse_entered():
	if GameStatus.current_player == GameStatus.winner_num:
		$Inside.color = Color("816741")


func _on_mouse_exited():
	if GameStatus.current_player == GameStatus.winner_num:
		$Inside.color = Color("634e2f")
