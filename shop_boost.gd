# upgrade_template.gd
extends Resource
class_name UpgradeTemplate

@export_category("Template Info")
@export var id: int = 11 # Уникальный ID: "shop_boost_1"
@export var name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D

@export_category("Base Stats")
@export_range(100, 2000.0, 0.01) var base_cost: float = 1.0
@export_range(1, 10, 0.01) var exp_cost_rise: float = 0.1

@export_category("Boost Type")
@export_enum("boost_shop","new_clicks","new_recovery_energy", "new_max_energy",
 "boost_click", "boost_energy_max", "recovery_energy", "boost_discount") 
var boost_type: String = "shop"

@export_category("Type")
@export_enum("boost", "additional_res")
var type: String = "boost"

@export_category("Boost Values")
@export_range(1, 2000.0, 0.01) var base_value: float = 1.0
@export_range(1, 5.0, 0.01) var value_per_level: float = 0.1

func calculate_cost(level: int) -> int:
	return int(base_cost * pow(exp_cost_rise, level))
		
		
func calculate_value(level: int, last_value=0) -> int:
	if type == "boost":
		return int(base_value + (value_per_level * level))
	else:
		var additional_value
		if boost_type == "new_recovery_energy":
			additional_value = 1
		elif boost_type == "new_max_energy":
			additional_value = 100
		else:
			additional_value = 2
		return last_value + int(base_value + additional_value +  pow(value_per_level, level))


	
