extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

signal character_died

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0: # Dies, healthbar uneccessary
		character_died.emit()
		
	if health < prev_health: # If damaged
		timer.start()
	else: # Heals or anything else
		damage_bar.value = health

func init_health(_health): # Initializing health with given parameter
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout(): # Updates damage bar to match health bar
	damage_bar.value = health
