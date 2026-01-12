extends Node2D

@onready var button_easy = $button_to_easy_level
@onready var button_normal = $button_to_normal_level 
var mini_game_scene = preload("res://scenes/game/mini_game_2048.tscn")
var current_game_instance = null  


func set_label_button():
	button_easy.text = tr("ui_level_game_easy")
	button_normal.text = tr("ui_level_game_normal")
	
func set_visible_buttons(bool_: bool):
	button_easy.visible = bool_
	button_normal.visible = bool_
	
func _ready() -> void:
	set_label_button()
	await get_tree().process_frame
	SceneManager._register_button()
	
func _on_button_to_normal_level_pressed() -> void:
	start_game(14, 40, 5)

func _on_button_to_easy_level_pressed() -> void:
	start_game(9, 10, 1) 

func start_game(grid_size: int, mine_count: int, rewards: int):
	if current_game_instance:
		remove_child(current_game_instance)
		current_game_instance.queue_free()

	var new_scene = mini_game_scene.instantiate()

	var game_logic = new_scene.get_node("GameLogic")
	if game_logic:
		game_logic.grid_size = grid_size
		game_logic.mine_count = mine_count
		game_logic.rewards = rewards
	else:
		return
	
	if new_scene.has_signal("end_game"):
		new_scene.end_game.connect(_on_game_ended.bind(new_scene))
	else:
		if game_logic.has_signal("end_game"):
			game_logic.end_game.connect(_on_game_ended.bind(new_scene))
		else:
			return
	
	add_child(new_scene)
	current_game_instance = new_scene
	set_visible_buttons(false)

func _on_game_ended(game_instance):
	if game_instance.has_signal("end_game"):
		game_instance.end_game.disconnect(_on_game_ended)

	remove_child(game_instance)
	game_instance.queue_free()
	current_game_instance = null

	set_visible_buttons(true)


func _on_timer_timeout() -> void:
	GameState.add_energy(int(GameState.get_total_recovery_energy()))
