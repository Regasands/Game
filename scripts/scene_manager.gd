extends Node


var all_buttons: Dictionary = {}
var all_buttons_change_scene = {
	"shop": "res://scenes/rooms/shop_scene.tscn",
	"home": "res://scenes/rooms/main_scene.tscn",
	"collection": "res://scenes/rooms/collection_scene.tscn",
	"setting": "res://scenes/rooms/setting_scene.tscn"
}
func _register_button() -> void:
	for button_id in all_buttons.keys():
		var button = all_buttons[button_id]
		if button:
			button.button_pressed.connect(_on_any_button_pressed)
			
		
func clear_all_connections():
	for button_ref in all_buttons.values():
		var button = button_ref
		if button:
			button.button_pressed.disconnect(_on_any_button_pressed)
		all_buttons.clear()
		
		
func _on_any_button_pressed(button_id: String):
	if all_buttons_change_scene.get(button_id, false):
		get_tree().change_scene_to_file(all_buttons_change_scene[button_id])
		clear_all_connections()
	
	
	
