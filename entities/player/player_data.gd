extends Entity

class_name PlayerData

@export var health : int

signal death

func take_damage(amount: int) -> void:
	health -= amount
	if health < 0:
		die()

func die() -> void:
	death.emit()

func heal(amount : int) -> void:
	health += amount
