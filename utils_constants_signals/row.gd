extends RefCounted

class_name Row

var tiles : Array[Tile] = []
var width : int = 0

func _init(width: int = 0) -> void:
	if width > 0:
		width = width
		tiles.resize(width)

func get_tile(x: int) -> Tile:
	return tiles[x]

func set_tile(x: int, tile: Tile) -> void:
	tiles[x] = tile
