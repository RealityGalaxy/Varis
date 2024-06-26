extends Node

var pause_time: bool = true
var current_player: int = -1
var winner_num: int = -1
var loser_num: int = -1
var players = []

func reset():
	pause_time = true
	current_player = -1
	winner_num = -1
	loser_num = -1
	players = []

func reset_players():
	players = []

func set_player(num):
	current_player = num

func winner(num):
	winner_num = players[0] if num == players[1] else players[1]
	loser_num = players[0] if num == players[0] else players[1]
	return winner_num
