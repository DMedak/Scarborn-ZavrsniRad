extends Node2D

@export var zombie_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(Vector2(-1000, -1000), Vector2(2000, 2000))
@export var spawn_count: int = 20

func _ready():
	spawn_zombies()

func spawn_zombies():
	if not zombie_scene:
		return

	var player_node = get_tree().get_first_node_in_group("player")
	
	for i in spawn_count:
		var zombie = zombie_scene.instantiate()
		var position_in_area = spawn_area.position + Vector2(
			randf_range(0, spawn_area.size.x),
			randf_range(0, spawn_area.size.y)
		)
		zombie.global_position = position_in_area
		
		if player_node:
			zombie.player = player_node
		
		get_tree().current_scene.call_deferred("add_child", zombie)
		print("Zombie spawned!")
