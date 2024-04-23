extends Resource
class_name Stats

var max_health : int = 100
var current_health : int = 100
var max_mana : float = 100
var current_mana : float = 100
var mana_regen : float = 20
var damage_multiplier : float = 1
var damage_reduction : float = 1
var speed_multiplier : float = 1
var cooldown_reduction : float = 1
var spells = ["basic", "wind_wall", null, null, null]
var is_shielded : bool = false
var win_count: int = 0
