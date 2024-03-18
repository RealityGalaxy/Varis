extends Node

var Cards = [
	new_card("Fireball", "Launch a big high damage fireball", "res://scenes/projectiles/basic_fire/fireball.png", "unlock_spell", "basic_fire"),
	new_card("Rock throw", "Quickly throw many small rocks", "res://scenes/projectiles/basic_earth/rock_throw.png", "unlock_spell", "basic_earth"),
	new_card("Water arrow", "Shoot a long thin arrow of water", "res://scenes/projectiles/basic_water/water_arrow.png", "unlock_spell", "basic_water"),
	new_card("Air bolt", "Release bolts of air", "res://scenes/projectiles/basic_air/air_bolt.png", "unlock_spell", "basic_air"),
]

func new_card(card_name: String, card_desc: String, card_image: String, unlock: String, value):
	var card: Card = Card.new()
	card.card_name = card_name
	card.card_desc = card_desc
	card.card_image = card_image
	card.card_unlock = unlock
	card.card_value = value
	return card
