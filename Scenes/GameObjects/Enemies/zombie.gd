extends BaseEnemy

@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 2.0
@onready var attack_timer = $Timer

func _ready():
	super._ready()
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(delta):
	super._physics_process(delta)

	if player and global_position.distance_to(player.global_position) < 30:
		if attack_timer.is_stopped():
			attack_timer.start()

func _on_attack_timer_timeout():
	if player and global_position.distance_to(player.global_position) < 30:
		attack()

func attack():
	print("Zombie napada igrača!")  # Kasnije dodati smanjenje healtha igrača
