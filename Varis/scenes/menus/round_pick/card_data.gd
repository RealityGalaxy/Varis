extends Node

var Cards = [
	new_card("Fireball", "Launch a big high damage fireball", "res://graphics/projectiles/basic_fire.png", "unlock_spell", "basic_fire"),
	new_card("Rock throw", "Quickly throw many small rocks", "res://graphics/projectiles/basic_earth.png", "unlock_spell", "basic_earth"),
	new_card("Water arrow", "Shoot a long thin arrow of water", "res://scenes/projectiles/basic_water/water_arrow.png", "unlock_spell", "basic_water"),
	new_card("Air bolt", "Release bolts of air", "res://graphics/projectiles/air_bolt.png", "unlock_spell", "basic_air"),
	new_card("Powerfull spells", "Increase damage by 20%", "res://icon.svg", "damage", 0.2),
	new_card("Nimble feet", "Increase movement speed by 10%", "res://icon.svg", "speed", 0.1),
	new_card("Tough skin", "Decrease damage taken by 10%", "res://icon.svg", "reduction", 0.1),
	new_card("Big brain", "Increase maximum mana by 30", "res://icon.svg", "max_mana", 30),
	new_card("Bloody heart", "Increase maximum health by 30", "res://icon.svg", "max_health", 30),
	new_card("Quickshot", "Decrease cooldowns by 15%", "res://icon.svg", "cdr", -0.15),
	new_card("Why?", "Decrease damage by 10%", "res://icon.svg", "damage", -0.1),
]

func new_card(card_name: String, card_desc: String, card_image: String, unlock: String, value):
	var card: Card = Card.new()
	card.card_name = card_name
	card.card_desc = card_desc
	card.card_image = card_image
	card.card_unlock = unlock
	card.card_value = value
	return card
