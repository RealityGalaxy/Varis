extends CharacterBody2D

class_name PlayerChar

signal use_spell(spell: String, player: int, position: Vector2, mouse_position: Vector2)

signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal mana_changed(new_mana)
signal max_mana_changed(new_max_mana)

@export var player_num: int = 1
var projectiles = []
var speed: int = 500
var dash_speed: int = 3000
var jump_speed: int = -1000
var double_jump_speed: int = -700
var jumps_left: int = 2
var gravity = 2400
var direction = 0
var acceleration = 0.3
var friction = 0.6
var vel: Vector2 = Vector2.ZERO
@onready var healthbar = $Healthbar
@onready var manabar = $Manabar
@onready var anim = $AnimatedSprite2D
var speedmult = 1

func _ready():
	var stats = StatManager.get_player_stats(player_num)
	healthbar._init_healthbar(stats.current_health, stats.max_health)
	manabar._init_healthbar(stats.current_mana, stats.max_mana)
	anim.play("player1" if player_num == 1 else "player2")
	set_collision_layer_value(player_num, true)
	$"../../GameManager/SpellUI".get_children()[1 if player_num == 1 else 0].get_child(2).visible = false
	speedmult = 0.8 if scale.x == 0.4 else 1

func get_input():
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
		anim.flip_h = true if player_num == 1 else false
		anim.offset.x = 75 if player_num == 1 else 0
	if Input.is_action_pressed("right"):
		direction = 1
		anim.flip_h = false if player_num == 1 else true
		anim.offset.x = 0 if player_num == 1 else 75
	if Input.is_action_pressed("spell1"):
		rpc("UseProjectile1", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))
	if Input.is_action_pressed("spell2"):
		rpc("UseProjectile2", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))
	if Input.is_action_pressed("spell3"):
		rpc("UseProjectile3", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))
	if Input.is_action_pressed("spell4"):
		rpc("UseProjectile4", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))
	if Input.is_action_pressed("spell5"):
		rpc("UseProjectile5", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))
	if Input.is_action_pressed("dash"):
		if $Cooldowns/Dash.is_stopped():
			$Cooldowns/Dash.start()
			dash()
	#if Input.is_action_pressed("spell3"):
	#	rpc("UseProjectile6", get_global_mouse_position(), hash(Time.get_unix_time_from_system()))

func dash():
	vel.x += direction * dash_speed * speedmult

