extends Node2D


@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.2

var can_shoot: bool = true

func _ready():
	pass

func shoot(target_position: Vector2):
	if not can_shoot or bullet_scene == null:
		return

	can_shoot = false

	var bullet = bullet_scene.instantiate()
	var direction = (target_position - global_position).normalized()

	var dir_name = get_direction_name(direction)
	bullet.global_position = get_spawn_point(dir_name)
	bullet.direction = direction

	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func get_spawn_point(direction: String) -> Vector2:
	var node_name = "BulletSpawnPoint" + direction
	var spawn_node = get_node_or_null(node_name)
	if spawn_node and spawn_node is Node2D:
		return spawn_node.global_position
	else:
		return global_position  # fallback ako nije pronađen


func get_direction_name(direction: Vector2) -> String:
	if direction.x > 0.5:
		if direction.y > 0.5:
			return "RightDown"
		elif direction.y < -0.5:
			return "RightUp"
		else:
			return "Right"
	elif direction.x < -0.5:
		if direction.y > 0.5:
			return "LeftDown"
		elif direction.y < -0.5:
			return "LeftUp"
		else:
			return "Left"
	else:
		if direction.y > 0.5:
			return "Down"
		elif direction.y < -0.5:
			return "Up"
		else:
			return "Down"
