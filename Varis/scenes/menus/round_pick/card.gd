extends Control

signal card_clicked(event: InputEvent, card_data: Card, index)

var card: Card
var index: int



func _on_mouse_entered():
	if GameStatus.current_player != GameStatus.winner_num:
		$CardUi.modulate = Color("816741")


func _on_mouse_exited():
	if GameStatus.current_player != GameStatus.winner_num:
		$CardUi.modulate = Color("634e2f")


func _on_gui_input(event):
	if GameStatus.current_player != GameStatus.winner_num:
		card_clicked.emit(event, card, index)
