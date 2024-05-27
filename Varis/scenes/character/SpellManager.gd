extends Node2D

var scaleOffset

func _ready():
	scaleOffset = 1 if GameStatus.players.size() == 2 else 0.8
	pass

func on_spell_fire(spell: String, player: int, pos: Vector2, mouse_position: Vector2, hash_id: int):
	match spell:
		'basic':
			Sfx.spell_basic()
			basic(pos, mouse_position, player, spell, hash_id)
		'basic_fire':
			Sfx.spell_fire()
			fire_basic(pos, mouse_position, player, spell, hash_id)
		'basic_air':
			Sfx.spell_air()
			air_basic(pos, mouse_position, player, spell, hash_id)
		'basic_earth':
			Sfx.spell_earth()
			earth_basic(pos, mouse_position, player, spell, hash_id)
		'basic_water':
			Sfx.spell_water()
			water_basic(pos, mouse_position, player, spell, hash_id)
		'shield':
			Sfx.spell_shield()
			shield(player, spell)
		"wind_wall":
			Sfx.spell_windwall()
			windwall(pos, mouse_position, player, spell, hash_id)
		_:
			print('weird shit happened : '+spell)

func basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.id = hash_id
	projectile.position = pos
	projectile.scale = projectile.scale * scaleOffset
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)

func fire_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_fire/basicfire.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.id = hash_id
	projectile.position = pos
	projectile.scale = projectile.scale * scaleOffset
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
	
func air_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_air/basicair.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.id = hash_id
	projectile.position = pos
	projectile.scale = projectile.scale * scaleOffset
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
	
func water_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_water/basicwater.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.id = hash_id
	projectile.position = pos
	projectile.scale = projectile.scale * scaleOffset
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
	
func earth_basic(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var projectile_scene: PackedScene = preload("res://scenes/projectiles/basic_earth/basicearth.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.id = hash_id
	projectile.position = pos
	projectile.scale = projectile.scale * scaleOffset
	projectile.player = player_num
	projectile.damage = SpellData.Spells[spell].base_damage * StatManager.get_player_stats(player_num).damage_multiplier
	projectile.look_at(mouse_position)
	$Projectiles.add_child(projectile)
	
func shield(player_num: int, spell: String):
	var shield_scene: PackedScene = preload("res://scenes/spells/shield/shield.tscn")
	var shield = shield_scene.instantiate()
	
	var player = $"../MultiplayerSpawner".get_child(player_num-1)
	
	player.get_child(5).add_child(shield)
	shield.player_id = player_num
	shield.connect("shield_change", player.receive_shield)


func windwall(pos: Vector2, mouse_position: Vector2, player_num: int, spell: String, hash_id):
	var wall_scene: PackedScene = preload("res://scenes/spells/wall/wall.tscn")
	var wall = wall_scene.instantiate()
	
	var player = $"../MultiplayerSpawner".get_child(player_num - 1)
	
	wall.position = mouse_position
	$Spells.add_child(wall)
