extends AnimatedSprite2D

signal block_finished(data)

func _setup(data: CardInstance) -> void:
	var attack_type = data.get_item()
	animation = CardEnums.item.keys()[attack_type].to_lower()
	play()
	animation_finished.connect(finished.bind(data))

func finished(data: CardInstance)-> void:
	block_finished.emit(data)
	queue_free()
