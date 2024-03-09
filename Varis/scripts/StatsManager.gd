extends Resource
class_name StatsManager

signal health_changed(new_health)
signal max_health_changed(new_max_health)

var max_health : int = 100
var current_health : int = 100
var damage_multiplier : float = 1
var damage_reduction : float = 1
var speed_multiplier : float = 1
var cooldown_reduction : float = 1

func take_damage(damage):
	# so that damage reduction would go from 1 to 2 :shrug:
	var actual_damage = damage * (2 - damage_reduction)
	if actual_damage > 0:
		current_health -= actual_damage
		health_changed.emit(current_health)
		if current_health < 0:
			current_health = 0
			

func increase_damage(amount):
	damage_multiplier += amount
	
func increase_reduction(amount):
	damage_reduction += amount

func increase_speed(amount):
	speed_multiplier += amount

func increase_cooldown(amount):
	cooldown_reduction += amount
	
func increase_max_health(amount):
	max_health += amount
	emit_signal("max_health_changed", max_health)

func heal(amount):
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health)
