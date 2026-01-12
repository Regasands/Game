extends Node2D


	
@onready var ru_button: Button = $VBoxContainer/ru
@onready var en_button: Button = $VBoxContainer/en
@onready var kk_button: Button = $VBoxContainer/kk
@onready var de_button: Button = $VBoxContainer/de

var list_button = null
var lang_button = {"ru_RU": 0, "en_EN": 1, "kk_KK": 2,"de_DE": 3, "de": 3,  "en": 1, "ru": 0, "kk": 2}
var color = Color("#6bc46b")
var color_basic = Color("#8b8b8b")


func _ready() -> void:
	list_button = [ru_button, en_button, kk_button, de_button]
	await get_tree().process_frame
	SceneManager._register_button()
	var current_lang = YandexSDK.lang
	if current_lang:
		update_(lang_button.get(current_lang, "ru"))
	else:
		update_(lang_button["ru"])
	create_boost_statistc()
	
	
func _on_ru_pressed() -> void:
	TranslationServer.set_locale("ru")
	update_(0)

func _on_en_pressed() -> void:
	TranslationServer.set_locale("en")
	update_(1)

func _on_kk_pressed() -> void:
	TranslationServer.set_locale("kk")
	update_(2)


func _on_de_pressed() -> void:
	TranslationServer.set_locale("de")
	update_(3)
	
func _change_button_color(index):
	for i in range(4):
		var style_box = list_button[i].get_theme_stylebox("normal") as StyleBoxFlat
		if i == index:
			style_box.bg_color = color
		else:
			style_box.bg_color = color_basic
	
func update_(index_button: int):
	GameState.update_all_ui()
	create_boost_statistc()
	_change_button_color(index_button)
	
func create_boost_statistc():
	var global_boost_money = GameState.get_total_click()
	var global_boost_energy_recovery = GameState.get_total_recovery_energy()
	var global_boost_luck = GameState.get_total_boost_luck()
	var global_boost_discount = GameState.get_total_boost_discount()
	var global_total_clicks = GameState.resources.total_click
	var global_total_money_earn = GameState.resources.total_earn_money
	var global_total_shop_per_sec = GameState.get_total_shop_income()

	var formatted_clicks = _format_number(global_total_clicks)
	var formatted_money = _format_money(global_total_money_earn)
	var formatted_income = _format_money(global_total_shop_per_sec) + "/s"

	var text = ""
	text += tr("stat_total_clicks") + ": " + formatted_clicks + "\n"
	text += tr("stat_money_earned") + ": " + formatted_money + "\n"
	text += tr("stat_passive_income") + ": " + formatted_income + "\n\n"

	text += tr("stat_click_boost") + ": x" + str(global_boost_money) + "\n"
	text += tr("stat_energy_recovery") + ": +" + str(global_boost_energy_recovery) + "/s\n"
	text += tr("stat_luck_boost") + ": x" + str(global_boost_luck) + "\n"
	text += tr("stat_discount_boost") + ": x" + str(global_boost_discount)
	
	$TextEdit.text = text
	$TextEdit.scroll_vertical = 0 

func _format_number(num: float) -> String:
	if num >= 1000000:
		return "%.1fM" % (num / 1000000.0)
	elif num >= 1000:
		return "%.1fK" % (num / 1000.0)
	else:
		return str(int(num))

func _format_money(amount: float) -> String:
	return _format_number(amount)
