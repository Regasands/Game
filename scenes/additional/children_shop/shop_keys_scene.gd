extends Control


var card_scene = preload("res://scenes/card.tscn")
	

func _ready() -> void:
	ui_label()
	$BuyCard.global_position = Vector2(185, 470)
	
func ui_label():
	$BuyCard.text = tr("ui_button_buy_key_for")
	
	
func _on_buy_card_pressed() -> void:
	if not GameState.spend_crystals(GameState.resources.cristal_by_box):
		return 
	var list_cards = GameState.get_all_close_card_anime()
	if list_cards.is_empty():
		print("Все карты открыты!")
		return

	var cards_by_rarity = {}
	for card_id in list_cards:
		var rarity = GameState.get_card(card_id).rarity
		cards_by_rarity[rarity] = cards_by_rarity.get(rarity, []) + [card_id]

	var selected_rarity = _select_rarity(cards_by_rarity)
	if not selected_rarity:
		return

	var card_id = cards_by_rarity[selected_rarity].pick_random()
	
	GameState.update_open_cards(card_id)
	
	var new_card = card_scene.instantiate()
	add_child(new_card)
	new_card.scale = Vector2(0.1, 0.1)
	new_card.texture_.pivot_offset = new_card.texture_.size / 2
	new_card.call_deferred("setup", GameState.get_card(card_id))
	new_card.call_deferred("_add_texture", GameState.get_card(card_id))
	new_card.scale = Vector2(0.1, 0.1)
	new_card.visible = false
	
	new_card.global_position = $AnimatedCard/SpawnPoint.global_position
	$AnimatedCard.connect("animation_finished", _on_animation_finished.bind(new_card, card_id), CONNECT_ONE_SHOT)
	$AnimatedCard.play("default")
	
	
func _on_animation_finished(new_card, card_id):
	new_card.visible = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(new_card, "scale", Vector2.ONE, 2)
	tween.connect("finished", _on_tween_finished.bind(new_card), CONNECT_ONE_SHOT)

func _on_tween_finished(new_card):
	print("Tween завершен")
	get_tree().create_timer(2.0).timeout.connect(
		func(): 
			if new_card:
				print("Удаляем карту")
				new_card.queue_free()
	)
	
	
func _select_rarity(cards_by_rarity: Dictionary) -> String:
	var available_chances = {}
	var total_chance = 0.0
	var chance_dict = GameState.resources.chance_dict

	for rarity in chance_dict:
		if cards_by_rarity.has(rarity) and not cards_by_rarity[rarity].is_empty():
			available_chances[rarity] = chance_dict[rarity]
			total_chance += chance_dict[rarity]

	if total_chance <= 0:
		return ""

	# Выбор с нормализацией
	var roll = randf() * total_chance
	for rarity in available_chances:
		roll -= available_chances[rarity]
		if roll <= 0:
			return rarity

	return ""
