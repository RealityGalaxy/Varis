extends Control

signal card_clicked(event: InputEvent, card_data: Card)

var card: Card



func _on_mouse_entered():
	if GameStatus.current_player != GameStatus.winner_num:
		$Inside.color = Color("816741")


func _on_mouse_exited():
	if GameStatus.current_player != GameStatus.winner_num:
		$Inside.color = Color("634e2f")


func _on_gui_input(event):
	if GameStatus.current_player != GameStatus.winner_num:
		card_clicked.emit(event, card)
