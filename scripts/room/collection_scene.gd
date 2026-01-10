extends Node2D


func _ready() -> void:
	await get_tree().process_frame
	SceneManager._register_button()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
