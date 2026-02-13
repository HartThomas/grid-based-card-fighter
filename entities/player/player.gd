extends Node2D

class_name Player

@export var player_data : PlayerData

func _ready() -> void:
	if !player_data:
		var new_player = PlayerData.new()
		player_data = new_player
