extends Node

var Cards = [
	new_card("Fireball", "Big fiery ball with 0.5s cooldown and 30 damage", "res://scenes/projectiles/basic_fire/fireball.png", "unlock_spell", "basic_fire"),
	new_card("Rock throw", "Lava flows, you burn", "res://scenes/projectiles/basic.png", "unlock_spell", "basic_earth"),
	new_card("Water arrow", "Get wet ;)", "res://scenes/projectiles/basic.png", "unlock_spell", "basic_water"),
	new_card("Air bolt", "INCOMIIIING", "res://scenes/projectiles/basic.png", "unlock_spell", "basic_air"),
]

func new_card(card_name: String, card_desc: String, card_image: String, unlock: String, value):
	var card: Card = Card.new()
	card.card_name = card_name
	card.card_desc = card_desc
	card.card_image = card_image
	card.card_unlock = unlock
	card.card_value = value
	return card
