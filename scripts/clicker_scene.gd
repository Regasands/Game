# UI.gd
extends Control

@onready var money_label = $Panel/VBoxContainer/Money
@onready var energy_label = $Panel/VBoxContainer/Energy
@onready var diamond_label = $Panel/VBoxContainer/Diamond



func _ready() -> void:
	# Подписываемся на сигналы изменения ресурсов
	await get_tree().process_frame
   
	GameState.money_changed.connect(_on_money_changed)
	GameState.energy_changed.connect(_on_energy_changed)
	GameState.crystals_changed.connect(_on_crystals_changed)
	
	# Инициализируем начальные значения
	_on_money_changed(GameState.resources.money)
	_on_energy_changed(GameState.resources.energy, 
	int(GameState.get_total_max_energy()))
	_on_crystals_changed(GameState.resources.crystals)

# Обработчики сигналов
func _on_money_changed(new_value: int) -> void:
	money_label.text = " %s: %s" % [tr("ui_money"), format_number(new_value)]
	animate_label(money_label)

func _on_energy_changed(new_value: int, max_value: int) -> void:
	
	energy_label.text =  " %s: %s/%s" % [tr("ui_energy"), 
		format_number(new_value), format_number(max_value)]
	if new_value < max_value * 0.2:
		energy_label.modulate = Color.RED
		
	else:
		energy_label.modulate = Color.WHITE

func _on_crystals_changed(new_value: int) -> void:
	diamond_label.text = " %s: %s" % [tr("ui_crystals"), format_number(new_value)]



func format_number(value: int) -> String:
	if value >= 1000000:
		return "%.1fM" % (value / 1000000.0)
	elif value >= 1000:
		return "%.1fK" % (value / 1000.0)
	else:
		return str(value)

func animate_label(label: Label):
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)
	
	
func _exit_tree() -> void:
	if GameState.money_changed.is_connected(_on_money_changed):
		GameState.money_changed.disconnect(_on_money_changed)
	if GameState.energy_changed.is_connected(_on_energy_changed):
		GameState.energy_changed.disconnect(_on_energy_changed)
	if GameState.crystals_changed.is_connected(_on_crystals_changed):
		GameState.crystals_changed.disconnect(_on_crystals_changed)
