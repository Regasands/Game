# Скрипт для главной сцены мини-игры (корень Node2D или Control)
extends Node2D

# 1. СЛОВАРЬ ЦВЕТОВ ДЛЯ ЗНАЧЕНИЙ
var tile_colors = {
	0: Color(0.78, 0.74, 0.68, 0.35),    # Пустая клетка (полупрозрачная)
	2: Color(0.93, 0.89, 0.85),
	4: Color(0.93, 0.88, 0.78),
	8: Color(0.95, 0.69, 0.47),
	16: Color(0.96, 0.58, 0.39),
	32: Color(0.96, 0.49, 0.37),
	64: Color(0.96, 0.37, 0.23),
	128: Color(0.93, 0.81, 0.45),
	256: Color(0.93, 0.80, 0.38),
	512: Color(0.93, 0.78, 0.31),
	1024: Color(0.93, 0.77, 0.25),
	2048: Color(0.93, 0.76, 0.18)
}

func get_color_for_value(value: int) -> Color:
	return tile_colors.get(value, Color(0.24, 0.24, 0.24)) 

@onready var logic = $GameLogic
@onready var start_cell_grid = $GridContainer
@onready var tiles = preload("res://scenes/game/tiles.tscn")
var cell_grid = null

# 2. ПЕРЕМЕННЫЕ ДЛЯ ОБРАБОТКИ СВАЙПОВ
var touch_start_pos = Vector2.ZERO
var touch_end_pos = Vector2.ZERO
const MIN_SWIPE_DISTANCE = 50 

func _ready():
	for x in range(logic.grid_size):
		for y in range(logic.grid_size):
			var tile = tiles.instantiate()
			start_cell_grid.add_child(tile)
	cell_grid = start_cell_grid.get_children()
	
	logic.initialize_grid()
	logic.spawn_random_tile()
	logic.spawn_random_tile()
	update_display()

# 3. ОСНОВНАЯ ФУНКЦИЯ ОБНОВЛЕНИЯ ВИЗУАЛА
func update_display():
	for x in range(4):
		for y in range(4):
			var cell_index = x * 4 + y
			var value = logic.grid[x][y]
			var cell_node = cell_grid[cell_index]
			
			# Обновляем текст
			if value == 0:
				cell_node.get_node("Label").text = ""
			else:
				cell_node.get_node("Label").text = str(value)
			
			# Обновляем цвет плитки
			cell_node.get_node("Background").color = get_color_for_value(value)
			
			# Обновляем цвет текста (чтобы был контрастным)
			var text_color = Color.BLACK if value < 8 else Color.WHITE
			cell_node.get_node("Label").add_theme_color_override("font_color", text_color)

	# Обновляем счёт
	$ScoreLabel.text = "Счёт: " + str(logic.score)

# 4. ОБРАБОТКА СВАЙПОВ ЧЕРЕВ _INPUT (самый простой способ)
func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			# Запоминаем точку начала касания
			touch_start_pos = event.position
		else:
			# Когда отпустили - определяем направление
			touch_end_pos = event.position
			handle_swipe(touch_start_pos, touch_end_pos)

# 5. ОПРЕДЕЛЕНИЕ НАПРАВЛЕНИЯ СВАЙПА
func handle_swipe(start_pos: Vector2, end_pos: Vector2):
	var swipe_vector = end_pos - start_pos
	
	# Если свайп слишком короткий - игнорируем
	if swipe_vector.length() < MIN_SWIPE_DISTANCE:
		return
	
	# Определяем основное направление
	if abs(swipe_vector.x) > abs(swipe_vector.y):
		# Горизонтальный свайп
		if swipe_vector.x > 0:
			logic.move(Vector2i.RIGHT)  # Свайп вправо
		else:
			logic.move(Vector2i.LEFT)   # Свайп влево
	else:
		# Вертикальный свайп
		if swipe_vector.y > 0:
			logic.move(Vector2i.DOWN)   # Свайп вниз
		else:
			logic.move(Vector2i.UP)     # Свайп вверх
	
	# Обновляем экран после хода
	update_display()
