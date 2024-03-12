extends CharacterBody2D

class_name PlayerChar

signal use_spell(spell: String, player: int, position: Vector2, mouse_position: Vector2)

signal health_changed(new_health)
signal max_health_changed(new_max_health)

@export var player_num: int = 1
var speed: int = 400
var jump_speed: int = -1000
var double_jump_speed: int = -700
var jumps_left: int = 2
var gravity = 2000
var vel: Vector2 = Vector2.ZERO
@onready var healthbar = $Healthbar

func _ready():
	var stats = StatManager.get_player_stats(player_num)
	healthbar._init_healthbar(stats.current_health, stats.max_health)
	

func get_input():
	var spells = StatManager.get_player_stats(player_num).spells
	vel.x = 0
	if Input.is_action_pressed("right"):
		vel.x += speed
	if Input.is_action_pressed("left"):
		vel.x -= speed
	if Input.is_action_pressed("spell1"):
		if($Cooldowns/CD1.is_stopped() && spells[0]):
			$Cooldowns/CD1.start(SpellData.Spells[spells[0]].cooldown)
			use_spell.emit(spells[0], player_num, position, get_global_mouse_position())
	if Input.is_action_pressed("spell2"):
		if($Cooldowns/CD1.is_stopped() && spells[1]):
			$Cooldowns/CD1.start(SpellData.Spells[spells[1]].cooldown)
			use_spell.emit(spells[1], player_num, position, get_global_mouse_position())
	if Input.is_action_pressed("spell3"):
		if($Cooldowns/CD1.is_stopped() && spells[2]):
			$Cooldowns/CD1.start(SpellData.Spells[spells[2]].cooldown)
			use_spell.emit(spells[2], player_num, position, get_global_mouse_position())
	if Input.is_action_pressed("spell4"):
		if($Cooldowns/CD1.is_stopped() && spells[3]):
			$Cooldowns/CD1.start(SpellData.Spells[spells[3]].cooldown)
			use_spell.emit(spells[3], player_num, position, get_global_mouse_position())
	if Input.is_action_pressed("spell5"):
		if($Cooldowns/CD1.is_stopped() && spells[4]):
			$Cooldowns/CD1.start(SpellData.Spells[spells[4]].cooldown)
			use_spell.emit(spells[4], player_num, position, get_global_mouse_position())

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	get_input()
	
	if is_on_floor() or is_on_ceiling():
		jumps_left = 2 if is_on_floor() else jumps_left
		vel.y = 0
		
	vel.y += gravity * delta
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jumps_left -= 1
			vel.y = jump_speed
		elif jumps_left > 0:
			jumps_left -= 2
			
			if vel.y < double_jump_speed:
				vel.y -= abs(double_jump_speed) / (abs(vel.y)+4000) * abs(double_jump_speed)
			else:
				vel.y += double_jump_speed
				vel.y = clamp(vel.y, jump_speed, double_jump_speed)
			
	velocity = vel
	move_and_slide()

func take_damage(damage):
	var stats = StatManager.get_player_stats(player_num)
	# so that damage reduction would go from 1 to 2 :shrug:
	var actual_damage = damage * (2 - stats.damage_reduction)
	if actual_damage > 0:
		stats.current_health -= actual_damage
		emit_signal("health_changed", stats.current_health)
		if stats.current_health < 0:
			stats.current_health = 0
	StatManager.set_player_stats(player_num, stats)

func increase_damage(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_multiplier += amount
	StatManager.set_player_stats(player_num, stats)

func increase_reduction(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_reduction += amount
	StatManager.set_player_stats(player_num, stats)

func increase_speed(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.speed_multiplier += amount
	StatManager.set_player_stats(player_num, stats)

func increase_cooldown(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.cooldown_reduction += amount
	StatManager.set_player_stats(player_num, stats)
	
func increase_max_health(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.max_health += amount
	emit_signal("max_health_changed", stats.max_health)
	StatManager.set_player_stats(player_num, stats)

func heal(amount):
	var stats = StatManager.get_player_stats(player_num)
	stats.current_health = clamp(stats.current_health + amount, 0, stats.max_health)
	emit_signal("health_changed", stats.current_health)
	StatManager.set_player_stats(player_num, stats)
