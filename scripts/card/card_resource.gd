class_name ResourceCard

extends Resource

@export_category("Basic Info")
@export var card_id: String = ""
@export var name: String = "Новая карта"
@export var type: String = "creature"  # creature, spell, building, enemy
@export var rarity: String = "common"  # common, rare, epic, legendary

@export_category("Stats")
@export var cost: int = 1

@export_category("Visual")
@export var description: String = ""
@export_multiline var description_boost: String = ""
@export var card_texture: Texture2D

@export_category("Boost")
@export var boost_shop: float = 1
@export var boost_click: float = 1
@export var boost_energy_max: float = 1
@export var recovery_energy: float = 1
@export var boost_discount: float = 1
@export var mini_game: float = 1
@export var critical_chance: float = 1
@export var luck: float = 1



# Функция для отладки
func _to_string() -> String:
	return "kl"
