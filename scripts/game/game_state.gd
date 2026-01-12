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



#
#func load_game_resources():
	#if use_web_storage:
		#load_from_web_storage()
	#else:
		#load_from_local_file()
#
#func load_from_local_file():
	#if ResourceLoader.exists(save_path):
		#var loaded_res = load(save_path)
		#if loaded_res is GameResources:
			#resources = loaded_res
			#print("💾 Загружены ресурсы из файла")
			#print(resources)
		#else:
			#create_new_resources()
	#else:
		#print("🆕 Сохранений нет, создаем новые ресурсы")
		#create_new_resources()
#
#func load_from_web_storage():
	## Пытаемся загрузить из localStorage браузера
	#if JavaScriptBridge.eval("""
		#typeof localStorage !== 'undefined' && localStorage.getItem('game_resources_data') !== null
	#""", true):
		#var json_data = JavaScriptBridge.eval("""
			#localStorage.getItem('game_resources_data')
		#""", true)
		#
		#if json_data and json_data != "null":
			#resources = deserialize_resources(json_data)
			#print("🌐 Загружены ресурсы из localStorage")
		#else:
			## Пробуем загрузить из IndexedDB если есть
			#load_from_indexed_db()
	#else:
		#create_new_resources()
#
#func load_from_indexed_db():
	## Альтернативный метод для более надежного хранения в вебе
	#if JavaScriptBridge.eval("""
		#typeof indexedDB !== 'undefined'
	#""", true):
		## Простая реализация загрузки из IndexedDB
		#JavaScriptBridge.eval("""
			#new Promise((resolve, reject) => {
				#try {
					#let request = indexedDB.open('GameSaves', 1);
					#
					#request.onerror = function(event) {
						#resolve(null);
					#};
					#
					#request.onsuccess = function(event) {
						#let db = event.target.result;
						#let transaction = db.transaction(['saves'], 'readonly');
						#let store = transaction.objectStore('saves');
						#let getRequest = store.get('current_save');
						#
						#getRequest.onsuccess = function() {
							#resolve(getRequest.result);
						#};
						#
						#getRequest.onerror = function() {
							#resolve(null);
						#};
					#};
					#
					#request.onupgradeneeded = function(event) {
						#resolve(null);
					#};
				#} catch(e) {
					#resolve(null);
				#}
			#}).then(function(result) {
				#if (result) {
					#console.log('📦 Загружены данные из IndexedDB');
					#// Возвращаем данные в Godot
					#window.resultFromIndexedDB = result;
				#} else {
					#console.log('📦 IndexedDB пуст');
					#window.resultFromIndexedDB = null;
				#}
			#});
		#""")
		#
		## Ждем немного и проверяем результат
		#await get_tree().create_timer(0.5).timeout
		#var result = JavaScriptBridge.eval("window.resultFromIndexedDB || null", true)
		#
		#if result and result != "null":
			#resources = deserialize_resources(str(result))
			#print("📦 Загружены ресурсы из IndexedDB")
		#else:
			#create_new_resources()
	#else:
		#create_new_resources()
#
#func deserialize_resources(json_data: String) -> GameResources:
	#var data = JSON.parse_string(json_data)
	#var res = GameResources.new()
	#
	#if data:
		## Восстанавливаем все свойства из JSON
		#for property in res.get_property_list():
			#var prop_name = property["name"]
			#if prop_name in data:
				#res.set(prop_name, data[prop_name])
	#
	#return res
#
#func create_new_resources():
	#resources = GameResources.new() 
	## Начальные значения
	#resources.money = 100
	#resources.energy = 100
	#resources.max_energy = 200  # Исправлено на 200 как в классе
	#resources.crystals = 10
	#resources.clicks = 1
	#
	## Сохраняем в зависимости от платформы
	#save_resources()
	#print("🆕 Созданы новые ресурсы")
#
#func save_resources():
	#if use_web_storage:
		#save_to_web_storage()
	#else:
		#save_to_local_file()
#
#func save_to_local_file():
	#var error = ResourceSaver.save(resources, save_path)
	#if error == OK:
		#print("💾 Игра сохранена в файл")
	#else:
		#print("❌ Ошибка сохранения в файл: ", error)
