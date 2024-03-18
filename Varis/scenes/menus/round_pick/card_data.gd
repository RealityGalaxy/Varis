extends Node

var Cards = [
	new_card("Fireball", "Big fiery ball with 0.5s cooldown and 30 damage", "res://icon.svg"),
	new_card("Lava", "Lava flows, you burn", "res://icon.svg"),
	new_card("Watery boi", "Get wet ;)", "res://icon.svg"),
	new_card("Air strike", "INCOMIIIING", "res://icon.svg"),
]

func new_card(card_name: String, card_desc: String, card_image: String):
	var card: Card = Card.new()
	card.card_name = card_name
	card.card_desc = card_desc
	card.card_image = card_image
	return card
