extends Node2D

class_name CellHighlight

var showing : bool = false
var target_cell : Vector2i
var direction : Vector2i
@onready var sprite_2d: Sprite2D = $Sprite2D
var data : CardInstance

func _setup(item: String, card_data: CardInstance)->void:
	data = card_data
	var new_texture = load("res://art/sprites/%s_highlight_cell.png" % [item])
	sprite_2d.texture = new_texture
	var rotation = rotate_pattern(direction)
	sprite_2d.rotation = rotation

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
		if grid_dir != direction:
			var rotation = rotate_pattern(grid_dir)
			sprite_2d.rotation = rotation
			direction = grid_dir
		if data.get_item() == CardEnums.item.SHIELD:
			position = player.global_position + (Vector2(grid_dir) * 16) + Vector2(16,16)
		else:
			var target : Vector2i = player.current_position + grid_dir
			target_cell = target
			position = target * 32 + Vector2i(16,16)

func show_highlight() -> void:
	showing = true
	show()

func hide_highlight()-> Array[Vector2i]:
	showing = false
	hide()
	return [target_cell, direction]

func rotate_pattern( dir: Vector2i) -> float:
	match dir:
		Vector2i.RIGHT:
			return deg_to_rad(0)
		Vector2i.LEFT:
			return deg_to_rad(180)
		Vector2i.DOWN:
			return deg_to_rad(90)
		Vector2i.UP:
			return deg_to_rad(270)
		_:
			return deg_to_rad(0)
