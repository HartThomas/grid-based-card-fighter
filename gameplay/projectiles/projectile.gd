extends Node2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var data :ProjectileData

var velocity

func _ready() -> void:
	load_texture()
	resize_area()
	velocity = (data.target - data.attackers_pos).normalized() * data.speed
	rotation = velocity.angle()

func load_texture() -> void:
	var texture_new = load("res://art/sprites/%s.png" % [data.sprite_name])
	sprite_2d.texture = texture_new

func resize_area() ->void:
	collision_shape_2d.shape.size = Vector2(sprite_2d.texture.get_width(),sprite_2d.texture.get_height())

func _process(delta: float) -> void:
	global_position += velocity * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area:
		var parent = area.get_parent()
		if parent.has_method('take_damage'):
			if parent.friendly != data.friendly:
				parent.take_damage(data.damage)
				get_parent().update_health_bar()
				queue_free()
