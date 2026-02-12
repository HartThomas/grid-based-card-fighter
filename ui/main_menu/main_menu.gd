extends Control

var level_number = 1
const LEVEL_MENU = "res://ui/level_menu/level_menu.tscn"

var loading_status : int
var progress : Array[float]

func _on_start_button_button_down() -> void:
	ResourceLoader.load_threaded_request(LEVEL_MENU)
	pass # Replace with function body.

func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(LEVEL_MENU, progress)
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#progress_bar.value = progress[0] * 100 # Change the ProgressBar value
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(LEVEL_MENU))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
