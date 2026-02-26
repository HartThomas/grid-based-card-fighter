extends Entity

class_name Enemy

@export var health : int
@export var speed : float

func take_damage(amount:int)->void:
	health -= amount
