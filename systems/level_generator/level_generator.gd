extends Node

class_name LevelGenerator

#var size = Vector2i(50,50)

func generate_level(size : Vector2i = Vector2i(50,50)) -> Array[Row]:
	
	var level_data = create_empty_level(size.y,size.x)
	create_path([Vector2i(5,0), Vector2i(size.x - 6, size.y -1)],level_data, size)
	return level_data

func create_empty_level(height, width) -> Array[Row]:
	var level_data: Array[Row] = []

	for y in range(height):
		var row = Row.new(width)

		for x in range(width):
			var tile = Tile.new()
			tile.entity = null
			row.tiles[x] = tile

		level_data.append(row)

	return level_data


func create_path(points: Array[Vector2i],level_data: Array[Row], size: Vector2i) -> void:
	var empty_tile = Tile.new()
	empty_tile.terrain = 'empty'
	level_data[points[0].y].set_tile(points[0].x,empty_tile)
	path(points[0], points[points.size() - 1], level_data, size)

func path(next : Vector2i, end_tile: Vector2i, level_data: Array[Row], size: Vector2i) -> void:
	var stack :  Array[Vector2i] = [next]
	while stack.size() > 0:
		var coords_array : Array[Vector2i]= [Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1)]
		var next_tile = check_surrounding_tiles(coords_array, stack.back(), end_tile, level_data, size)
		if next_tile == Vector2i(-1,-1):
			stack.pop_back()
		elif next_tile == end_tile:
			var empty_tile = Tile.new()
			empty_tile.terrain = 'empty'
			level_data[next_tile.y].set_tile(next_tile.x, empty_tile)
			return
		else:
			var empty_tile = Tile.new()
			empty_tile.terrain = 'empty'
			level_data[next_tile.y].set_tile(next_tile.x, empty_tile)
			stack.append(next_tile)
	print('no path found')

func check_surrounding_tiles(coords: Array[Vector2i], centre: Vector2i, end_tile: Vector2i, level_data: Array[Row], size: Vector2i) :
	coords.shuffle()
	var new_tile = centre + coords[0]
	if new_tile.x < size.x and new_tile.x >= 0 and new_tile.y < size.y and new_tile.y >= 0:
		if level_data[new_tile.y] and level_data[new_tile.y].get_tile(new_tile.x).terrain == 'wall':
			return new_tile
		else:
			coords.pop_front()
			if coords.size() > 0:
				return check_surrounding_tiles(coords, centre, end_tile,level_data, size)
	else:
		coords.remove_at(0)
		if coords.size() > 0:
			return check_surrounding_tiles(coords, centre, end_tile,level_data, size)
	return Vector2i(-1,-1)
