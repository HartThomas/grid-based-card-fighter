extends TextureRect


@export var texture_a: Texture2D
@export var texture_b: Texture2D

var use_a := true
var timer := 0.0


func _process(delta: float) -> void:
	if visible:
		timer += delta
		
		if timer >= 1.0:
			timer = 0.0
			use_a = !use_a
			
			if use_a:
				texture = texture_a
			else:
				texture = texture_b
