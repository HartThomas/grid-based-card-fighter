extends AnimatedSprite2D

class_name AnimatedEntity

@export var sprite_name = 'bogman'
var sprite_data

func _ready() -> void:
	setup()

func setup() -> void:
	var frames = SpriteFrames.new()
	var string : String = "res://entities/enemies/%s/%s.tres" % [sprite_name, sprite_name] if sprite_name != 'player' else "res://entities/player/player.tres"
	var data = load(string) as Entity
	var anim = data.animations.idle as SpriteAnimation
	frames = anim.to_sprite_frames()
	animation_finished.connect(anim.on_animation_end)
	sprite_frames = frames
	animation = '%s_idle' % [sprite_name]
	play(animation)
