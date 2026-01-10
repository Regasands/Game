extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	SceneManager._register_button()
	


func _on_timer_energy_timeout() -> void:
	GameState.add_energy(int(GameState.get_total_recovery_energy()))
