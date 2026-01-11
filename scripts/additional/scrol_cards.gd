extends Control

@onready var current_card: Node2D = $Card
@onready var button_check_open: Button  = $Button
@onready var name_card: Label = $ScrollContainer/VBoxContainer/Name
@onready var description_card: Label = $ScrollContainer/VBoxContainer/Description
@onready var boost_card: Label = $ScrollContainer/VBoxContainer/boost


var res_path = "res://assets_card_game_anime/cards/unknown.png"
var index_current: int = 0
var list_cards = []
var all_cards: Dictionary = GameState.resources.open_cards
var global_position_: Vector2 = Vector2(100, 250)
var target_colors = [Color("#6bc46b"), Color("#e86d6d"), Color("#8b8b8b")]
var card_res = null

func _ready() -> void:
	for key in all_cards.keys():
		list_cards.append(key)
	current_card.global_position = global_position_
	print(list_cards)
	update_card(index_current)


func _is_available_check_by_index(index: int) -> bool:
	return all_cards[list_cards[index]]


func _check_is_eqip(index: int) -> bool:
	return GameState.resources.equip_card == list_cards[index]
	
	
func _update_button_state(is_available: bool, is_equip: bool, price: int = 0) -> void:
	if not is_available:
		button_check_open.text = tr("ui_button_buy_for") + " " + str(price) + "G"
		_change_button_color(target_colors[1])
		return
	if is_equip:
		button_check_open.text = tr("ui_button_use")
		_change_button_color(target_colors[2])
	else:
		button_check_open.text = tr("ui_button_available")
		_change_button_color(target_colors[0])
		
		
func _change_button_color(new_color: Color):
	var style_box = button_check_open.get_theme_stylebox("normal") as StyleBoxFlat
	style_box.bg_color = new_color
	
	
func _update_index(index: int) -> int:
	if index >= len(list_cards):
		return 0
	elif index < 0:
		return len(list_cards) - 1
	return index
		

func _on_left_button_pressed() -> void:
	index_current = _update_index(index_current - 1)
	update_card(index_current)
	
	
func _on_right_button_pressed() -> void:
	index_current = _update_index(index_current + 1)
	update_card(index_current)
	
	
func _add_visual_scene(res, visual=true):
	name_card.text = tr(res.name)
	if visual:
		description_card.text = tr(res.description)
		boost_card.text = tr(res.description_boost) 
	else:
		description_card.text = "??"
		boost_card.text = "??"
	_update_button_state(_is_available_check_by_index(index_current), 
	_check_is_eqip(index_current), res.cost)
	
	
func update_card(index:int):
	card_res = GameState.get_card(list_cards[index])
	if (card_res.rarity == "common" or GameState.check_availability(list_cards[index])):
		current_card._add_texture(card_res)
		_add_visual_scene(card_res, true)
	else:	
		current_card._add_texture(res_path, true)
		_add_visual_scene(card_res, false)
	
	
func _on_button_pressed() -> void:
	if list_cards[index_current] == GameState.resources.equip_card:
		pass
	elif GameState.check_availability(list_cards[index_current]):
		GameState.update_eqip_card(list_cards[index_current])
		update_card(index_current)
	elif GameState.buy_card(list_cards[index_current]):
		update_card(index_current)
	else:
		$AudioStreamPlayer2D.play()
		
