extends Node2D

func on_spell_fire(spell: String, player: int, pos: Vector2, mouse_position: Vector2):
	match spell:
		'basic':
			fire_basic(pos, mouse_position, player)
		_:
			print('weird shit happened : '+spell)

func fire_basic(pos: Vector2, mouse_position: Vector2, player_num: int):
	var basic_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
	var basic = $Spawners.get_children()[player_num-1].spawn("res://scenes/projectiles/projectile.tscn")

	basic.position = pos
	basic.player = player_num
	basic.look_at(mouse_position)
	#$Projectiles.add_child(basic)
