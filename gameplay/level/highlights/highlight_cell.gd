extends Node2D

var showing : bool = false

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

		var target_cell = player.current_position + grid_dir
		
		position = target_cell * 32 + Vector2i(16,16)

func show_highlight() -> void:
	showing = true
	show()

func hide_highlight()-> void:
	showing = false
	hide()
