extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	SceneManager._register_button()
	


func _on_timer_energy_timeout() -> void:
	GameState.add_energy(int(GameState.get_total_recovery_energy()))


func _on_timer_timeout() -> void:
	$AudioStreamPlayer2D.stop()
	var ad_result = await YandexSDK.show_interstitial_ad()
	
	match ad_result:
		"shown", "closed":
			print("Реклама просмотрена")
		"error":
			print("Ошибка при показе рекламы")
		"no_ad":
			print("Реклама недоступна")
		_:
			print("Неизвестный результат: ", ad_result)
	
	$AudioStreamPlayer2D.play()
