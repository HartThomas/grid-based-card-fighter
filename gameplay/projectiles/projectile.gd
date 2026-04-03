extends Node2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var data 

func _ready() -> void:
	load_texture()
	resize_area()

func load_texture() -> void:
	var texture_new = load("res://art/sprites/arrow.png")
	sprite_2d.texture = texture_new

func resize_area() ->void:
	print(collision_shape_2d.shape.size)
	collision_shape_2d.shape.size = Vector2(sprite_2d.texture.get_width(),sprite_2d.texture.get_height())
	print(collision_shape_2d.shape.size)

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area:
		var parent = area.get_parent()
		if parent.has_method('take_damage'):
			if parent.friendly:
				parent.take_damage(data.damage)
				queue_free()
