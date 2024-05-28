extends CharacterBody2D

var movement_speed: float = 200.0
var damage: int = 10
var health: int = 50
var max_health: int = 50

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var player = null
var extra_vel = Vector2.ZERO

func flash_red():
	await create_tween().tween_property(self, 'modulate', Color(1, 0.6, 0.6), 0.1).finished
	create_tween().tween_property(self, 'modulate', Color.WHITE, 0.1)

func _ready():
	health = max_health
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

var dead = false

func take_damage(damage: int, direction: Vector2):
	extra_vel += damage * direction * 80
	health -= damage
	if(health <= 0):
		die()
	else:
		flash_red()



func die():
	get_parent().get_parent().add_score(max_health)
	dead = true
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)
	await create_tween().tween_property(self, 'modulate', Color.TRANSPARENT, 0.5).finished
	queue_free()

func actor_setup():
	await get_tree().physics_frame
	await get_tree().create_timer(1).timeout
	player = $"../../../MultiplayerSpawner".get_child(0)
	set_movement_target(player.position)
	

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

var next_rotation = null

func get_target():
	var closest = Vector2(0,0)
	var dist = 1000000
	for i in range($"../../../MultiplayerSpawner".get_child_count()):
		var play = $"../../../MultiplayerSpawner".get_child(i)
		if play.position.distance_to(position) < dist and StatManager.get_player_stats(i+1).current_health > 0:
			dist = play.position.distance_to(position)
			closest = play.position
	return closest

func _physics_process(delta):
	if player == null or GameStatus.pause_time or dead:
		return

	set_movement_target(get_target())
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	if extra_vel != Vector2(0,0):
		extra_vel = lerp(extra_vel, Vector2(0,0), 0.1)
	
	next_rotation = current_agent_position.angle_to_point(next_path_position)
	
	rotation = lerp(rotation, next_rotation, 5 * delta)
	
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed + extra_vel
	move_and_slide()

var times_damaged = 0

func _on_area_2d_body_entered(body):
	if body is PlayerChar:
		body.take_damage(10, get_instance_id() + times_damaged)
		times_damaged += 1
		body.extra_vel += Vector2(position.direction_to(body.position) * 1200)
		extra_vel = Vector2(body.position.direction_to(position) * 1000)


func _on_timer_timeout():
	if player == null:
		return


func _on_area_2d_area_entered(area):
	if area.is_in_group("projectile"):
		take_damage(area.damage, area.position.direction_to(position))
		area.queue_free()
