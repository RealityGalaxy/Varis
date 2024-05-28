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
	GameStatus.reset()
	text.text = "Waiting for player"
	
var map_loaded = false
var name_sent = false
func _process(delta):
	if not name_sent:
		rpc("send_name", Steam.getPersonaName(), GameStatus.current_player)
		name_sent = true
	if not applied_multipliers and GameStatus.current_player == 1 and $"../MultiplayerSpawner".get_child_count() == 2:
		print('sent')
		rpc("apply_buffs", Settings.max_health, Settings.damage_multiplier, Settings.speed_multiplier, Settings.max_mana, Settings.mana_regen, Settings.damage_reduction)
		applied_multipliers = true

	if not map_loaded and GlobalSteam.lobby_id != -1 and $"../MultiplayerSpawner".get_child_count() == 1:
		$"../MultiplayerSpawner".update_player_spawn($"../MultiplayerSpawner".get_child(0))
		map_loaded = true
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

@rpc("call_remote")
func send_name(username, player_num):
	var stats = StatManager.get_player_stats(player_num)
	stats.username = username
	StatManager.set_player_stats(stats, player_num)

var applied_multipliers = false
func start_round():
	#get_tree().root.find_child("Loading2").queue_free()
	
	
	update_winner_text(0, 0)
	update_winner_text(1, 0)
	started = true
	text.visible = true
	timer_round_start.start()

@rpc("call_local")
func apply_buffs(max_health, damage_multiplier, speed_multiplier, max_mana, mana_regen, damage_reduction):
	for i in range(2):
		var player_stats = StatManager.get_player_stats(i+1)
		player_stats.max_health *= max_health
		player_stats.damage_multiplier *= damage_multiplier
		player_stats.speed_multiplier *= speed_multiplier
		player_stats.current_health *= max_health
		player_stats.max_mana *= max_mana
		player_stats.mana_regen *= mana_regen
		player_stats.damage_reduction *= damage_reduction
		StatManager.set_player_stats(i+1, player_stats)
		$"../MultiplayerSpawner".get_child(i).increase_max_health(0)
		$"../MultiplayerSpawner".get_child(i).increase_max_mana(0)
		
func show_cards():
	pass
	

func show_player_win(loser_num):
	if won:
		return
	won = true
	timer_winner.start()
	var winner = GameStatus.winner(loser_num)
	update_winner_text(winner-1, 1)
	text.text = "Player %d has won" % winner
	text.visible = true
	
func update_winner_text(winner_num, add):
	var stats = StatManager.get_player_stats(winner_num)
	stats.win_count += add
	StatManager.set_player_stats(winner_num, stats)
	$Wincounts.get_children()[winner_num].text = "%s: %d" % [stats.username, stats.win_count]


func restart_round():
	selected = false
	won = false
	var players = $"../MultiplayerSpawner".get_children()
	for i in players.size():
		var player = players[i]
		player.visible = true
		player.heal(1000)
		player.regen_mana(1000)
		var map = $"../Maps".map
		player.position = map.get_child(0).get_children()[i].position
		
	start_round()

func _on_timer_timeout():
	if not applied_multipliers and GameStatus.current_player == 1:
		print('sent')
		rpc("apply_buffs", Settings.max_health, Settings.damage_multiplier, Settings.speed_multiplier, Settings.max_mana, Settings.mana_regen, Settings.damage_reduction)
		applied_multipliers = true
	GameStatus.pause_time = false
	text.visible = false

func _on_display_winner_timeout():
	Sfx.round_end()
	GameStatus.pause_time = true
	text.visible = false
	var tween = create_tween()
	tween.tween_property(dim, "modulate", Color(0,0,0,0.7), 1.5)
	await tween.finished
	if StatManager.get_player_stats(0).win_count >= 10 or StatManager.get_player_stats(1).win_count >= 10:
		Sfx.round_lose()
		text.visible = true
		$TimerText/Button.visible = true
		text.text = "Player %d wins the game!" % GameStatus.winner_num
	else:
		if GameStatus.winner_num != GameStatus.current_player:
			for i in 4:
				rpc("spawn_card", inst_to_dict(CardData.Cards.pick_random()), i)
			timer_movement.start()

@rpc("any_peer", "call_local")
func spawn_card(card, index: int):
	Sfx.card_spawn()
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
		Sfx.button_click()
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


func _on_button_pressed():
	Sfx.button_click()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
