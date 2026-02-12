extends Container

var option_scene = preload("res://ui/level_menu/level_option/level_option.tscn")
const OPTION = preload("res://art/menus/option.png")
const OPTION_FLIPPED = preload("res://art/menus/option_flipped.png")
const BOSS_OPTION = preload("res://ui/level_menu/boss_option/boss_option.tscn")
@onready var boss_container: BoxContainer = $"../BossContainer"
const target_scene_path = "res://gameplay/level/level.tscn"
var progress : Array[float]
var loading_status : int

func _ready() -> void:
	var data = load("res://resources/levels/campaign/level_1.tres") as Level
	for i in range(data.options.size()):
		var new_option = option_scene.instantiate() as LevelOption
		new_option.option_data = data.options[i]
		new_option.option_clicked.connect(option_clicked.bind(new_option.option_data))
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

func option_clicked(option : Option) -> void:
	print(option.enemies[0].name)
	var next_level = load("res://gameplay/level/level.tscn")
	var level_instance = next_level.instantiate()

	# Pass your data
	level_instance.size = option.size

	# Change scene manually
	get_tree().root.add_child(level_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = level_instance
	#get_tree().change_scene_to_packed(next_level)
	#ResourceLoader.load_threaded_request(target_scene_path)

#func _process(_delta: float) -> void:
	## Update the status:
	#loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	## Check the loading status:
	#match loading_status:
		##ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			##progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		#ResourceLoader.THREAD_LOAD_LOADED:
			## When done loading, change to the target scene:
			#get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		#ResourceLoader.THREAD_LOAD_FAILED:
			## Well some error happend:
			#print("Error. Could not load Resource")
