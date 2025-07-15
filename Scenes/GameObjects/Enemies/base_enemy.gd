extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 90
@export var detection_range: float = 1000.0
@export var roam_distance: float = 5000.0
@export var sound_detection_range: float = 300.0
@export var health_component: Node
@export var damage: float = 15.00

var player: Node2D = null
var roam_target: Vector2
var roaming: bool = true


func _ready():
	choose_new_roam_target()
	var player_weapons = get_tree().get_nodes_in_group("weapon_manager")


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


func take_damage(amount: float) -> void:
	if health_component and health_component.has_method("damage"):
		health_component.damage(amount)
	print("Damage")
	
