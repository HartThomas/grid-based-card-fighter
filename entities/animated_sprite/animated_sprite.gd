extends AnimatedSprite2D

class_name AnimatedEntity

var sprite_name = 'bogman'

func _ready() -> void:
	setup()

func setup() -> void:
	var frames = SpriteFrames.new()
	var data = load("res://entities/enemies/%s/%s.tres" % [sprite_name, sprite_name]) as Enemy
	var anim = data.animations.idle as SpriteAnimation
	frames = anim.to_sprite_frames()
	animation_finished.connect(anim.on_animation_end)
	sprite_frames = frames
	animation = '%s_idle' % [sprite_name]
	play()
