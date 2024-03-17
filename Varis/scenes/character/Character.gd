extends CharacterBody2D

class_name PlayerChar

signal use_spell(spell: String, player: int, position: Vector2, mouse_position: Vector2)

signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal mana_changed(new_mana)
signal max_mana_changed(new_max_mana)

@export var player_num: int = 1
var speed: int = 400
var jump_speed: int = -1000
var double_jump_speed: int = -700
var jumps_left: int = 2
var gravity = 2000
var vel: Vector2 = Vector2.ZERO
@onready var healthbar = $Healthbar
@onready var manabar = $Manabar

func _ready():
	var stats = StatManager.get_player_stats(player_num)
	healthbar._init_healthbar(stats.current_health, stats.max_health)
	manabar._init_healthbar(stats.current_mana, stats.max_mana)
	

func get_input():
	vel.x = 0
	if Input.is_action_pressed("right"):
		vel.x += speed
	if Input.is_action_pressed("left"):
		vel.x -= speed
	if Input.is_action_pressed("spell1"):
		rpc("UseProjectile1", get_global_mouse_position(), Time.get_unix_time_from_system())
	if Input.is_action_pressed("spell2"):
		rpc("UseProjectile2", get_global_mouse_position(), Time.get_unix_time_from_system())
	if Input.is_action_pressed("spell3"):
		rpc("UseProjectile3", get_global_mouse_position(), Time.get_unix_time_from_system())
	if Input.is_action_pressed("spell4"):
		rpc("UseProjectile4", get_global_mouse_position(), Time.get_unix_time_from_system())
	if Input.is_action_pressed("spell5"):
		rpc("UseProjectile5", get_global_mouse_position(), Time.get_unix_time_from_system())

@rpc("any_peer", "call_local")
func UseProjectile1(mouse_pos: Vector2, shot_time: float):
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[0]:
		return
	var mana_cost = SpellData.Spells[spells[0]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD1.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD1.start(SpellData.Spells[spells[0]].cooldown)
			use_mana(SpellData.Spells[spells[0]].mana_cost)
			use_spell.emit(spells[0], player_num, position, mouse_pos, shot_time)

@rpc("any_peer", "call_local")
func UseProjectile2(mouse_pos: Vector2, shot_time: float):
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[1]:
		return
	var mana_cost = SpellData.Spells[spells[1]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD2.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD2.start(SpellData.Spells[spells[1]].cooldown)
			use_mana(SpellData.Spells[spells[1]].mana_cost)
			use_spell.emit(spells[1], player_num, position, mouse_pos, shot_time)

@rpc("any_peer", "call_local")
func UseProjectile3(mouse_pos: Vector2, shot_time: float):
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[2]:
		return
	var mana_cost = SpellData.Spells[spells[2]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD3.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD3.start(SpellData.Spells[spells[2]].cooldown)
			use_mana(SpellData.Spells[spells[2]].mana_cost)
			use_spell.emit(spells[2], player_num, position, mouse_pos, shot_time)

@rpc("any_peer", "call_local")
func UseProjectile4(mouse_pos: Vector2, shot_time: float):
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[3]:
		return
	var mana_cost = SpellData.Spells[spells[3]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD4.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD4.start(SpellData.Spells[spells[3]].cooldown)
			use_mana(SpellData.Spells[spells[3]].mana_cost)
			use_spell.emit(spells[3], player_num, position, mouse_pos, shot_time)

@rpc("any_peer", "call_local")
func UseProjectile5(mouse_pos: Vector2, shot_time: float):
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[4]:
		return
	var mana_cost = SpellData.Spells[spells[4]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD5.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD5.start(SpellData.Spells[spells[4]].cooldown)
			use_mana(mana_cost)
			use_spell.emit(spells[4], player_num, position, mouse_pos, shot_time)

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	regen_mana(delta)
	
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

@rpc("any_peer", "call_local")
func set_stats(player_num: int, stats: Stats):
	StatManager.set_player_stats(player_num, stats)

func unlock_spell(spell: String):
	var stats = StatManager.get_player_stats(player_num)
	for i in 5:
		if stats.spells[i] == null:
			stats.spells[i] = spell
			break
	rpc("set_stats", player_num, stats)

func regen_mana(delta):
	var stats = StatManager.get_player_stats(player_num)
	var prev_mana = stats.current_mana
	stats.current_mana = min(stats.current_mana + delta * stats.mana_regen, stats.max_mana)
	if prev_mana == stats.current_mana:
		return
	emit_signal("mana_changed", stats.current_mana)
	rpc("set_stats", player_num, stats)

func take_damage(damage: int):
	var stats = StatManager.get_player_stats(player_num)
	# so that damage reduction would go from 1 to 2 :shrug:
	var actual_damage = damage * (2 - stats.damage_reduction)
	if actual_damage > 0:
		stats.current_health -= actual_damage
		emit_signal("health_changed", stats.current_health)
		if stats.current_health < 0:
			stats.current_health = 0
	rpc("set_stats", player_num, stats)

func increase_damage(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_multiplier += amount
	rpc("set_stats", player_num, stats)

func increase_reduction(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_reduction += amount
	rpc("set_stats", player_num, stats)

func increase_speed(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.speed_multiplier += amount
	rpc("set_stats", player_num, stats)

func increase_cooldown(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.cooldown_reduction += amount
	rpc("set_stats", player_num, stats)
	
func increase_max_health(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.max_health += amount
	emit_signal("max_health_changed", stats.max_health)
	rpc("set_stats", player_num, stats)

func use_mana(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.current_mana -= amount
	emit_signal("mana_changed", stats.current_mana)
	rpc("set_stats", player_num, stats)

func increase_max_mana(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.max_mana += amount
	emit_signal("max_mana_changed", stats.max_mana)
	rpc("set_stats", player_num, stats)

func heal(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.current_health = clamp(stats.current_health + amount, 0, stats.max_health)
	emit_signal("health_changed", stats.current_health)
	rpc("set_stats", player_num, stats)
