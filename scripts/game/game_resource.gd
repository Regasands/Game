class_name GameResources
extends Resource

@export_category("chance")
@export var chance_dict = {
	"common": 0.7,
	"epic": 0.2,
	"legend": 0.1,
}
@export var cristal_by_box: int = 20

@export_category("TotalValue")
@export var total_click: int = 0
@export var total_earn_money: int = 0

@export_category("PassiveIncome")
@export var passive_income_recovery = 0

@export_category("EnergyResource")
@export var energy: int = 100
@export var max_energy: int = 200
@export var energy_click: int = 1
@export var recovery_energy: int  = 2
@export var clicks: int  = 1

@export_category("Base Items")
@export var money: int = 100
@export var crystals: int = 10
@export var keys_common: int = 0
@export var keys_rare: int = 0
@export var equip_card: String = "common_1" 
@export var equip_background: String = "common_1"

@export var open_cards: Dictionary = {
	"common_1": true,
	"common_2": false,
	"common_3": false,
	"epic_1": false,
	"epic_2": false,
	"epic_3": false,
	"epic_4": false,
	"legend_1": false,
}

@export var open_backgrounds: Dictionary = { 
	"common_1": true
}

@export_category("Boosts")
@export var boost_shop: float = 1.0
@export var boost_click: float = 1.0
@export var boost_energy_max: float = 1.0
@export var boost_recorvy_energy: float = 1.0
@export var boost_discount: float = 1.0
@export var mini_game: float = 1.0
@export var critical_chance: float = 1.0
@export var luck: float = 1.0


@export_category("ConnectIdToItems")
@export var dict =  {
		0: boost_click,
		1: boost_shop,
		2: boost_energy_max,
		3: boost_recorvy_energy,
		4: boost_discount,
		5: clicks,
		6: recovery_energy,
		7: max_energy
	}
@export_category("LevelShop")
@export var system_upgrade_shop: Dictionary = {
	1: 0, 2: 0, 3: 0, 4: 0, 5: 0,
	6: 0, 7: 0, 8: 0, 9: 0, 0: 0,
}

@export_category("OpenGame")
@export var open_game: Dictionary = {
	1: true, 2: false, 3: false, 4: false, 5: false,
}

func get_upgrade_level(shop_id: int) -> int:
	return system_upgrade_shop.get(shop_id, 0)
	
func get_boost_by_id(id):
	match id:
		"0": return boost_click
		"1": return boost_shop
		"2": return boost_energy_max
		"3": return boost_recorvy_energy
		"4": return boost_discount
		"5": return clicks
		"6": return recovery_energy
		"7": return max_energy
