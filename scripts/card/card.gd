extends  Node2D

@onready var texture_: TextureRect = $Area2D/TextureRect
@onready var area2d: Area2D = $Area2D

# базовые векторы
var base_vector: Vector2 = Vector2(0.5, 0.5)
var animation_vector_2: Vector2 = Vector2(1, 1)
var animated_vector: Vector2 = Vector2(0.9, 0.9)
# костыль 
var global_position_: Vector2 = Vector2(64, 180)


func _ready() -> void:
	texture_.pivot_offset = texture_.size / 2
	global_position = global_position_
	print(GameState.resource_card)
	_add_texture(GameState.resource_card)


func setup(card_data):
	# Ждем, пока узел icon будет инициализирован
	await get_tree().process_frame


func _add_texture(resource_, is_path=false) -> void:
	
	if is_path:
		texture_.texture = load(resource_)
	else:
		texture_.texture = resource_.card_texture
	area2d.scale = base_vector


func _animation():
	texture_.scale =  animated_vector
	$TimerAnimation.start()
	await  $TimerAnimation.timeout
	texture_.scale = animation_vector_2


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if !$TimeClick.is_stopped():
			return
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if !mouse_event.pressed:
				$TimeClick.start()
				await  $TimeClick.timeout
				var total_money_click = GameState.get_total_click()
				if GameState.spend_energy(total_money_click):
					GameState.add_money(total_money_click)
					GameState.resources.total_click += 1
					_animation()
				elif GameState.resources.energy > 0:
					GameState.add_money(GameState.resources.energy)
					GameState.spend_energy(GameState.resources.energy)
					GameState.resources.total_click += 1
					_animation()
					
