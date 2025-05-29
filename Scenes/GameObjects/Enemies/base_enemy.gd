extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 50.0
@export var detection_range: float = 200.0
@export var roam_distance: float = 100.0
@export var sound_detection_range: float = 300.0  # Koliko daleko čuje pucnjeve
@export var health_component: Node

var player: Node2D = null
var roam_target: Vector2
var roaming: bool = true

func _ready():
	choose_new_roam_target()
	var player_weapons = get_tree().get_nodes_in_group("weapon_manager")
	for weapon in player_weapons:
		weapon.gunshot_fired.connect(_on_gunshot_fired)  # Poveži lokalno na signal pucnja

func _physics_process(delta):
	if player and player_exists_in_range():
		chase_player()
	else:
		roam()

	move_and_slide()

func player_exists_in_range() -> bool:
	if player == null:
		return false
	return global_position.distance_to(player.global_position) < detection_range

func chase_player():
	roaming = false
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func roam():
	if global_position.distance_to(roam_target) < 10:
		choose_new_roam_target()

	var direction = (roam_target - global_position).normalized()
	velocity = direction * speed * 0.5

func choose_new_roam_target():
	roam_target = global_position + Vector2(randf_range(-roam_distance, roam_distance), randf_range(-roam_distance, roam_distance))
	roaming = true

func _on_gunshot_fired(position):
	if global_position.distance_to(position) < sound_detection_range:
		print("Neprijatelj čuo pucanj!")
		roam_target = position  # Kreni prema pucnju
		roaming = true
