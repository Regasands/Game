extends Node2D
@onready var boost_button = $ClickerScene/HBoxContainer/button_shop_boost
@onready var keys_button  = $ClickerScene/HBoxContainer/button_shop_keys

var buttons_children = {
	"button_shop_boost": "res://scenes/additional/children_shop/shop_boost_scene.tscn",
	"button_shop_keys": "res://scenes/additional/children_shop/shop_keys_scene.tscn"
}	
func _ready() -> void:
	await get_tree().process_frame
	SceneManager._register_button()
	boost_button.button_pressed.connect(_connect_local_scene)
	keys_button.button_pressed.connect(_connect_local_scene)
	

func _connect_local_scene(button_id) -> void:
	print(button_id)
	var old_child = $CurrentScene
	remove_child(old_child)
	old_child.queue_free()
	var new_scene = load(buttons_children[button_id]).instantiate()
	new_scene.name = "CurrentScene"
	add_child(new_scene)
