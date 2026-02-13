extends Node2D

class_name LevelScene

var generator = preload("res://systems/level_generator/level_generator.gd")
var level_data : Array[Row] = []
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
var size = Vector2i(10,10)
const PLAYER = preload("res://entities/player/player.tscn")

func _ready() -> void:
	var level_generator = generator.new() as LevelGenerator
	level_data = level_generator.generate_level(size)
	fill_tile_map_layer_using_data()
	add_player()


func fill_tile_map_layer_using_data() -> void:
	tile_map_layer.clear()
	var height = level_data.size()
	var width = level_data[0].tiles.size()
	var cells : Array[Vector2i] = []
	for y in range(height):
		for x in range(width):
			var terrain = level_data[y].get_tile(x).terrain
			if terrain == 'wall':
				tile_map_layer.set_cell(Vector2i(x,y),1,Vector2i(0,3))
				cells.append(Vector2i(x,y))
			if terrain == 'empty':
				continue
	tile_map_layer.set_cells_terrain_connect(cells,0,0)

func add_player()-> void:
	var player_scene = PLAYER.instantiate()
	var player_pos : Vector2i = Vector2i(5,0)
	player_scene.position = player_pos * 32
	add_child(player_scene)
	add_entity_to_tile(player_scene.player_data, player_pos)

func add_entity_to_tile(entity: Entity, tile :Vector2i) ->void:
	level_data[tile.y].set_tile_entity(tile.x,entity)
