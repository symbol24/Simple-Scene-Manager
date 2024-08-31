extends Control

@export var id:int

@onready var button: Button = %Button

func _ready() -> void:
	button.pressed.connect(_button_pressed)
	
func _button_pressed() -> void:
	Manager.load_scene(id)
