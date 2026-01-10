# game_state.gd
extends Node

# СИГНАЛЫ
signal money_changed(new_value: int)
signal energy_changed(new_value: int, max_value: int)
signal crystals_changed(new_value: int)


# ДАННЫЕ
var save_path = "res://game_save.tres" 
var resources: GameResources
var lib_card = preload("res://scenes/lib_card.tscn").instantiate()
var resource_card: ResourceCard
var global_boost = 8


func _ready():
	load_game_resources()
	resource_card = lib_card.get_resource(resources.equip_card)

func load_game_resources():
	if ResourceLoader.exists(save_path):
		var loaded_res = load(save_path)
		if loaded_res is GameResources:
			resources = loaded_res
		else:
			create_new_resources()
	else:
		print("🆕 Сохранений нет, создаем новые ресурсы")
		create_new_resources()

func create_new_resources():
	resources = GameResources.new() 
	# Можно задать начальные значения (опционально)
	resources.money = 100
	resources.energy = 100
	resources.max_energy = 1000
	resources.crystals = 10
	resources.clicks = 1
	save_resources()
	print("🆕 Созданы новые ресурсы")

func save_resources():
	var error = ResourceSaver.save(resources, save_path)
	if error == OK:
		print("💾 Игра сохранена")
	else:
		print("❌ Ошибка сохранения: ", error)

func update_all_ui():
	money_changed.emit(resources.money)
	energy_changed.emit(resources.energy, get_total_max_energy())
	crystals_changed.emit(resources.crystals)
	
	
func add_money(amount: int):
	if amount == 0:
		return		
	resources.money += amount
	save_resources()
	
	money_changed.emit(resources.money)  # ← СИГНАЛ!

func spend_money(amount: int) -> bool:
	if amount <= 0:
		return false
	if resources.money >= amount:
		resources.money -= amount
		save_resources()
		money_changed.emit(resources.money)

		return true
	else:
		return false

func add_energy(amount: int):
	if amount == 0:
		return
	var old_energy = resources.energy
	resources.energy = clamp(resources.energy + amount, 0, get_total_max_energy())
	
	if resources.energy != old_energy:
		save_resources()
		energy_changed.emit(resources.energy, get_total_max_energy())
		

func spend_energy(amount: int) -> bool:
	if amount <= 0:
		return false
	if resources.energy >= amount:
		resources.energy -= amount
		save_resources()
		energy_changed.emit(resources.energy, get_total_max_energy())
		return true
	else:
		return false

func add_crystals(amount: int):
	if amount == 0:
		return
		
	resources.crystals += amount
	save_resources()
	crystals_changed.emit(resources.crystals)

	
func spend_crystals(amount: int) -> bool:
	if amount <= 0:
		return false
		
	if resources.crystals >= amount:
		resources.crystals -= amount
		save_resources()
		crystals_changed.emit(resources.crystals) 
		return true
	else:
		return false
		
		
# функции для работы с картой
func get_card(name_ :String):
	return lib_card.get_resource(name_)
	
func update_eqip_card(name_: String):
	if resources.open_cards[name_]:
		resources.equip_card = name_
	else:
		push_error()
	resource_card = get_card(name_)
	save_resources()
	
func check_availability(name_: String) -> bool:
	return resources.open_cards.get(name_, false)
	
func update_open_cards(name_: String):
	if !resources.open_cards.get(name_, true):
		resources.open_cards[name_] = true
	else:
		push_error()
	save_resources()

func buy_card(name_) -> bool:
	var res = get_card(name_)
	var discount = get_total_boost_discount()
	if 	spend_money(res.cost / discount):
		update_open_cards(name_)
		print("Карта куплена ")
		return true
	else:
		return false
		
		
# покупаем и обновляем карту
func update_card(card_upgrade):
	if spend_money(card_upgrade.res.calculate_cost(card_upgrade.current_lvl) / get_total_boost_discount()):
		resources.system_upgrade_shop[card_upgrade.card_id] += 1
		save_resources()
		recalculation_boost(card_upgrade)
		
		
func recalculation_boost(card_upgrade):
	var boost = card_upgrade.res.calculate_value(card_upgrade.current_lvl)
	match str(card_upgrade.card_id):
		"0": resources.boost_click = boost
		"1": resources.boost_shop = boost
		"2": resources.boost_energy_max = boost
		"3": resources.boost_recorvy_energy = boost
		"4": resources.boost_discount = boost
		"5": resources.clicks = boost
		"6": resources.recovery_energy = boost
		"7": resources.max_energy = boost
	save_resources()
	energy_changed.emit(resources.energy, get_total_max_energy())
	
		
func update_res(card_upgrade):
	resources.system_upgrade_shop[card_upgrade.card_id] = card_upgrade.current_lvl
	recalculation_boost(card_upgrade)
	save_resources()
	
	
# получаем полные бусты
func get_total_click() -> float:
	return resources.clicks * resources.boost_click * resource_card.boost_click
	
	
func get_total_recovery_energy() -> float:
	return resources.recovery_energy * resources.boost_recorvy_energy * resource_card.recovery_energy

func get_total_boost_luck() -> float:
	return resources.luck * resource_card.luck
	
func get_total_boost_discount() -> float:
	return resources.boost_discount * resource_card.boost_discount

func get_total_max_energy() -> float:
	return resources.max_energy * resources.boost_energy_max * resource_card.boost_energy_max
		
	
func set_money(value: int):
	if resources.money != value:
		resources.money = value
		save_resources()
		money_changed.emit(value)

func set_energy(value: int):
	if resources.energy != value:
		resources.energy = clamp(value, 0, get_total_max_energy())
		save_resources()
		energy_changed.emit(resources.energy, get_total_max_energy())

func set_crystals(value: int):
	if resources.crystals != value:
		resources.crystals = value
		save_resources()
		crystals_changed.emit(value)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_resources()
		print("💾 Игра сохранена перед выходом")
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_resources()
		print("💾 Игра сохранена (пауза)")
