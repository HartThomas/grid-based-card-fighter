extends Node2D

class_name EntityContainer

@export var data : PlayerData
var current_position : Vector2i = Vector2i(5,0)

func _ready() -> void:
	if !data:
		var new_player = PlayerData.new()
		data = new_player
