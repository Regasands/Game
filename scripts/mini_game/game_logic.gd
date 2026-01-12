extends Node

signal game_won()
signal game_lost()

var grid = []
var mine_grid = [] 
var revealed_grid = []
var flagged_grid = []
var grid_size = 14
var mine_count = 10
var rewards = 0

func _ready():
	initialize_game()


func initialize_game():
	grid = []
	mine_grid = []
	revealed_grid = []
	flagged_grid = []
	
	for x in range(grid_size):
		grid.append([])
		mine_grid.append([])
		revealed_grid.append([])
		flagged_grid.append([])
		for y in range(grid_size):
			grid[x].append(0)
			mine_grid[x].append(false)
			revealed_grid[x].append(false)
			flagged_grid[x].append(false)
	
	place_mines()
	calculate_numbers()


func place_mines():
	var mines_placed = 0
	while mines_placed < mine_count:
		var x = randi() % grid_size
		var y = randi() % grid_size
		
		if not mine_grid[x][y]:
			mine_grid[x][y] = true
			mines_placed += 1


func calculate_numbers():
	for x in range(grid_size):
		for y in range(grid_size):
			if mine_grid[x][y]:
				grid[x][y] = -1  # -1 = мина
			else:
				grid[x][y] = count_adjacent_mines(x, y)


func count_adjacent_mines(cell_x, cell_y) -> int:
	var count = 0
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
				
			var nx = cell_x + dx
			var ny = cell_y + dy
			
			if nx >= 0 and nx < grid_size and ny >= 0 and ny < grid_size:
				if mine_grid[nx][ny]:
					count += 1
	return count

func reveal_cell(x, y):
	if revealed_grid[x][y] or flagged_grid[x][y]:
		return
		
	revealed_grid[x][y] = true
	
	if mine_grid[x][y]:
		emit_signal("game_lost")
		return
	
	if grid[x][y] == 0:
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				var nx = x + dx
				var ny = y + dy
				
				if nx >= 0 and nx < grid_size and ny >= 0 and ny < grid_size:
					if not revealed_grid[nx][ny] and not flagged_grid[nx][ny]:
						reveal_cell(nx, ny)
	
	check_win_condition()

func toggle_flag(x, y):
	if not revealed_grid[x][y]:
		flagged_grid[x][y] = !flagged_grid[x][y]


func check_win_condition():
	
	for x in range(grid_size):
		for y in range(grid_size):
			if not mine_grid[x][y] and not revealed_grid[x][y]:
				return false
	
	emit_signal("game_won")
	return true
