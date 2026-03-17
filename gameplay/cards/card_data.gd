extends Resource

class_name CardData

@export var card_name : String
@export var description : String
@export var base_cost : int
@export var type : CardEnums.type = CardEnums.type.ATTACK
@export var item : CardEnums.item = CardEnums.item.SWORD
@export var base_damage: int = 0
@export var base_block: int = 0
@export var attack_pattern : Array[Vector2i]   # relative tile positions
@export var attack_size : Vector2i = Vector2i(32, 32)
@export var rotate_to_direction : bool = true

func play()->void:
	print(card_name,' is being played')
