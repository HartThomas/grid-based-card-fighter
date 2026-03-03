extends Node2D

class_name EnemyContainer

var recalc_path_timer: float = 0.0
@export var data : Enemy
var current_position : Vector2i = Vector2i(5,0)
var path: Array[Vector2i] = []
var move_speed : float = 5.0
var move_delay: float
@onready var animated_sprite: AnimatedEntity = $AnimatedSprite

enum States {
	IDLE,
	AGGRO,
	ATTACK
}

var state = States.IDLE
var prev_state = null

func _ready() -> void:
	if !data:
		var new_enemy = load('res://entities/enemies/bogman/bogman.tres') as Enemy
		data = new_enemy
	request_new_path()
	

func take_damage(amount: int) -> void:
	data.take_damage(amount)

func  _process(delta: float) -> void:
	var distance_to_player = position.distance_to(get_parent().instantiated_player_scene.position)
	match state: 
		States.AGGRO:
			recalc_path_timer += delta
			if recalc_path_timer >= 0.5: # recalc path twice every second
				recalc_path_timer = 0.0
				request_new_path()
			if path.size() > 0 and not CooldownManager.is_on_cooldown(self, "move"):
				var next_tile = path[0] 
				if next_tile:
					var moved = get_parent().move_enemy(self, current_position, next_tile)
					if moved:
						path.pop_front()
				# Start cooldown for movement
				var move_delay = 1.0 / move_speed
				CooldownManager.start_cooldown(self, "move", move_delay)
			if distance_to_player < 64 and not CooldownManager.is_on_cooldown(self, 'attack'):
				set_state(States.ATTACK)
		States.ATTACK:
			if distance_to_player >= 64:
				set_state(States.AGGRO)
		States.IDLE:
			if distance_to_player < 200:
				set_state(States.AGGRO)
	recalc_path_timer += delta


func request_new_path()->void:
	var req = EnemyPathingRequest.new()
	req.entity = self
	req.from = current_position
	req.to = get_parent().instantiated_player_scene.current_position
	get_parent().pathing_requests.append(req)

func set_state(new_state : States):
	if new_state == state:
		return # already in this state
	prev_state = state
	state = new_state
	_on_state_enter(state)

func _on_state_enter(new_state):
	match new_state:
		States.IDLE:
			animated_sprite.animation_name = "idle"
			animated_sprite.setup()
		States.AGGRO:
			animated_sprite.animation_name = "idle"
			animated_sprite.setup()
			recalc_path_timer = 0.0
		States.ATTACK:
			animated_sprite.animation_name = "attack"
			animated_sprite.setup()
			setup()
			CooldownManager.start_cooldown(self, 'attack', 1.0)

func setup() -> void:
	if state == States.ATTACK:
		animated_sprite.animation_finished.connect(post_attack_idle)

func post_attack_idle() :
	get_parent().enemy_attack(data, position)
	set_state(States.AGGRO)
