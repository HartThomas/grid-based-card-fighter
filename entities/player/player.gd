extends Node2D

class_name EntityContainer

@export var data : EntityInstance
var current_position : Vector2i = Vector2i(5,0)
var friendly : bool = true
var blocks: Dictionary = {right = null, left = null, up = null, down = null}

func _ready() -> void:
	if !data:
		var new_player = load('res://entities/player/player.tres') as PlayerData
		var instance = PlayerInstance.new()
		instance.data = new_player
		instance.block_used.connect(use_block)
		data = instance
		

func take_damage(amount: int, direction : Vector2i) -> void:
	data.take_damage(amount, direction)

func use_block(direction: Vector2i)-> void:
	var block = blocks[data.convert_vector_direction_to_string(direction)]
	block.remove_line()

func add_block(direction:Vector2i, new_block_line)-> void:
	blocks[data.convert_vector_direction_to_string(direction)] = new_block_line
