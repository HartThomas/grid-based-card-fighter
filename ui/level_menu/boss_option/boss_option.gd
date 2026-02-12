extends Control

class_name BossLevelOption

var boss_data = preload("res://resources/levels/bosses/boss.tres") as BossOption
const ANIMATED_SPRITE = preload("res://entities/animated_sprite/animated_sprite.tscn") 
@onready var enemies_container: HBoxContainer = $MarginContainer/BossOptionContainer/EnemiesMarginContainer/EnemiesHBoxContainer/EnemiesContainer
@onready var loot_container: HBoxContainer = $MarginContainer/BossOptionContainer/LootMarginContainer/LootHBoxContainer/LootContainer

func _ready() -> void:
	
	for enemy in boss_data.enemies:
		if enemy:
			var sprite = ANIMATED_SPRITE.instantiate() as AnimatedEntity
			sprite.sprite_name = enemy.name
			add_to_enemies(sprite)
	for loot in boss_data.loot:
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
		print(boss_data)
