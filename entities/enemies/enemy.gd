extends Node2D

class_name EnemyContainer

@export var data : Enemy
var current_position : Vector2i = Vector2i(5,0)
var path: Array[Vector2i] = []

func _ready() -> void:
	if !data:
		var new_enemy = Enemy.new()
		data = new_enemy

func take_damage(amount: int) -> void:
	data.take_damage(amount)
