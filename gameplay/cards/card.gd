extends Control

class_name Card

@export var data : CardInstance
@onready var type_texture: TextureRect = $CardTexture/TypeTexture
@onready var item_texture: TextureRect = $CardTexture/ItemTexture
@onready var number_label: RichTextLabel = $CardTexture/NumberLabel
var base_position : Vector2
var is_dragging : bool = false
var mouse_offset : Vector2
@onready var card_texture: TextureRect = $CardTexture
signal card_drag_started()
signal card_drag_ended()
signal card_played(data)

func _ready() -> void:
	if not data:
		var shwick = load("res://resources/cards/shwick.tres")
		var card_instance = CardInstance.new()
		card_instance.data = shwick
		data = card_instance
	load_card()
	base_position = position

func load_card() -> void:
	var item = load("res://art/sprites/%s.png" % [CardEnums.item.keys()[data.get_item()].to_lower()])
	item_texture.texture = item
	if data.get_type() != CardEnums.type.BLOCK:
		var new_text = load("res://art/sprites/%s.png" % [CardEnums.type.keys()[data.get_type()].to_lower()])
		type_texture.texture = new_text
	var number = data.get_damage()
	number_label.text = str(number) if number != 0 else ''

var hover_tween : Tween

func _on_card_texture_mouse_entered() -> void:
	if not is_dragging:
		if hover_tween:
			hover_tween.kill()
		hover_tween = create_tween()
		hover_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
		hover_tween.tween_property(self, "position", base_position + Vector2(0,-20), 0.15)

func _on_card_texture_mouse_exited() -> void:
	if not is_dragging:
		if hover_tween:
			hover_tween.kill()
		card_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hover_tween = create_tween()
		hover_tween.finished.connect(_return_finished)
		hover_tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
		hover_tween.tween_property(self, "position", base_position, 0.15)

func _return_finished():
	card_texture.mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event):
	if is_dragging and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() - mouse_offset

func _on_card_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			if is_dragging:
				is_dragging = false
				card_drag_ended.emit()
				_on_card_texture_mouse_exited()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		if event.pressed:
			is_dragging = true
			card_drag_started.emit()
			if hover_tween:
				hover_tween.kill()
			mouse_offset = get_global_mouse_position() - global_position
			print(mouse_offset,' mouse_offset', get_global_mouse_position(), ' get_global_mouse_position')
		else:
			if is_dragging:
				is_dragging = false
				card_drag_ended.emit()
				_on_card_texture_mouse_exited()
				card_played.emit(data)
