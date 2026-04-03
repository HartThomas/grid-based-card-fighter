extends Node2D

class_name EntityContainer

@export var data : EntityInstance
var current_position : Vector2i = Vector2i(5,0)
var friendly : bool = true

func _ready() -> void:
	if !data:
		var new_player = load('res://entities/player/player.tres') as PlayerData
		var instance = PlayerInstance.new()
		instance.data = new_player
		data = instance

func take_damage(amount: int) -> void:
	data.take_damage(amount)
