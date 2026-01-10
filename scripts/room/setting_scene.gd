extends Node2D


	
@onready var ru_button: Button = $VBoxContainer/ru
@onready var en_button: Button = $VBoxContainer/en
@onready var es_button: Button = $VBoxContainer/es

var list_button = null
var lang_button = {"ru_RU": 0, "en_EN": 1, "es_ES": 2}
var color = Color("#6bc46b")
var color_basic = Color("#8b8b8b")


func _ready() -> void:
	list_button = [ru_button, en_button, es_button]
	await get_tree().process_frame
	SceneManager._register_button()
	var current_lang = TranslationServer.get_locale()
	update_(lang_button[current_lang])
	
	
func _on_ru_pressed() -> void:
	TranslationServer.set_locale("ru")
	update_(0)

func _on_en_pressed() -> void:
	TranslationServer.set_locale("en")
	update_(1)

func _on_es_pressed() -> void:
	TranslationServer.set_locale("es")
	update_(2)

func _change_button_color(index):
	for i in range(3):
		var style_box = list_button[i].get_theme_stylebox("normal") as StyleBoxFlat
		if i == index:
			style_box.bg_color = color
		else:
			style_box.bg_color = color_basic
	
func update_(index_button: int):
	GameState.update_all_ui()
	_change_button_color(index_button)
	
#func create_boost_statistc():
	#for i in range(GameState.global_boost):
		#$TextEdit
