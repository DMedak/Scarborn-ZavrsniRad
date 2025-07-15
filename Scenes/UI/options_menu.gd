extends CanvasLayer

signal back_pressed

@onready var window_button:Button = $%WindowButton
@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	update_display()
	
	
func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	
func on_window_button_pressed():
	var mode = DisplayServer. window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_display()


func on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
