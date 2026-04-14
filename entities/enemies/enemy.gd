extends Node2D

class_name EnemyContainer

var recalc_path_timer: float = 0.0
@export var data : EnemyInstance
var current_position : Vector2i = Vector2i(5,0)
var path: Array[Vector2i] = []
var move_speed : float = 5.0
var move_delay: float
@onready var animated_sprite: AnimatedEntity = $AnimatedSprite
var friendly: bool = false

signal die(data,pos)

enum States {
	IDLE,
	AGGRO,
	ATTACK,
	COWARD
}

var state : States = States.IDLE
var prev_state = null

func _ready() -> void:
	if !data:
		var new_enemy = load('res://entities/enemies/bogman/bogman.tres') as Enemy
		var instance = EnemyInstance.new()
		instance.setup(new_enemy)
		data = instance
	if data:
		data.die.connect(_die)
	#print(animated_sprite.sprite_name, ' glfojiodfjjoff')
	animated_sprite.sprite_name = data.data.name
	#print(animated_sprite.sprite_name, ' hgdhdh')
	request_new_path()

func take_damage(amount: int) -> void:
	data.take_damage(amount)

func  _process(delta: float) -> void:
	var behavior = data.get_behavior()
	if behavior:
		behavior.get_intent(self)
	var distance_to_player = position.distance_to(get_player_pos())
	match state: 
		States.AGGRO:
			move_along_path()
		States.COWARD:
			move_along_path()
	recalc_path_timer += delta

func move_along_path()->void:
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
		move_delay = 1.0 / move_speed
		CooldownManager.start_cooldown(self, "move", move_delay)

func get_player_pos()-> Vector2:
	return get_parent().instantiated_player_scene.position

func request_new_path() -> void:
	var req = EnemyPathingRequest.new()
	req.entity = self
	req.from = current_position
	match state:
		States.COWARD:
			req.to = get_coward_target()
		_:
			req.to = get_parent().instantiated_player_scene.current_position
	get_parent().pathing_requests.append(req)

func get_direction_away_from_player() -> Vector2i:
	var player_pos = get_parent().instantiated_player_scene.current_position
	var dir = current_position - player_pos
	return Vector2i(sign(dir.x), sign(dir.y))

func get_coward_target() -> Vector2i:
	var dir = get_direction_away_from_player()
	var distance = 3
	return current_position + dir * distance

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
	var attack = data.get_attack()
	attack.execute(self,get_player_pos())
	set_state(States.AGGRO)

func melee_attack() -> void:
	get_parent().enemy_melee_attack(self)

func _die(data:EnemyInstance) ->void:
	die.emit(data,current_position)
	queue_free()
	
