extends Node2D

@onready var text = $TimerText
@onready var button = $TimerText/Button
@onready var timer_round_start = $Timers/RoundStart
@onready var timer_winner = $Timers/DisplayWinner
@onready var timer_movement = $Timers/Movement
@onready var dim = $Dim

var time_left: float = 3
var text_size: float = 80
var started: bool = false
var selected: bool = false
var won: bool = false
var score = 0
var next_card = 100
var time = 0.0
var enemies = 0
var max_enemies = 2

func add_score(add: int):
	score += add * (1 + (floor(time / 30)) * 0.1)
	enemies-=1
	if(enemies < max_enemies and GameStatus.current_player == 1):
		spawn_enemy(2 if enemies + 2 <= max_enemies else 1)
	if score >= next_card:
		next_card += 50
		next_card *= 1.7
		update_game_texts()
		show_cards()
		
func spawn_enemy(amount = 1):
	var spawnpoints = $"../EnemySpawns".get_children()
	for i in range(amount):
		enemies += 1
		var spawnpoint = spawnpoints.pick_random()
		spawnpoints.remove_at(spawnpoints.find(spawnpoint))
		rpc("spawn_enemy_rpc", spawnpoint.position)

@rpc("any_peer", "call_local")
func spawn_enemy_rpc(spawnpoint):
	var enemy = load("res://scenes/enemies/eye_drone.tscn").instantiate()
	call_deferred("add_enemy", enemy)
	enemy.position = spawnpoint
	enemy.max_health *= (1 + (floor(time / 30)) * 0.1)

func add_enemy(enemy):
	$Enemies.add_child(enemy)

var save_path = "user://score.save"

var score_save = ["0", "0", "0", "0", "0"]

func sort_desc(a: String, b: String):
	if int(a.get_slice(' ', 0)) > int(b.get_slice(' ', 0)):
		return true
	return false 

func save_score(new_score):
	score_save.append(str(new_score) + " " + Time.get_date_string_from_system()) 
	score_save.sort_custom(sort_desc)
	var new_store = []
	for i in range(5):
		new_store.append(score_save[i])
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(new_store)

func _ready():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		score_save = file.get_var()
	StatManager.restart()
	GameStatus.reset()
	text.text = "Waiting for player"
	
func _process(delta):
	if GameStatus.players.size() == 2 and not started:
		start_round()
		spawn_enemy()
		for child in $"../MultiplayerSpawner".get_children():
			child.set_collision_layer_value(child.player_num, false)
			child.set_collision_layer_value(5, true)
	if not timer_round_start.is_stopped():
		var new_time = ceil(timer_round_start.time_left)
		text.add_theme_font_size_override("font_size", 80)
		text_size -= 20 * delta
		if new_time != time_left:
			time_left = new_time
			text_size = 80
		text.add_theme_font_size_override("font_size", ceil(text_size))
		text.text = str(new_time)
	if not GameStatus.pause_time and not won:
		max_enemies = 2 + floor(time / 40)
		time += delta
		update_game_texts()
		
func update_game_texts():
	$LevelTimer.text = str(floor(time / 60)) + ':' + (str(int(time) % 60) if int(time) % 60 >= 10 else ('0' + str(int(time) % 60)))
	$ScoreText.text = "Score: " + str(floor(score)) + " / " + str(floor(next_card))

func start_round():
	started = true
	text.visible = true
	timer_round_start.start()
	
@rpc("any_peer", "call_local")
func set_pause_time(value):
	GameStatus.pause_time = value
	
func show_cards():
	Sfx.round_end()
	rpc("set_pause_time", true)
	create_tween().tween_property(dim, "modulate", Color(0,0,0,0.7), 1.5)
	timer_winner.start()

func check_alive():
	for i in range(2):
		if StatManager.get_player_stats(i+1).current_health > 0:
			return true
	return false

func show_player_win(loser_num):
	if won or check_alive():
		return
	won = true
	Sfx.round_lose()
	create_tween().tween_property(text, "modulate", Color(1,1,1), 1.5)
	create_tween().tween_property(dim, "modulate", Color(0,0,0,0.7), 1.5)
	text.text = "You have died.
	Survived: " + (str(floor(time / 60)) + ':' + (str(int(time) % 60) if int(time) % 60 >= 10 else ('0' + str(int(time) % 60)))) + " 
	Score: " + str(score)
	text.visible = true
	button.visible = true
	save_score(score)
	$Leaderboard.text = generate_leaderboard(score_save)
	create_tween().tween_property($Leaderboard, "modulate", Color(1,1,1,1), 1.5)
	$Leaderboard.visible = true
	
func generate_leaderboard(array):
	var string = "Hiscores:
		1. " + str(array[0]) + "
		2. " + str(array[1]) + "
		3. " + str(array[2]) + "
		4. " + str(array[3]) + "
		5. " + str(array[4])
	return string

func restart_round():
	selected = false
	won = false
	_on_timer_timeout()

func _on_timer_timeout():
	rpc("set_pause_time", false)
	text.visible = false

func _on_display_winner_timeout():
	rpc("set_pause_time", true)
	text.visible = false
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
		$"../MultiplayerSpawner".get_children()[0].handle_card(card)
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
	await tween.tween_property(dim, "modulate", Color(0,0,0,0), 1.5).finished
	restart_round()
	




func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
