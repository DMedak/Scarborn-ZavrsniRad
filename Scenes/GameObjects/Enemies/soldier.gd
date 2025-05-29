extends BaseEnemy

@export var attack_range: float = 150.0
@export var fire_rate: float = 1.5  # Vremenski interval između pucanja
@onready var fire_timer = $Timer

func _ready():
	super._ready()
	fire_timer.wait_time = fire_rate
	fire_timer.timeout.connect(_on_fire_timer_timeout)

func _physics_process(delta):
	super._physics_process(delta)
	
	if player and global_position.distance_to(player.global_position) < attack_range:
		if fire_timer.is_stopped():
			fire_timer.start()

func _on_fire_timer_timeout():
	if player and global_position.distance_to(player.global_position) < attack_range:
		shoot()

func shoot():
	print("Soldier puca na igrača!")  # Ovdje kasnije može ići kod za pucanje
