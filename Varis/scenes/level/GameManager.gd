extends Node2D

@onready var text = $TimerText
@onready var timer_round_start = $Timers/RoundStart
@onready var timer_winner = $Timers/DisplayWinner
@onready var dim = $Dim

var time_left: float = 3
var text_size: float = 80

func _ready():
	StatManager.restart()
	start_round()
	
func _process(delta):
	if not timer_round_start.is_stopped():
		var new_time = ceil(timer_round_start.time_left)
		text.add_theme_font_size_override("font_size", 80)
		text_size -= 20 * delta
		if new_time != time_left:
			time_left = new_time
			text_size = 80
		text.add_theme_font_size_override("font_size", ceil(text_size))
		text.text = str(new_time)

func start_round():
	timer_round_start.start()
	
func show_cards():
	pass
	

func show_player_win(loser_num):
	timer_winner.start()
	var winner = GameStatus.winner(loser_num)
	text.text = "Player %d has won" % winner
	text.visible = true

func restart_round():
	pass

func _on_timer_timeout():
	GameStatus.pause_time = false
	text.visible = false


func _on_display_winner_timeout():
	GameStatus.pause_time = true
	text.visible = false
	var tween = create_tween()
	tween.tween_property(dim, "modulate", Color(0,0,0,0.5), 1)
	await tween.finished
	spawn_card()

func spawn_card():
	var card : Card = CardData.Cards.pick_random()
	var card_scene = preload("res://scenes/menus/round_pick/card.tscn")
	var card_obj = card_scene.instantiate()
	card_obj.get_node("CardName").text = card.card_name
	card_obj.get_node("CardEffect").text = card.card_desc
	card_obj.get_node("CardImage").texture = load(card.card_image)
	card_obj.position = Vector2(700,1500)
	$Cards.add_child(card_obj)
	var tween = create_tween()
	tween.tween_property(card_obj, "position", Vector2(400, 400), 2)
	
