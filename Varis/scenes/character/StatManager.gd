extends Node

var players = []

func add_player(num: int):
	var stats: Stats = Stats.new()
	players.push_back(stats)
	
func get_player_stats(player_num: int) -> Stats: 
	return players[player_num-1]

func set_player_stats(player_num: int, stats: Stats):
	players[player_num-1] = stats
