extends EntityInstance

class_name PlayerInstance

var damage_modifier : int = 0
var damage_taken : int = 0
signal die()

func setup(enemy_data: PlayerData):
	data = enemy_data

func get_starting_health() ->  int:
	return data.health

func get_current_health() -> int:
	return get_starting_health() - damage_taken

func get_attack_damage() -> int:
	return data.attack_damage + damage_modifier

func buff_damage(amount: int) ->void:
	damage_modifier += amount

func take_damage(amount: int) -> void:
	damage_taken += amount
	if damage_taken >= get_starting_health():
		die.emit()
