extends CharacterBody2D

var speed: int = 400
var jump_speed: int = -1000
var double_jump_speed: int = -700
var jumps_left: int = 2
var gravity = 2000
var vel: Vector2 = Vector2.ZERO
var stats : StatsManager
@onready var healthbar = $Healthbar

func _ready():
	stats = StatsManager.new()
	healthbar._init_healthbar(stats.current_health, stats.max_health)
	stats.health_changed.connect(healthbar._set_health)
	stats.max_health_changed.connect(healthbar._set_max_health)
	

func get_input():
	vel.x = 0
	if Input.is_action_pressed("right"):
		vel.x += speed
	if Input.is_action_pressed("left"):
		vel.x -= speed

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	get_input()
	
	if is_on_floor() or is_on_ceiling():
		jumps_left = 2 if is_on_floor() else 0
		vel.y = 0
		
	vel.y += gravity * delta
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jumps_left -= 1
			vel.y = jump_speed
		elif jumps_left > 0:
			jumps_left -= 1
			
			if vel.y < double_jump_speed:
				vel.y -= abs(double_jump_speed) / (abs(vel.y)+4000) * abs(double_jump_speed)
			else:
				vel.y += double_jump_speed
				vel.y = clamp(vel.y, jump_speed, double_jump_speed)
			
	velocity = vel
	move_and_slide()
