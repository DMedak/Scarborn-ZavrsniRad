extends CharacterBody2D

const SPEED = 200.0
const SPRINT_SPEED = 300.0
const CROUCH_SPEED = 100.0

@onready var sprite = $Visuals/AnimatedSprite2D
@onready var weapons = preload("res://Scenes/Manager/weapons_manager.tscn").instantiate()
@onready var health_component = $HealthComponent
@onready var vitals: Node = $VitalsComponent
@onready var shoot_anim_timer = $ShootAnimTimer


var can_shoot := true
var is_aiming := false
var is_shooting := false
var last_direction = Vector2.DOWN
var has_weapon := false
var wants_to_shoot := false


func _ready():
	add_child(weapons)

func _input(event):
	if event.is_action_pressed("slot1"):
		has_weapon = true
	elif event.is_action_pressed("slot3"):
		has_weapon = false

func _unhandled_input(event):
	if has_weapon:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				wants_to_shoot = true


func _process(delta):
	var input_direction = Vector2.ZERO
	var current_speed = SPEED
	var is_sprinting = false
	if wants_to_shoot and has_weapon:
		weapons.shoot(get_global_mouse_position())
		trigger_shoot_animation()
		wants_to_shoot = false



	is_aiming = Input.is_action_pressed("aim")

	# Input smjer
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
	if Input.is_action_pressed("move_up"):
		input_direction.y -= 1

	input_direction = input_direction.normalized()
	
	is_sprinting = Input.is_action_pressed("sprint") and input_direction != Vector2.ZERO
	vitals.is_sprinting = is_sprinting


	# Smjer prema mišu
	var mouse_pos = get_global_mouse_position()
	var dir_to_mouse = (mouse_pos - global_position).normalized()
	if dir_to_mouse != Vector2.ZERO:
		last_direction = dir_to_mouse

	# Sprintanje
	if Input.is_action_pressed("sprint"):
		if input_direction != Vector2.ZERO:
			var angle_between = input_direction.angle_to(dir_to_mouse)
			if abs(angle_between) <= deg_to_rad(65):
				current_speed = SPRINT_SPEED
				is_sprinting = true
			else:
				current_speed = SPEED
	else:
		current_speed = SPEED

	if is_aiming:
		current_speed = CROUCH_SPEED
		is_sprinting = false

	# Kretanje
	if input_direction != Vector2.ZERO:
		velocity = input_direction * current_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

	var dir_name = get_direction_name(last_direction)

	# Animacije
	if velocity.length() > 0:
		if has_weapon:
			if is_aiming:
				sprite.play("walk_aim_" + dir_name)
			elif is_shooting:
				if is_sprinting:
					sprite.play("run_shoot_" + dir_name)
				else:
					sprite.play("walk_shoot_" + dir_name)
			else:
				if is_sprinting:
					sprite.play("run_gun_" + dir_name)
				else:
					sprite.play("walk_gun_" + dir_name)
		else:
			if is_sprinting:
				sprite.play("run_" + dir_name)
			else:
				sprite.play("walk_" + dir_name)
	else:
		if has_weapon:
			if is_shooting:
				sprite.play("idle_shoot_" + dir_name)
			else:
				sprite.play("idle_gun_" + dir_name)
		else:
			sprite.play("idle_" + dir_name)

func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO:
		return "down"

	var angle = dir.angle()
	var deg = rad_to_deg(angle)
	if deg < 0:
		deg += 360

	if deg >= 337.5 or deg < 22.5:
		return "right"
	elif deg >= 22.5 and deg < 67.5:
		return "right_down"
	elif deg >= 67.5 and deg < 112.5:
		return "down"
	elif deg >= 112.5 and deg < 157.5:
		return "left_down"
	elif deg >= 157.5 and deg < 202.5:
		return "left"
	elif deg >= 202.5 and deg < 247.5:
		return "left_up"
	elif deg >= 247.5 and deg < 292.5:
		return "up"
	elif deg >= 292.5 and deg < 337.5:
		return "right_up"

	return "down"


func trigger_shoot_animation():
	is_shooting = true
	shoot_anim_timer.start()


func _on_shoot_anim_timer_timeout():
	is_shooting = false
