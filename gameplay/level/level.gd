extends Node2D

class_name LevelScene

var generator = preload("res://systems/level_generator/level_generator.gd")
var level_data : Array[Row] = []
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
var size = Vector2i(10,10)
const PLAYER = preload("res://entities/player/player.tscn")
var instantiated_player_scene : EntityContainer

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
	add_entity_to_tile(player_scene.data, player_pos)
	instantiated_player_scene = player_scene

func add_entity_to_tile(entity: Entity, tile :Vector2i) ->void:
	level_data[tile.y].set_tile_entity(tile.x,entity)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		match event.as_text_keycode():
			'Down':
				var current_position = instantiated_player_scene.current_position
				move_entity(instantiated_player_scene, current_position, Vector2i(current_position.x, current_position.y+1))
			'Up':
				var current_position = instantiated_player_scene.current_position
				move_entity(instantiated_player_scene, current_position, Vector2i(current_position.x, current_position.y-1))
			'Right':
				var current_position = instantiated_player_scene.current_position
				move_entity(instantiated_player_scene, current_position, Vector2i(current_position.x+1, current_position.y))
			'Left':
				var current_position = instantiated_player_scene.current_position
				move_entity(instantiated_player_scene, current_position, Vector2i(current_position.x-1, current_position.y))

func move_entity(entity: EntityContainer, from :Vector2i, to: Vector2i) -> void:
	var data = entity.data
	var entity_at_current_position = level_data[from.y].get_tile(from.x).entity
	
	if data == entity_at_current_position:
		if !can_entity_move_there(to):
			print('something is in the way')
		else:
			level_data[to.y].set_tile_entity(to.x, data)
			level_data[from.y].set_tile_entity(from.x,null)
			entity.position = to * 32
			entity.current_position = to
	else:
		print('The entity ' + str(entity) + ' does not exist at ' + str(from))

func can_entity_move_there(target : Vector2i) -> bool:
	var target_tile = level_data[target.y].get_tile(target.x)
	if target_tile.entity:
		print(target_tile.terrain,' terrain ', target_tile.entity.health, 'heath', target_tile.entity.name, ' name')
	return target_tile.terrain != 'wall' and !target_tile.entity
