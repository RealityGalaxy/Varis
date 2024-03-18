extends Node

var pause_time: bool = true
var players = []

func winner(num):
	for i in players.size():
		if players[i] != num:
			return players[i]
	return 1
