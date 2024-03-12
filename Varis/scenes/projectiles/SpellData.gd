extends Node

var Spells = {
	"basic":new_spell("basic", 0.2, "res://scenes/projectiles/projectile.tscn"),
	"basic_earth":new_spell("basic_earth", 0.2, "res://scenes/projectiles/projectile.tscn"),
	"basic_air":new_spell("basic_air", 0.4, "res://scenes/projectiles/projectile.tscn"),
	"basic_fire":new_spell("basic_fire", 1, "res://scenes/projectiles/projectile.tscn"),
	"basic_water":new_spell("basic_water", 0.5, "res://scenes/projectiles/projectile.tscn"),
}

func new_spell(name: String, cooldown: float, spell_file: String):
	var spell: Spell = Spell.new()
	spell.spell_name = name
	spell.cooldown = cooldown
	spell.spell_file = spell_file
	return spell
