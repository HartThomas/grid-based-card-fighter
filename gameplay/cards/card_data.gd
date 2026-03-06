extends Resource

class_name CardData

@export var card_name : String
@export var description : String
@export var base_cost : int
@export var type : CardEnums.type = CardEnums.type.ATTACK
@export var item : CardEnums.item = CardEnums.item.SWORD
@export var base_damage: int = 0
@export var base_block: int = 0

func play()->void:
	print(card_name,' is being played')
