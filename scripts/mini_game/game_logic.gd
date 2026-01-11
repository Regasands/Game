extends Node

var grid = []
var grid_size = 4
var score = 0

signal diamond_earned(amount)

func _ready():
	initialize_grid()
	spawn_random_tile()
	spawn_random_tile()


func initialize_grid():
	"""
		   Создаем пустое поле
	"""
	
	grid = []
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			grid[x].append(0)


func spawn_random_tile():
	var empty_cells = []
	for x in range(grid_size):
		for y in range(grid_size):
			if grid[x][y] == 0:
				empty_cells.append(Vector2i(x, y))
				
	if empty_cells.size() > 0:
		var cell = empty_cells[randi() % empty_cells.size()]
		grid[cell.x][cell.y] = 2 if (randi() % 10) < 9 else 4  
		return true
	return false


func move(direction: Vector2i):
	var moved = false
	var prev_score = score
	
	match direction:
		Vector2i.LEFT: moved = move_horizontal(true)
		Vector2i.RIGHT: moved = move_horizontal(false)
		Vector2i.UP: moved = move_vertical(true)
		Vector2i.DOWN: moved = move_vertical(false)
	
	if moved:
		spawn_random_tile()
		
		var diamonds_before = floor(prev_score / 1024)
		var diamonds_now = floor(score / 1024)
		if diamonds_now > diamonds_before:
			emit_signal("diamond_earned", diamonds_now - diamonds_before)
		check_game_over()


func move_horizontal(left: bool) -> bool:
	var moved = false
	for y in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(grid[x][y])
		
		var new_row = process_line(row, left)
		
		for x in range(grid_size):
			if grid[x][y] != new_row[x]:
				moved = true
			grid[x][y] = new_row[x]
	return moved


func move_vertical(up: bool) -> bool:
	var moved = false
	for x in range(grid_size):
		var column = []
		for y in range(grid_size):
			column.append(grid[x][y])
		
		var new_column = process_line(column, up)
		
		for y in range(grid_size):
			if grid[x][y] != new_column[y]:
				moved = true
			grid[x][y] = new_column[y]
	return moved

func process_line(line: Array, reverse_for_merge: bool) -> Array:
	var non_zero = []
	for value in line:
		if value != 0:
			non_zero.append(value)
	
	if reverse_for_merge:
		non_zero.reverse()
	
	var merged = []
	var i = 0
	while i < non_zero.size():
		if i + 1 < non_zero.size() and non_zero[i] == non_zero[i + 1]:
			var new_value = non_zero[i] * 2
			merged.append(new_value)
			score += new_value 
			i += 2
		else:
			merged.append(non_zero[i])
			i += 1
	
	while merged.size() < grid_size:
		merged.append(0)
	
	if reverse_for_merge:
		merged.reverse()
	
	return merged


func check_game_over():
	for x in range(grid_size):
		for y in range(grid_size):
			if grid[x][y] == 0:
				return false
	
	for x in range(grid_size):
		for y in range(grid_size):
			var current = grid[x][y]
			if x + 1 < grid_size and grid[x + 1][y] == current:
				return false
			if y + 1 < grid_size and grid[x][y + 1] == current:
				return false
	
	print("Game Over! Final Score: ", score)
	return true