#
#func save_to_web_storage():
	## Сохраняем в localStorage браузера
	#var json_data = serialize_resources()
	#
	#JavaScriptBridge.eval("""
		#if (typeof localStorage !== 'undefined') {
			#try {
				#localStorage.setItem('game_resources_data', '%s');
				#console.log('💾 Игра сохранена в localStorage');
			#} catch(e) {
				#console.error('❌ Ошибка localStorage:', e);
			#}
		#}
	#""" % json_data.replace("'", "\\'").replace("\n", "\\n"))
	#
	## Дополнительно сохраняем в IndexedDB для надежности
	#save_to_indexed_db(json_data)
#
#func save_to_indexed_db(json_data: String):
	#if JavaScriptBridge.eval("""
		#typeof indexedDB !== 'undefined'
	#""", true):
		## Исправленная версия с правильным экранированием
		#var escaped_data = json_data.replace("'", "\\'").replace("\n", "\\n")
		#JavaScriptBridge.eval("""
			#try {
				#let request = indexedDB.open('GameSaves', 1);
				#
				#request.onupgradeneeded = function(event) {
					#let db = event.target.result;
					#if (!db.objectStoreNames.contains('saves')) {
						#db.createObjectStore('saves');
					#}
				#};
				#
				#request.onsuccess = function(event) {
					#let db = event.target.result;
					#let transaction = db.transaction(['saves'], 'readwrite');
					#let store = transaction.objectStore('saves');
					#store.put('%s', 'current_save');
					#console.log('💾 Игра сохранена в IndexedDB');
				#};
				#
				#request.onerror = function(event) {
					#console.error('❌ Ошибка IndexedDB:', event.target.error);
				#};
			#} catch(e) {
				#console.error('❌ Ошибка IndexedDB:', e);
			#}
		#""" % escaped_data)
#
#func serialize_resources() -> String:
	#var data = {}
	#
	## Сериализуем все экспортированные свойства
	#for property in resources.get_property_list():
		#var prop_name = property["name"]
		## Проверяем, что свойство экспортировано или является переменной скрипта
		#if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#data[prop_name] = resources.get(prop_name)
	#
	#return JSON.stringify(data)
#
#
## Функция для очистки кэша (может быть полезна для тестирования)
#func clear_cache():
	#if use_web_storage:
		#JavaScriptBridge.eval("""
			#if (typeof localStorage !== 'undefined') {
				#localStorage.removeItem('game_resources_data');
				#console.log('🗑️ localStorage очищен');
			#}
			#
			#if (typeof indexedDB !== 'undefined') {
				#try {
					#let request = indexedDB.deleteDatabase('GameSaves');
					#request.onsuccess = function() {
						#console.log('🗑️ IndexedDB очищен');
					#};
				#} catch(e) {
					#console.error('❌ Ошибка очистки IndexedDB:', e);
				#}
			#}
		#""")
	#else:
		#var dir = DirAccess.open("user://")
		#if dir:
			#if dir.file_exists(save_path):
				#dir.remove(save_path)
			#print("🗑️ Локальные файлы удалены")
	#
	#create_new_resources()
#
#
#func _on_yandex_language_changed(lang_code: String):
	#print("🌍 Язык изменен: ", lang_code)
	#TranslationServer.set_locale(lang_code)
	#load_translations(lang_code)
#
## Дополнительная функция для экспорта данных
#func export_resources() -> String:
	#return serialize_resources()
#
## Функция для импорта данных (например, из бекапа)
#func import_resources(json_data: String) -> bool:
	#resources = deserialize_resources(json_data)
	#save_resources()
	#print("✅ Ресурсы импортированы")
	#return true


func update_all_ui():
	money_changed.emit(resources.money)
	energy_changed.emit(resources.energy, get_total_max_energy())
	crystals_changed.emit(resources.crystals)
	
	
func add_money(amount: int):
	if amount == 0:
		return		
	resources.total_earn_money += amount
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
		return true
	else:
		return false
		
		
func get_all_close_card_anime():
	var list_cards = []
	for key in resources.open_cards.keys():
		if !resources.open_cards[key]:
			list_cards.append(key)
	return list_cards
	

# покупаем и обновляем карту улучшенй !НЕ КАРТУ АНИМЕ
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

func get_total_shop_income() -> float:
	return resources.boost_shop * resources.passive_income_recovery * resource_card.boost_shop

func get_total_mini_game_boost() -> float:
	return resources.mini_game * resource_card.mini_game
	
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
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_resources()
