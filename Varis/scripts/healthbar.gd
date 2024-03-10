extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $Damagebar

var health = 0 

func _init_healthbar(_health, _max_health):
	health = _health
	max_value = _max_health
	value = health
	damage_bar.max_value = _max_health
	damage_bar.value = health

func _set_health(new_health):
	var prev_health = health
	print("New health: ", new_health)
	health = new_health
	value = health
	
	if health <= 0: # Dies, healthbar uneccessary (might as well remove this and remove char)
		queue_free()
	
	# If damaged
	if health < prev_health: 
		timer.start()
	# Heals or anything else
	else: 
		damage_bar.value = health

func _set_max_health(new_max_health):
	max_value = new_max_health
	damage_bar.max_value = new_max_health

func _on_timer_timeout(): # Updates damage bar to match health bar
	var tween = create_tween()
	tween.tween_property(damage_bar, "value", health, 0.15) # Topping the tweenks :3
