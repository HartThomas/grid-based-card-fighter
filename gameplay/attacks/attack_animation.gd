extends AnimatedSprite2D

signal attack_finished(data)

func _setup(data: CardInstance, target_cell : Vector2i, direction: Vector2i) -> void:
	var attack_type = data.get_item()
	animation = CardEnums.item.keys()[attack_type].to_lower()
	play()
	var card_data = data.data
	global_position = target_cell * 32
	if card_data.rotate_to_direction:
		rotation = direction_to_rotation(direction)
	offset = get_offset_for_direction(direction, card_data.attack_size)
	animation_finished.connect(finished.bind(data))

func direction_to_rotation(dir: Vector2i) -> float:
	match dir:
		Vector2i.RIGHT:
			return 0
		Vector2i.DOWN:
			return deg_to_rad(90)
		Vector2i.LEFT:
			return deg_to_rad(180)
		Vector2i.UP:
			return deg_to_rad(270)
		_:
			return 0

func get_offset_for_direction(dir: Vector2i, size: Vector2i) -> Vector2:
	var half = size / 2

	match dir:
		Vector2i.RIGHT:
			return Vector2(half.x - 16, 0) + Vector2(16,16)
		Vector2i.LEFT:
			return Vector2(-(half.y - 16), 0) + Vector2(16,-16)
		Vector2i.DOWN:
			return Vector2(0, half.y - 16) + Vector2(16,-48)
		Vector2i.UP:
			return Vector2(0, -(half.y - 16)) + Vector2(-16,48)
		_:
			return Vector2.ZERO

func finished(data: CardInstance)-> void:
	attack_finished.emit(data)
	queue_free()
