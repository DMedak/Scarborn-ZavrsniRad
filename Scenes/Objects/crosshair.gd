extends CanvasLayer

@onready var sprite = $Sprite2D

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size

	# Ograniči da ostane unutar ekrana
	mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x)
	mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y)

	sprite.position = mouse_pos
