# BaseButton.gd
extends Control
class_name BaseButton_

signal button_pressed(action_data: Dictionary)

@onready var audio_click: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var button_type: String = "generic"
@export var button_id: String = ""


var vector_scale = Vector2(1, 1)
func _ready() -> void:
	SceneManager.all_buttons[button_id] = self

func play_sound():
	audio_click.play()
	
func play_click_animation():
	scale = Vector2(1.1, 1.1)
	$Timer.start()
	await $Timer.timeout
	scale = vector_scale
	
	
func on_pressed():
	play_click_animation()
	button_pressed.emit(button_id)


func _on_button_pressed() -> void:
	on_pressed()
