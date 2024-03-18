extends Node2D

func on_spell_fire(spell: String, player: int, pos: Vector2, mouse_position: Vector2):
	match spell:
		'basic':
			basic(pos, mouse_position, player, spell)
		'basic_fire':
			fire_basic(pos, mouse_position, player, spell)
		'basic_air':
			air_basic(pos, mouse_position, player, spell)
		_:
			print('weird shit happened : '+spell)

func basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.position = pos
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)

func fire_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_fire/basicfire.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.position = pos
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
	
func air_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_air/basicair.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.position = pos
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
