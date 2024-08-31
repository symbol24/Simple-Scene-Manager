extends Node

signal ToggleLoadingScreen(_display:bool)
signal LoadingPercentUpdated(_percent:float)

const LOADING_SCREEN = "res://addons/SimpleSceneManager/Scenes/loading_screen.tscn"

## Use the resource LevelData that you create here.
@export var level_data:LevelData

# A quick variable to check if the tree is paused.
var is_paused:bool:
	get:
		return get_tree().paused
		
#Levels and loading
var active_level:Node
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false
var loading_screen:LoadingScreen

func _ready() -> void:
	# Process mode is set to "always" through code
	process_mode = PROCESS_MODE_ALWAYS
	
	# If use_own_loading_screen is false, load the loading screen and instantiate to be used.
	if !level_data.use_own_loading_screen:
		loading_screen = load(LOADING_SCREEN).instantiate()
		add_child.call_deferred(loading_screen)
		
	# If load_first_level_on_boot then loading the first in the list.
	if level_data.load_first_level_on_boot:
		load_scene(0)

func _physics_process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		LoadingPercentUpdated.emit(progress[0])
		
		# When loading is complete in ResourceLoader, launch the _complete_load function.
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()

func load_scene(_id:int = -1) -> void:
	# Send loadscreen toggle on
	ToggleLoadingScreen.emit(true)
	
	# If path is empty, dont try to load.
	var path := level_data.get_level_path(_id)
	if path == "":
		return
	
	# If there is an active level, queue_free it.
	if active_level != null: 
		var temp := active_level
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
	
	# Starting the ResourceLoader.
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)

func _complete_load() -> void:
	is_loading = false
	
	# Get the new level from the ResourceLoader and instantiate it.
	var new_level := ResourceLoader.load_threaded_get(to_load)
	active_level = new_level.instantiate()
	add_child.call_deferred(active_level)
	
	# Adding load time if set in the level data
	if level_data.loading_delay > 0.0:
		var wait_timer := get_tree().create_timer(level_data.loading_delay)
		await wait_timer.timeout
		
	# Send loadscreen toggle off
	ToggleLoadingScreen.emit(false)
