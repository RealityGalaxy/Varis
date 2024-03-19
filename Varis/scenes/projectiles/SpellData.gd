extends Node

var Spells = {
	"basic":new_spell("basic", 0.2, "res://scenes/projectiles/projectile.tscn", 5, 10),
	"basic_earth":new_spell("basic_earth", 0.15, "res://scenes/projectiles/projectile.tscn", 3, 5),
	"basic_air":new_spell("basic_air", 0.4, "res://scenes/projectiles/projectile.tscn", 15, 20),
	"basic_fire":new_spell("basic_fire", 1, "res://scenes/projectiles/projectile.tscn", 30, 40),
	"basic_water":new_spell("basic_water", 0.5, "res://scenes/projectiles/projectile.tscn", 15, 20),
	"air_gate":new_spell("air_gate", 5, "res://scenes/spells/air_gate/air_gate.tscn", 0, 50),
}

func new_spell(spell_name: String, cooldown: float, spell_file: String, damage: int, cost: int):
	var spell: Spell = Spell.new()
	spell.spell_name = spell_name
	spell.cooldown = cooldown
	spell.spell_file = spell_file
	spell.base_damage = damage
	spell.mana_cost = cost
	return spell
