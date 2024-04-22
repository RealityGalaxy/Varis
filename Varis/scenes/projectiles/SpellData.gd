extends Node

var Spells = {
	"basic":new_spell("basic", 0.2, "res://scenes/projectiles/projectile.tscn", 5, 10, "res://scenes/projectiles/basic.png"),
	"basic_earth":new_spell("basic_earth", 0.15, "res://scenes/projectiles/projectile.tscn", 3, 5, "res://graphics/projectiles/basic_earth.png"),
	"basic_air":new_spell("basic_air", 0.4, "res://scenes/projectiles/projectile.tscn", 15, 20, "res://graphics/projectiles/basic_air.png"),
	"basic_fire":new_spell("basic_fire", 1, "res://scenes/projectiles/projectile.tscn", 30, 40, "res://graphics/projectiles/basic_fire.png"),
	"basic_water":new_spell("basic_water", 0.5, "res://scenes/projectiles/projectile.tscn", 15, 20, "res://scenes/projectiles/basic_water/water_arrow.png"),
	"air_gate":new_spell("air_gate", 5, "res://scenes/spells/air_gate/air_gate.tscn", 0, 50, "res://scenes/spells/air_gate/Circle_(transparent).png"),
	"shield":new_spell("shield", 7, "res://scenes/spells/shield/shield.tscn", 0, 50, "res://scenes/spells/shield/Ski_trail_rating_symbol_black_circle.png"),
}

func new_spell(spell_name: String, cooldown: float, spell_file: String, damage: int, cost: int, imagePath: String):
	var spell: Spell = Spell.new()
	spell.spell_name = spell_name
	spell.cooldown = cooldown
	spell.spell_file = spell_file
	spell.base_damage = damage
	spell.mana_cost = cost
	spell.image_path =  imagePath
	return spell
