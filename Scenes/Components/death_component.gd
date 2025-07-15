extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
@export var sprite: AnimatedSprite2D

func _ready():
	if health_component:
		health_component.died.connect(on_died)

func on_died():
	if owner == null or not owner is Node2D:
		return
	
	global_position = owner.global_position

	var entities = get_tree().get_first_node_in_group("entities_layer")
	if entities:
		get_parent().remove_child(self)
		entities.add_child(self)

	owner.queue_free()
