extends Node2D
class_name BaseWeapon

@export var damage: int = 10
@export var fire_rate: float = 0.2
@export var ammo: int = 30
@export var max_ammo: int = 30
@export var is_melee: bool = false

var can_shoot: bool = true

func attack():
	if is_melee:
		melee()
	else:
		shoot()

func shoot():
	if can_shoot and ammo > 0:
		print("Pucanj! Oružje:", self.name)
		ammo -= 1
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func melee():
	pass
