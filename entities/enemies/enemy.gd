extends Node2D

class_name EnemyContainer

@export var data : Enemy
var current_position : Vector2i = Vector2i(5,0)
var path: Array[Vector2i] = []
var move_speed : float = 5.0
var move_delay: float

func _ready() -> void:
	if !data:
		var new_enemy = Enemy.new()
		data = new_enemy
	var req = EnemyPathingRequest.new()
	req.entity = self
	req.from = current_position
	req.to = Vector2i(5,0)
	get_parent().pathing_requests.append(req)

func take_damage(amount: int) -> void:
	data.take_damage(amount)

func  _process(delta: float) -> void:
	if path.size() > 0 and not CooldownManager.is_on_cooldown(self, "move"):
		var next_tile = path.pop_front()
		if next_tile:
			get_parent().move_enemy(self, current_position, next_tile)
		# Start cooldown for movement
		var move_delay = 1.0 / move_speed
		CooldownManager.start_cooldown(self, "move", move_delay)
