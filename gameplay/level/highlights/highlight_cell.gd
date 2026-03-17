extends Node2D

class_name CellHighlight

var showing : bool = false
var target_cell : Vector2i
var direction : Vector2i

func _process(delta: float) -> void:
	if showing:
		var mouse_pos = get_global_mouse_position()
		var player = get_parent().get_parent().instantiated_player_scene
		var player_world = player.global_position
		var dir = (mouse_pos - player_world).normalized()
		var grid_dir : Vector2i
		if abs(dir.x) > abs(dir.y):
			grid_dir = Vector2i(sign(dir.x), 0)
		else:
			grid_dir = Vector2i(0, sign(dir.y))
		direction = grid_dir
		var target : Vector2i = player.current_position + grid_dir
		print(target, ' target')
		target_cell = target
		position = target * 32 + Vector2i(16,16)

func show_highlight() -> void:
	showing = true
	show()

func hide_highlight()-> Array[Vector2i]:
	showing = false
	hide()
	print(target_cell, ' in hide')
	return [target_cell, direction]
