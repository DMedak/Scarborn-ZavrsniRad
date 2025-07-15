extends BaseEnemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $Timer

@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 2.0

var last_direction: String = "down"
var is_dead: bool = false
var is_attacking: bool = false
var player_in_attack_area: bool = false


func _ready():
	super._ready()
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_on_attack_timer_timeout)


	if health_component:
		health_component.died.connect(die)


func _physics_process(delta):
	if is_dead:
		return
	super._physics_process(delta)

	if sprite.animation.begins_with("attack") and sprite.is_playing():
		return

	update_animation()

	if player and player_in_attack_area:
		if attack_timer.is_stopped():
			attack_timer.start()


func update_animation():
	if is_attacking or is_dead:
		return

	if velocity.length() < 5:
		sprite.play("idle_" + last_direction)
	else:
		var dir = get_direction_string(velocity)
		last_direction = dir
		sprite.play("walk_" + dir)


func attack():
	if is_dead:
		return
	
	if sprite.is_playing() and sprite.animation.begins_with("attack"):
		return

	is_attacking = true
	sprite.play("attack_" + last_direction)

	if player_in_attack_area and player:
		if player.has_method("damage"):
			player.damage(attack_damage)


func _on_attack_timer_timeout():
	if player and player_in_attack_area:
		attack()


func die():
	if is_dead:
		return
	is_dead = true

	sprite.play("death_" + last_direction)
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

	await sprite.animation_finished
	queue_free()


func get_direction_string(vel: Vector2) -> String:
	if vel == Vector2.ZERO:
		return last_direction

	var angle = vel.angle()
	if angle > -PI / 4 and angle <= PI / 4:
		return "right"
	elif angle > PI / 4 and angle <= 3 * PI / 4:
		return "down"
	elif angle <= -PI / 4 and angle > -3 * PI / 4:
		return "up"
	else:
		return "left"


func _on_attack_area_body_entered(body: Node) -> void:
	if body.name == "player":
		player_in_attack_area = true


func _on_attack_area_body_exited(body: Node) -> void:
	if body.name == "player":
		player_in_attack_area = false
