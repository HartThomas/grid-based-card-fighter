
extends VBoxContainer

class_name LevelOption

const ANIMATED_SPRITE = preload("res://entities/animated_sprite/animated_sprite.tscn") 
var level_number = 1
var option_data : Option
@onready var enemies_container: HBoxContainer = $EnemiesMarginContainer/EnemiesVBoxContainer/EnemiesContainer
@onready var loot_container: HBoxContainer = $LootMarginContainer/LootHBoxContainer/LootContainer
signal option_clicked(option_data)

func _ready() -> void:
	var data = load("res://resources/levels/campaign/level_1.tres") as Level
	for enemy in option_data.enemies:
		if enemy:
			var sprite = ANIMATED_SPRITE.instantiate() as AnimatedEntity
			sprite.sprite_name = enemy.name
			add_to_enemies(sprite)
	for loot in option_data.loot:
		if loot:
			var loot_sprite = TextureRect.new()
			loot_sprite.custom_minimum_size = Vector2(32,32)
			loot_sprite.texture = loot.texture
			loot_container.add_child(loot_sprite)

func add_to_enemies(sprite: AnimatedEntity) -> void:
	var wrapper := Control.new()
	wrapper.custom_minimum_size = Vector2(32, 32)
	wrapper.add_child(sprite)
	wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enemies_container.add_child(wrapper)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		option_clicked.emit()
