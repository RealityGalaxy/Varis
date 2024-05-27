extends Area2D

class_name Projectile

@export var travel_speed = 600
@export var damage = 10
var id
var player = -1
var hit_sfx = preload("res://audio/sfx/Hit.wav")


func _physics_process(delta):
	position += transform.x * travel_speed * delta

func _on_body_entered(body):
	if (body is PlayerChar and body.player_num != player) or not body is PlayerChar:
		if body is PlayerChar:
			var audio_player = AudioStreamPlayer.new()
			audio_player.stream = hit_sfx
			add_child(audio_player)
			audio_player.play()
			
			body.take_damage(damage, id)
		queue_free()
