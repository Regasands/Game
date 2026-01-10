extends Control

signal buy_boost(card_id: int)
@export var card_id: int = -1
@export var res = null
@export var current_lvl: int = 0
@export var discount: int = int(GameState.get_total_boost_discount())

func _ready():
	update_card()

func update_card():
	$Panel/VBoxContainer/Name.text = res.name
	$Panel/VBoxContainer2/Level.text = "Lvl." + str(current_lvl)
	$Panel/VBoxContainer/Cost.text = str(res.calculate_cost(current_lvl) / discount) + "G"
	$Panel/VBoxContainer2/Boost.text = (str(res.calculate_value(current_lvl)))
	$Panel/CurrentValue.text = str(GameState.resources.get_boost_by_id(str(card_id)))
	
func _on_button_pressed():
	buy_boost.emit(card_id)

func _exit_tree():
	print("leave")
	$Panel/Button.pressed.disconnect(_on_button_pressed)
