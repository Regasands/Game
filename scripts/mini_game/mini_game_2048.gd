# MinesweeperScene.gd - Визуальная часть
extends Control

@onready var logic = $GameLogic
@onready var grid_container = $GridContainer

var cell_scene = preload("res://scenes/game/tiles.tscn")
var vector_easy = Vector2(64, 64)
var vector_global_pos_easy = Vector2(50, 200)
var vector_normal = Vector2(26, 26)
var vector_global_pos_normal = Vector2(0, 100)
var vector_total = null
var vector_pos = null

signal end_game

func _ready():
	logic.initialize_game()
	if logic.grid_size != 9:
		vector_total = vector_normal
		vector_pos = vector_global_pos_normal 
		grid_container.add_theme_constant_override("h_separation", 2)
		grid_container.add_theme_constant_override("v_separation", 2)
	else:
		vector_total = vector_easy
		vector_pos = vector_global_pos_easy 
		grid_container.add_theme_constant_override("h_separation", 5)
		grid_container.add_theme_constant_override("v_separation", 5)


	grid_container.global_position = vector_pos
	grid_container.columns = logic.grid_size
	create_grid()
	$GameLogic.game_won.connect(_on_game_won)
	$GameLogic.game_lost.connect(_on_game_lost)

func create_grid():
	for child in grid_container.get_children():
		child.queue_free()
	for y in range(logic.grid_size):
		for x in range(logic.grid_size):
			var cell = cell_scene.instantiate()
			grid_container.add_child(cell)
			cell.coordinates = Vector2i(x, y)
			cell.size = vector_total
			cell.get_node("Button").gui_input.connect(_on_cell_gui_input.bind(cell))

			
			
func _on_cell_gui_input(event, cell_node):
	var coords = cell_node.coordinates
	
	if event is InputEventScreenTouch:
		if event.pressed:
			cell_node.touch_start_time = Time.get_ticks_msec()
			cell_node.touch_position = event.position
		else:
			var hold_time = Time.get_ticks_msec() - cell_node.touch_start_time
			if hold_time > 400:
				logic.toggle_flag(coords.x, coords.y)
			else:
				logic.reveal_cell(coords.x, coords.y)

	update_display()

func update_display():
	for y in range(logic.grid_size):
		for x in range(logic.grid_size):
			var cell_index = y * logic.grid_size + x
			var cell_node = grid_container.get_child(cell_index)
			var button = cell_node.get_node("Button")
			
			if logic.revealed_grid[x][y]:
				button.disabled = true
				button.text = get_cell_text(x, y)
			elif logic.flagged_grid[x][y]:
				button.text = "F"
				button.add_theme_color_override("font_color", Color.RED)
			else:
				button.text = ""
				button.disabled = false


func get_cell_text(x, y) -> String:
	if logic.grid[x][y] == -1:
		return "B" 
	elif logic.grid[x][y] == 0:
		return "" 
	else:
		return str(logic.grid[x][y])



func _on_game_won():
	GameState.add_crystals($GameLogic.rewards *  GameState.get_total_boost_luck())
	$Result.text = tr("ui_label_win_game")
	$Timer.start()

func _on_game_lost():
	$Result.text = tr("ui_label_lose_game")
	$Timer.start()

func _on_timer_timeout() -> void:
	end_game.emit()
