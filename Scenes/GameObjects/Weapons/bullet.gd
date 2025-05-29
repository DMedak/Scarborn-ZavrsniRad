extends Area2D

@export var speed: float = 800.0
@export var lifetime: float = 2.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()
	look_at(global_position + direction)


func _process(delta):
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(10)  # Ako tvoj enemy ima ovu funkciju

	queue_free()
