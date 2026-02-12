extends Container

var option_scene = preload("res://ui/level_menu/level_option/level_option.tscn")
const OPTION = preload("res://art/menus/option.png")
const OPTION_FLIPPED = preload("res://art/menus/option_flipped.png")
const BOSS_OPTION = preload("res://ui/level_menu/boss_option/boss_option.tscn")
@onready var boss_container: BoxContainer = $"../BossContainer"

func _ready() -> void:
	var data = load("res://resources/levels/campaign/level_1.tres") as Level
	for i in range(data.options.size()):
		var new_option = option_scene.instantiate() as LevelOption
		new_option.option_data = data.options[i]
		var style_box = StyleBoxTexture.new()
		if i % 2 == 1:
			style_box.texture = OPTION_FLIPPED
		else:
			style_box.texture = OPTION
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(310,90)
		panel.add_theme_stylebox_override('panel', style_box)
		panel.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		panel.add_child(new_option)
		add_child(panel)
	if data.boss:
		var boss_option = BOSS_OPTION.instantiate() as BossLevelOption
		boss_option.boss_data = data.boss
		boss_container.add_child(boss_option)
