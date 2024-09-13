class_name LoadingScreen extends Control

var last_size:Vector2i
var size_timer:float = 0.0:
	set(_value):
		size_timer = _value
		if size_timer >= size_check_delay:
			size_timer = 0.0
			_size_check(last_size)
var size_check_delay:float = 0.5

@onready var background: ColorRect = %background
@onready var loading: RichTextLabel = %loading
@onready var percent: RichTextLabel = %percent

func _ready() -> void:
	last_size = _size_check(last_size)
	Manager.ToggleLoadingScreen.connect(_toggle_loading_screen)
	Manager.LoadingPercentUpdated.connect(_update_percent)

func _physics_process(delta: float) -> void:
	if visible:
		size_timer += delta

func _toggle_loading_screen(_value:bool) -> void:
	set_deferred("visible", _value)
	if _value:
		_size_check(last_size)
		_update_percent(0.0)

func _update_percent(_value:float) -> void:
	percent.text = "[center]" + str(roundf(_value*100)) + "%[/center]"

func _size_check(_last_size:Vector2i) -> Vector2i:
	if _last_size != Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height")):
		_last_size = Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
		background.size = _last_size
		_set_label_positions(_last_size, loading, percent)
	return _last_size

func _set_label_positions(_size:Vector2i, _loading:RichTextLabel, _percent:RichTextLabel) -> void:
	_loading.position = Vector2((_size.x/2)-_loading.size.x/2, (_size.y/2)-_loading.size.y)
	_percent.position = Vector2((_size.x/2)-_percent.size.x/2, _size.y/2)
