extends Control

var res_lib = preload("res://resource/shops/lib_boost.tscn").instantiate()
var scene_card = preload("res://scenes/additional/upgrade_cards.tscn")
var cards = []


func _ready():
	for i in range(GameState.global_boost):
		var card = _create_upgrade_card(i)
		$ScrollContainer/VBoxContainer.add_child(card)
		cards.append(card)	

func _create_upgrade_card(card_id: int) -> Control:
	var card = scene_card.instantiate()
	card.card_id = card_id
	print(card_id)
	card.res = res_lib.get_resource(str(card_id))
	card.current_lvl = GameState.resources.system_upgrade_shop[card_id] + 1
	card.update_card()
	card.buy_boost.connect(_buy_card)
	return card


func _buy_card(card_id):
	var card = cards[card_id]
	GameState.update_card(card)
	card.current_lvl = GameState.resources.system_upgrade_shop[card_id] + 1
	card.update_card()
	
	
func _exit_tree():
	for card in cards:
		if card.buy_boost.is_connected(_buy_card):
			card.buy_boost.disconnect(_buy_card)
	cards.clear()
