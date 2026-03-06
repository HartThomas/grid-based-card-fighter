extends Resource

class_name CardInstance

@export var data: CardData

var temporary_cost_modifier := 0
var upgraded : int = 0
var damage_modifier : int = 0
var cost_modifier : int = 0

enum card_type {attack, block, misc}

func setup(card_data: CardData):
	data = card_data

func get_damage() -> int:
	return data.base_damage + damage_modifier

func buff_damage(amount: int) ->void:
	damage_modifier += amount

func change_cost(amount : int)->void:
	cost_modifier += amount

func get_cost() -> int:
	return data.base_cost + cost_modifier

func get_type() -> CardEnums.type:
	return data.type

func get_item() -> CardEnums.item:
	return data.item
