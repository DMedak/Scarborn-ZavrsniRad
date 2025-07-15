extends Area2D

@export var speed: float = 800.0
@export var lifetime: float = 2.0
@export var damage: float = 20.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()
	look_at(global_position + direction)


func _process(delta):
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var enemy = body as BaseEnemy
		if enemy:
			enemy.take_damage(damage)
			print("Damage sent to:", enemy.name)
		else:
			print("Body is in enemies group but not BaseEnemy:", body.name)

	queue_free()
	print("Hit", body.name)
