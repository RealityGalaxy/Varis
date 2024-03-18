extends Node

var pause_time: bool = true
var current_player: int = -1
var winner_num: int = -1
var players = []

func set_player(num):
	current_player = num


func winner(num):
	for i in players.size():
		if players[i] != num:
			winner_num = players[i]
			return players[i]
	return 1
