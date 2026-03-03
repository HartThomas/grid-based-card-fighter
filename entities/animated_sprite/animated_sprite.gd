extends AnimatedSprite2D

class_name AnimatedEntity

@export var sprite_name = 'bogman'
@export var animation_name = 'idle'
var data

func _ready() -> void:
	setup()

func setup() -> void:
	var frames = SpriteFrames.new()
	var string : String = "res://entities/enemies/%s/%s.tres" % [sprite_name, sprite_name] if sprite_name != 'player' else "res://entities/player/player.tres"
	var data = load(string) as Entity
	var anim = data.animations[animation_name] as SpriteAnimation
	frames = anim.to_sprite_frames()
	#animation_finished.connect(anim.on_animation_end)
	sprite_frames = frames
	animation = '%s_%s' % [sprite_name, animation_name]
	play(animation)
