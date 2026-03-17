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
var card_manager : CardManager
@onready var card_slot1: Control = $CanvasLayer/CardContainer/MarginContainer/CardSlot
@onready var card_slot2: Control = $CanvasLayer/CardContainer/MarginContainer2/CardSlot
@onready var card_slot3: Control = $CanvasLayer/CardContainer/MarginContainer3/CardSlot
var card_scene := preload("res://gameplay/cards/card.tscn")
@onready var highlight_cell: CellHighlight = $TileMapLayer/HighlightCell
var can_player_move : bool = true
const ATTACK_ANIMATION = preload("res://gameplay/attacks/attack_animation.tscn")
var card_slots : Array[Control]

func _ready() -> void:
	var level_generator = generator.new() as LevelGenerator
	if data:
		level_data = level_generator.generate_level(data.size)
	fill_tile_map_layer_using_data()
	create_astar()
	add_player()
	if data.enemies.size() > 0:
		add_enemies(data.enemies, level_generator)
	var cm = CardManager.new()
	card_manager = cm
	card_slots = [card_slot1, card_slot2, card_slot3]
	setup_starting_deck()
	draw_hand()

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
		enemy_scene.data = enemies[i]
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
	if can_player_move:
		var data = entity.data
		var entity_at_current_position = level_data[from.y].get_tile(from.x).entity
		
		if data == entity_at_current_position:
			if !can_entity_move_there(to):
				#print('something is in the way')
				pass
			else:
				level_data[to.y].set_tile_entity(to.x, data)
				#astar_grid.set_point_solid(to, false)
				level_data[from.y].set_tile_entity(from.x, null)
				#astar_grid.set_point_solid(from, true)
				entity.position = to * 32
				entity.current_position = to
		else:
			print('The entity ' + str(entity) + ' does not exist at ' + str(from))

func move_enemy(entity: EnemyContainer, from :Vector2i, to: Vector2i) -> bool:
	var data = entity.data
	var entity_at_current_position = level_data[from.y].get_tile(from.x).entity
	
	if data == entity_at_current_position:
		if !can_entity_move_there(to):
			#print('something is in the way')
			entity.path = recalculate_path(entity.current_position, instantiated_player_scene.current_position)
			return false
		else:
			level_data[to.y].set_tile_entity(to.x, data)
			#astar_grid.set_point_solid(to, false)
			level_data[from.y].set_tile_entity(from.x, null)
			#astar_grid.set_point_solid(from, true)
			entity.position = to * 32
			entity.current_position = to
			return true
	else:
		print('The entity ' + str(entity) + ' does not exist at ' + str(from))
		return false

func can_entity_move_there(target : Vector2i) -> bool:
	if target.x < 0 or target.x >= data.size.x or target.y < 0 or target.y >= data.size.y:
		return false
	var target_tile = level_data[target.y].get_tile(target.x)
	if target_tile.entity:
		if not target_tile.entity.name:
			pass
	return target_tile.terrain != 'wall' and !target_tile.entity

func create_astar() -> void:
	var astar = AStarGrid2D.new()
	var width = level_data[0].tiles.size()
	var height = level_data.size()
	astar.region = Rect2i(0, 0, width, height)
	astar.cell_size = Vector2(1, 1)
	astar.update()
	for y in range(height):
		for x in range(width):
			var pos = Vector2i(x, y)
			var solid = not can_entity_move_there(pos)
			astar.set_point_solid(pos, solid)
	astar_grid = astar

var reserved_tiles :Dictionary = {}

func recalculate_path(from, to) -> Array[Vector2i]:
	var targets = get_available_adjacent_tiles(to)
	if targets.is_empty():
		return []
	targets.sort_custom(func(a, b):
		return from.distance_to(a) < from.distance_to(b)
	)
	var chosen_target = targets[0]
	var path : Array[Vector2i] = []
	if astar_grid.is_in_bounds(from.x, from.y) and astar_grid.is_in_bounds(chosen_target.x, chosen_target.y):
		path = astar_grid.get_id_path(from, chosen_target)
		if not reserved_tiles.has(chosen_target):
			reserved_tiles[chosen_target] = true
		if path.size() > 1 and path[0] == from:
			path.remove_at(0)
			#path.pop_back()
	else:
		print("Missing point in AStar:", from, chosen_target)
	return path

