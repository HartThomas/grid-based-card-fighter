extends EntityInstance

class_name PlayerInstance

var damage_modifier : int = 0
var damage_taken : int = 0
var effort_spent :int = 0
signal die()
signal exhausted()

func setup(player_data: PlayerData):
	data = player_data

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

func get_starting_effort()->int:
	return data.effort

func get_current_effort()-> int:
	return get_starting_effort() - effort_spent

func spend_effort(amount: int) ->void:
	effort_spent += amount
	if get_current_effort() <= 0:
		exhausted.emit()
