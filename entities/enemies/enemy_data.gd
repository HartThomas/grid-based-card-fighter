extends Entity

class_name Enemy

@export var health : int
@export var speed : float
@export var attack_damage : int

func take_damage(amount:int)->void:
	health -= amount

func attack() ->int:
	return attack_damage
