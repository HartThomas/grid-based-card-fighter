extends Node2D

#
#func update_line(offset: float):
	## Left point moves right
	#var start = Vector2(-half_length + offset, 0)
	## Right point moves left
	#var end = Vector2(half_length - offset, 0)
#
	#line_2d.points = [start, end]
#
#func update_line(offset: float):
	#var start = Vector2(-offset, 0)
	#var end = Vector2(offset, 0)
#
	#line_2d.points = [start, end]

@onready var line: Line2D = $Line2D

var total_length := 32.0
var half_length := total_length / 2.0

var current_dir: Vector2i = Vector2i.RIGHT

func _ready():
	line.points = []

# Call this to create the line
func animate_line(dir: Vector2i) -> void:
	current_dir = dir
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_method(update_line_expand, 0.0, half_length, 0.2)

# Call this to remove the line and delete the node
func remove_line() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_method(update_line_shrink, half_length, 0.0, 0.2)
	tween.tween_callback(queue_free)

# --- Animation Logic ---

func update_line_expand(offset: float) -> void:
	var start: Vector2
	var end: Vector2

	if is_horizontal(current_dir):
		start = Vector2(-offset, 0)
		end = Vector2(offset, 0)
	else:
		start = Vector2(0, -offset)
		end = Vector2(0, offset)

	line.points = [start, end]


func update_line_shrink(offset: float) -> void:
	var start: Vector2
	var end: Vector2

	if is_horizontal(current_dir):
		start = Vector2(-offset, 0)
		end = Vector2(offset, 0)
	else:
		start = Vector2(0, -offset)
		end = Vector2(0, offset)

	line.points = [start, end]


# --- Helpers ---

func is_horizontal(dir: Vector2i) -> bool:
	return dir == Vector2i.UP or dir == Vector2i.DOWN
