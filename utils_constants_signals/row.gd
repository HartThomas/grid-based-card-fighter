extends RefCounted

class_name Row

var tiles : Array[Tile] = []
var width : int = 0

func _init(width: int = 0) -> void:
	if width > 0:
		width = width
		tiles.resize(width)

func get_tile(x: int) -> Tile:
	if not x > tiles.size():
		return tiles[x]
	else:
		var fake_tile = Tile.new()
		return fake_tile

func set_tile(x: int, tile: Tile) -> void:
	tiles[x] = tile

func set_tile_entity(x :int, entity: EntityInstance) -> void:
	var tile = get_tile(x)
	tile.set_entity(entity)