func get_adjacent_tiles(pos: Vector2i) -> Array[Vector2i]:
	return [
		pos + Vector2i.LEFT,
		pos + Vector2i.RIGHT,
		pos + Vector2i.UP,
		pos + Vector2i.DOWN
	]

func get_available_adjacent_tiles(player_pos: Vector2i) -> Array[Vector2i]:
	var options : Array[Vector2i] = []
	for tile in get_adjacent_tiles(player_pos):
		if can_entity_move_there(tile):
			options.append(tile)
	return options

var pathing_requests : Array[EnemyPathingRequest] = []

func handle_path_requests() -> void:
	if pathing_requests.size() > 0:
		for i in range(pathing_requests.size()):
			var request = pathing_requests.pop_front() as EnemyPathingRequest
			var new_path = recalculate_path(request.from, request.to)
			request.entity.path = new_path

func _process(delta: float) -> void:
	reserved_tiles.clear()
	handle_path_requests()

func enemy_attack(data:Enemy, pos) -> void:
	if data.has_method('attack'):
		var damage_to_player = data.attack()
		instantiated_player_scene.data.take_damage(damage_to_player)

func setup_starting_deck():
	var shwick_data = preload("res://resources/cards/shwick.tres")
	for i in 5:
		var card = CardInstance.new()
		card.setup(shwick_data)
		card_manager.cards_owned.append(card)
		card_manager.add_card_to_deck(card)
	card_manager.deck.shuffle()

func draw_hand() -> void:
	var drawn = card_manager.draw_cards(3)
	for i in range(drawn.size()):
		var card_node = card_scene.instantiate()
		card_node.card_drag_started.connect(_on_card_drag_started)
		card_node.card_drag_ended.connect(_on_card_drag_ended)
		card_node.card_played.connect(_on_card_played)
		card_slots[i].add_child(card_node)

func _on_card_drag_started() -> void:
	highlight_cell.show_highlight()
	can_player_move = false

var target_highlighted : Vector2i
var target_dir : Vector2i

func _on_card_drag_ended() -> void:
	var targets : Array[Vector2i] = highlight_cell.hide_highlight()
	can_player_move = true
	print(targets)
	target_highlighted = targets[0]
	target_dir = targets[1]

func _on_card_played(card:CardInstance)->void:
	print('card played')
	var attack_scene = ATTACK_ANIMATION.instantiate()
	attack_scene.attack_finished.connect(attack_damage)
	add_child(attack_scene)
	attack_scene._setup(card,target_highlighted,target_dir)

func attack_damage(data:CardInstance)-> void:
	var tiles = get_target_tiles(instantiated_player_scene.current_position,target_dir,data.data.attack_pattern)
	for tile in tiles:
		var target = level_data[tile.y].get_tile(tile.x)
		if target.entity:
			target.entity.take_damage(data.get_damage())
			print(target.entity.health)
	

func get_target_tiles(origin: Vector2i, direction: Vector2i, pattern: Array[Vector2i]) -> Array[Vector2i]:
	var tiles : Array[Vector2i] = []
	for offset in pattern:
		var rotated = rotate_pattern(offset, direction)
		tiles.append(origin + rotated)
	return tiles

func rotate_pattern(offset: Vector2i, dir: Vector2i) -> Vector2i:
	match dir:
		Vector2i.RIGHT:
			return offset
		Vector2i.LEFT:
			return Vector2i(-offset.x, -offset.y)
		Vector2i.DOWN:
			return Vector2i(-offset.y, offset.x)
		Vector2i.UP:
			return Vector2i(offset.y, -offset.x)
		_:
			return offset
