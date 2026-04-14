extends EntityInstance

class_name PlayerInstance

var damage_modifier : int = 0
var damage_taken : int = 0
var effort_spent :int = 0
signal die()
signal exhausted()
var directions_blocked_in : Dictionary = {right = false, left = false, up = false, down = false}
signal block_used(direction)

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

func take_damage(amount: int, direction: Vector2i) -> void:
	if not get_block_in_direction(direction):
		damage_taken += amount
		if damage_taken >= get_starting_health():
			die.emit()
	else:
		use_block_in_direction(direction)
		block_used.emit(direction)

func get_starting_effort()->int:
	return data.effort

func get_current_effort()-> int:
	return get_starting_effort() - effort_spent

func spend_effort(amount: int) ->void:
	effort_spent += amount
	if get_current_effort() <= 0:
		exhausted.emit()

func convert_vector_direction_to_string(v_dir : Vector2i)-> String:
	var key := ""

	match v_dir:
		Vector2i.UP:
			key = "up"
		Vector2i.DOWN:
			key = "down"
		Vector2i.LEFT:
			key = "left"
		Vector2i.RIGHT:
			key = "right"
		_:
			print(v_dir, ' not a direction')
	return key

func block_in_a_direction(dir:Vector2i) -> void:
	directions_blocked_in[convert_vector_direction_to_string(dir)] = true

func get_block_in_direction(dir:Vector2i)-> bool:
	return directions_blocked_in[convert_vector_direction_to_string(dir)]

func use_block_in_direction(dir:Vector2i) -> void:
	if get_block_in_direction(dir):
		directions_blocked_in[convert_vector_direction_to_string(dir)] = false
	else:
		print('Attempted to use block in the ' + convert_vector_direction_to_string(dir) + ' direction, but there was no block')