@rpc("call_local")
func UseProjectile1(mouse_pos: Vector2, hash_id: int):
	if not $Cooldowns/Common.is_stopped():
		return
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[0]:
		return
	var mana_cost = SpellData.Spells[spells[0]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD1.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD1.start(SpellData.Spells[spells[0]].cooldown)
			$Cooldowns/Common.start(min(0.5, SpellData.Spells[spells[0]].cooldown/2))
			use_mana(SpellData.Spells[spells[0]].mana_cost)
			use_spell.emit(spells[0], player_num, position, mouse_pos, hash_id)


@rpc("call_local")
func UseProjectile2(mouse_pos: Vector2, hash_id: int):
	if not $Cooldowns/Common.is_stopped():
		return
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[1]:
		return
	var mana_cost = SpellData.Spells[spells[1]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD2.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD2.start(SpellData.Spells[spells[1]].cooldown)
			$Cooldowns/Common.start(min(0.5, SpellData.Spells[spells[1]].cooldown/2))
			use_mana(SpellData.Spells[spells[1]].mana_cost)
			use_spell.emit(spells[1], player_num, position, mouse_pos, hash_id)
			

@rpc("call_local")
func UseProjectile3(mouse_pos: Vector2, hash_id: int):
	if not $Cooldowns/Common.is_stopped():
		return
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[2]:
		return
	var mana_cost = SpellData.Spells[spells[2]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD3.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD3.start(SpellData.Spells[spells[2]].cooldown)
			$Cooldowns/Common.start(min(0.5, SpellData.Spells[spells[2]].cooldown/2))
			use_mana(SpellData.Spells[spells[2]].mana_cost)
			use_spell.emit(spells[2], player_num, position, mouse_pos, hash_id)
		
		
@rpc("call_local")
func UseProjectile4(mouse_pos: Vector2, hash_id: int):
	if not $Cooldowns/Common.is_stopped():
		return
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[3]:
		return
	var mana_cost = SpellData.Spells[spells[3]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD4.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD4.start(SpellData.Spells[spells[3]].cooldown)
			$Cooldowns/Common.start(min(0.5, SpellData.Spells[spells[3]].cooldown/2))
			use_mana(SpellData.Spells[spells[3]].mana_cost)
			use_spell.emit(spells[3], player_num, position, mouse_pos, hash_id)
			
			
@rpc("call_local")
func UseProjectile5(mouse_pos: Vector2, hash_id: int):
	if not $Cooldowns/Common.is_stopped():
		return
	var spells = StatManager.get_player_stats(player_num).spells
	if not spells[4]:
		return
	var mana_cost = SpellData.Spells[spells[4]].mana_cost
	var current_mana = StatManager.get_player_stats(player_num).current_mana
	if($Cooldowns/CD5.is_stopped() && current_mana >= mana_cost):
			$Cooldowns/CD5.start(SpellData.Spells[spells[4]].cooldown)
			$Cooldowns/Common.start(min(0.5, SpellData.Spells[spells[4]].cooldown/2))
			use_mana(SpellData.Spells[spells[4]].mana_cost)
			use_spell.emit(spells[4], player_num, position, mouse_pos, hash_id)

func _physics_process(delta):
	if !is_multiplayer_authority() or GameStatus.pause_time or StatManager.get_player_stats(player_num).current_health <= 0:
		return
		
	GameStatus.set_player(player_num)
	
	rpc("regen_mana", delta)
		
	get_input()
	
	if is_on_floor() or is_on_ceiling():
		jumps_left = 2 if is_on_floor() else jumps_left
		vel.y = 0
		
	vel.y += gravity * delta
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jumps_left -= 1
			vel.y = jump_speed * speedmult
		elif jumps_left > 0:
			jumps_left -= 2
			
			if vel.y < double_jump_speed * speedmult:
				vel.y -= abs(double_jump_speed * speedmult) / (abs(vel.y)+(4000 * speedmult)) * abs(double_jump_speed * speedmult)
			else:
				vel.y += double_jump_speed * speedmult
				vel.y = clamp(vel.y, jump_speed * speedmult, double_jump_speed * speedmult)
	
	if direction != 0:
		vel.x = lerp(vel.x, direction * speed * speedmult * StatManager.get_player_stats(player_num).speed_multiplier, acceleration)
	else:
		vel.x = lerp(vel.x, 0.0, friction)
	
	velocity = vel
	move_and_slide()

func set_stats(player_number: int, stats):
	StatManager.set_player_stats(player_number, dict_to_inst(stats))

@rpc("any_peer", "call_local")
func unlock_spell(spell: String):
	var stats = StatManager.get_player_stats(player_num)
	for i in 5:
		if stats.spells[i] == null:
			stats.spells[i] = spell
			var list = $"../../GameManager/SpellUI".get_children()[player_num-1]
			list.changeImage(i+1, SpellData.Spells[stats.spells[i]].image_path)
			break
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func regen_mana(delta):
	var stats = StatManager.get_player_stats(player_num)
	var prev_mana = stats.current_mana
	stats.current_mana = min(stats.current_mana + delta * stats.mana_regen, stats.max_mana)
	if prev_mana == stats.current_mana:
		return
	emit_signal("mana_changed", stats.current_mana)
	set_stats(player_num, inst_to_dict(stats))

func take_damage(damage: int, id):
	rpc("take_damage_rpc", damage, id)

@rpc("any_peer", "call_local")
func take_damage_rpc(damage: int, id):
	if projectiles.has(id):
		return
	var projs = $"../../SpellManager/Projectiles".get_children()
	for proj in projs:
		if proj.id == id:
			proj.queue_free()
	projectiles.push_back(id)
	var stats = StatManager.get_player_stats(player_num)
	# so that damage reduction would go from 1 to 2 :shrug:
	
	if stats.is_shielded:
		stats.is_shielded = false
		set_stats(player_num, inst_to_dict(stats))
		$CollisionShape2D.get_child(0).destroy()
		return
	
	var actual_damage = damage * (2 - stats.damage_reduction)
	if actual_damage > 0:
		stats.current_health -= actual_damage
		emit_signal("health_changed", stats.current_health)
		if stats.current_health <= 0:
			stats.current_health = 0
			$CPUParticles2D.emitting = true
			visible = false
			get_parent().get_parent().get_child(0).show_player_win(player_num)
	set_stats(player_num, inst_to_dict(stats))

func handle_card(card: Card):
	print(inst_to_dict(card))
	var mode = card.card_unlock
	match mode:
		"damage":
			rpc("increase_damage", card.card_value)
		"reduction":
			rpc("increase_reduction", card.card_value)
		"speed":
			rpc("increase_speed", card.card_value)
		"cdr":
			rpc("increase_cooldown", card.card_value)
		"max_health":
			rpc("increase_max_health", card.card_value)
		"max_mana":
			rpc("increase_max_mana", card.card_value)
		"unlock_spell":
			rpc("unlock_spell", card.card_value)

@rpc("any_peer", "call_local")
func increase_damage(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_multiplier += amount
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func increase_reduction(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.damage_reduction += amount
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func increase_speed(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.speed_multiplier += amount
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func increase_cooldown(amount: float):
	var stats = StatManager.get_player_stats(player_num)
	stats.cooldown_reduction += amount
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func increase_max_health(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.max_health += amount
	stats.current_health += amount
	emit_signal("max_health_changed", stats.max_health)
	emit_signal("health_changed", stats.current_health)
	set_stats(player_num, inst_to_dict(stats))

func use_mana(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.current_mana -= amount
	emit_signal("mana_changed", stats.current_mana)
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func increase_max_mana(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.max_mana += amount
	emit_signal("max_mana_changed", stats.max_mana)
	set_stats(player_num, inst_to_dict(stats))

@rpc("any_peer", "call_local")
func heal(amount: int):
	var stats = StatManager.get_player_stats(player_num)
	stats.current_health = clamp(stats.current_health + amount, 0, stats.max_health)
	emit_signal("health_changed", stats.current_health)
	set_stats(player_num, inst_to_dict(stats))

func receive_shield(status: bool):
	rpc("shield", status)

@rpc("any_peer", "call_local")
func shield(status: bool):
	var stats = StatManager.get_player_stats(player_num)
	stats.is_shielded = status
	set_stats(player_num, inst_to_dict(stats))
	
