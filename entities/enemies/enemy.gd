extends Node2D

class_name EnemyContainer

var recalc_path_timer: float = 0.0
@export var data : Enemy
var current_position : Vector2i = Vector2i(5,0)
var path: Array[Vector2i] = []
var move_speed : float = 5.0
var move_delay: float

func _ready() -> void:
	if !data:
		var new_enemy = Enemy.new()
		data = new_enemy
	request_new_path()

func take_damage(amount: int) -> void:
	data.take_damage(amount)

func  _process(delta: float) -> void:
	if path.size() > 0 and not CooldownManager.is_on_cooldown(self, "move"):
		var next_tile = path[0] 
		if next_tile:
			var moved = get_parent().move_enemy(self, current_position, next_tile)
			if moved:
				path.pop_front()
		# Start cooldown for movement
		var move_delay = 1.0 / move_speed
		CooldownManager.start_cooldown(self, "move", move_delay)
	recalc_path_timer += delta
	if recalc_path_timer >= 0.5: # recalc path twice every second
		recalc_path_timer = 0.0
		request_new_path()

func request_new_path()->void:
	var req = EnemyPathingRequest.new()
	req.entity = self
	req.from = current_position
	req.to = get_parent().instantiated_player_scene.current_position
	get_parent().pathing_requests.append(req)
