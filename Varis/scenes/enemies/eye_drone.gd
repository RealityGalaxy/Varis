extends CharacterBody2D

var movement_speed: float = 200.0
var damage: int = 10

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var player = null
var extra_vel = Vector2.ZERO

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	await get_tree().create_timer(1).timeout
	player = $"../MultiplayerSpawner".get_child(0)
	set_movement_target(player.position)
	

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

var next_rotation = null

func _physics_process(delta):
	if player == null:
		return

	set_movement_target(player.position)
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
