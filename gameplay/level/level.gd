extends Node2D

class_name LevelScene

var generator = preload("res://systems/level_generator/level_generator.gd")
var level_data : Array[Row] = []
var astar_grid : AStarGrid2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
const PLAYER = preload("res://entities/player/player.tscn")
const ENEMY = preload("res://entities/enemies/enemy.tscn")
var instantiated_player_scene : EntityContainer
var key_clicked : bool = false
var data : Option

func _ready() -> void:
	var level_generator = generator.new() as LevelGenerator
	if data:
		level_data = level_generator.generate_level(data.size)
	fill_tile_map_layer_using_data()
	create_astar()
	add_player()
	if data.enemies.size() >0:
		add_enemies(data.enemies, level_generator)

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

func add_enemies(enemies: Array[Enemy], level_generator: LevelGenerator)-> void:
	var random_tile = level_generator.random_free_cell(1)
	var spawn_cells = level_generator.get_random_cells_around(random_tile[0], 5, enemies.size())
	for i in range(enemies.size()):
		var enemy_scene = ENEMY.instantiate()
		var enemy_pos : Vector2i = spawn_cells[i]
		enemy_scene.position = enemy_pos * 32
		enemy_scene.current_position = enemy_pos
		add_child(enemy_scene)
		add_entity_to_tile(enemy_scene.data, enemy_pos)

func add_entity_to_tile(entity: Entity, tile :Vector2i) ->void:
	level_data[tile.y].set_tile_entity(tile.x,entity)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not key_clicked:
			key_clicked = true
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
		if event.is_released():
			key_clicked = false

func move_entity(entity: EntityContainer, from :Vector2i, to: Vector2i) -> void:
	var data = entity.data
	var entity_at_current_position = level_data[from.y].get_tile(from.x).entity
	
	if data == entity_at_current_position:
		if !can_entity_move_there(to):
			print('something is in the way')
		else:
			level_data[to.y].set_tile_entity(to.x, data)
			astar_grid.set_point_solid(to, false)
			level_data[from.y].set_tile_entity(from.x, null)
			astar_grid.set_point_solid(from, true)
			entity.position = to * 32
			entity.current_position = to
	else:
		print('The entity ' + str(entity) + ' does not exist at ' + str(from))

func move_enemy(entity: EnemyContainer, from :Vector2i, to: Vector2i) -> void:
	var data = entity.data
	var entity_at_current_position = level_data[from.y].get_tile(from.x).entity
	
	if data == entity_at_current_position:
		if !can_entity_move_there(to):
			print('something is in the way')
		else:
			level_data[to.y].set_tile_entity(to.x, data)
			astar_grid.set_point_solid(to, false)
			level_data[from.y].set_tile_entity(from.x, null)
			astar_grid.set_point_solid(from, true)
			entity.position = to * 32
			entity.current_position = to
	else:
		print('The entity ' + str(entity) + ' does not exist at ' + str(from))

func can_entity_move_there(target : Vector2i) -> bool:
	if target.x < 0 or target.x >= data.size.x or target.y < 0 or target.y >= data.size.y:
		print('trying to move out of bounds')
		return false
	var target_tile = level_data[target.y].get_tile(target.x)
	if target_tile.entity:
		if not target_tile.entity.name:
			print(target_tile.terrain,' terrain ', target_tile.entity.health, ' health', target_tile.entity.name, ' name')
	return target_tile.terrain != 'wall' and !target_tile.entity

func create_astar() -> void:
	var astar = AStarGrid2D.new()
	var width = level_data[0].tiles.size()
	var height = level_data.size()
	print('width ', width, height, 'height')
	astar.region = Rect2i(0, 0, width, height)
	astar.cell_size = Vector2(1, 1)
	astar.update()
	for y in range(height):
		for x in range(width):
			var pos = Vector2i(x, y)
			var solid = not can_entity_move_there(pos)
			astar.set_point_solid(pos, solid)
	astar_grid = astar

func recalculate_path(from, to) -> Array[Vector2i]:
	var path : Array[Vector2i] = []
	if astar_grid.is_in_bounds(from.x, from.y) and astar_grid.is_in_bounds(to.x, to.y):
		path = astar_grid.get_id_path(from, to)
		if path.size() > 1 and path[0] == from:
			path.remove_at(0)
			path.pop_back()
	else:
		print("Missing point in AStar:", from, to)
	return path

var pathing_requests : Array[EnemyPathingRequest] = []

func handle_repathing() -> void:
	if pathing_requests.size() > 0:
		var request = pathing_requests.pop_front() as EnemyPathingRequest
		var new_path = recalculate_path(request.from, request.to)
		request.entity.path = new_path

func _process(delta: float) -> void:
	handle_repathing()
