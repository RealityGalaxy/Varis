extends Node2D

@onready var text = $TimerText
@onready var timer_round_start = $Timers/RoundStart
@onready var timer_winner = $Timers/DisplayWinner
@onready var timer_movement = $Timers/Movement
@onready var dim = $Dim

var time_left: float = 3
var text_size: float = 80
var started: bool = false
var selected: bool = false
var won: bool = false

func _ready():
	StatManager.restart()
	GameStatus.reset_players()
	text.text = "Waiting for player"
	
func _process(delta):
	if GameStatus.players.size() == 2 and not started:
		start_round()
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
	started = true
	text.visible = true
	timer_round_start.start()
	
func show_cards():
	pass
	

func show_player_win(loser_num):
	if won:
		return
	won = true
	timer_winner.start()
	var winner = GameStatus.winner(loser_num)
	text.text = "Player %d has won" % winner
	text.visible = true

func restart_round():
	selected = false
	won = false
	var players = $"../MultiplayerSpawner".get_children()
	for i in players.size():
		var player = players[i]
		player.visible = true
		player.heal(1000)
		player.regen_mana(1000)
		player.position = $"../SpawnPoints".get_children()[i].position
		
	start_round()

func _on_timer_timeout():
	GameStatus.pause_time = false
	text.visible = false


func _on_display_winner_timeout():
	GameStatus.pause_time = true
	text.visible = false
	var tween = create_tween()
	tween.tween_property(dim, "modulate", Color(0,0,0,0.7), 1.5)
	await tween.finished
	if GameStatus.winner_num != GameStatus.current_player:
		for i in 4:
			rpc("spawn_card", inst_to_dict(CardData.Cards.pick_random()), i)
		timer_movement.start()

@rpc("any_peer", "call_local")
func spawn_card(card, index: int):
	card = dict_to_inst(card)
	var card_scene = preload("res://scenes/menus/round_pick/card.tscn")
	var card_obj = card_scene.instantiate()
	card_obj.get_node("CardName").text = card.card_name
	card_obj.get_node("CardEffect").text = card.card_desc
	card_obj.get_node("CardImage").texture = load(card.card_image)
	card_obj.position = Vector2(700,1500)
	card_obj.card = card
	card_obj.index = index
	var final_pos = Vector2(250+400*index, 400)
	card_obj.rotation = card_obj.position.angle_to_point(final_pos)
	$Cards.add_child(card_obj)
	card_obj.card_clicked.connect(on_card_click)
	var tween = create_tween()
	tween.tween_property(card_obj, "position", final_pos, 2)
	var tween2 = create_tween()
	tween2.tween_property(card_obj, "rotation", 0, 2)
  
func on_card_click(input: InputEvent, card: Card, index):
	if input is InputEventMouseButton and input.pressed and input.button_index == 1 and not selected and timer_movement.is_stopped():
		print(GameStatus.loser_num-1)
		$"../MultiplayerSpawner".get_children()[GameStatus.loser_num-1].handle_card(card)
		rpc("select_card", index)

@rpc("any_peer", "call_local")
func select_card(index):
	selected = true
	var cards = $Cards.get_children()
	var selected_tween = create_tween()
	for i in cards.size():
		var card = cards[i]
		if i == index:
			selected_tween.tween_property(card, "position", card.position+Vector2(0, -100), 2)
		else:
			create_tween().tween_property(card, "position", card.position+Vector2(0, 1000), 2)
	await selected_tween.finished
	for i in cards.size():
		cards[i].queue_free()
	var tween = create_tween()
	tween.tween_property(dim, "modulate", Color(0,0,0,0), 1.5)
	restart_round()
	
