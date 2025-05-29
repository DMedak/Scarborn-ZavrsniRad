extends Node

@export var max_food: float = 100.0
@export var max_water: float = 100.0
@export var max_stamina: float = 100.0
@export var stamina_drain_rate: float = 5  
@export var food_drain_rate: float = 0.3 
@export var water_drain_rate: float = 0.1 
@export var health_damage_rate: float = 0.5  
@onready var health_component = get_parent().get_node("HealthComponent")


var food: float = max_food
var water: float = max_water
var stamina: float = max_stamina
var is_walking: bool = false
var is_sprinting: bool = false
var stamina_recovery_rate: float = 3.0


func _ready():
	start_drain_timer()

func start_drain_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0  # Svake sekunde smanjuje food i water
	timer.autostart = true
	timer.timeout.connect(_decrease_vitals)
	add_child(timer)

func _decrease_vitals():
	food = max(0, food - food_drain_rate)
	water = max(0, water - water_drain_rate)
	
	if is_sprinting:
		stamina = max(0, stamina - stamina_drain_rate)
	if stamina < max_stamina:
		stamina = min(max_stamina, stamina + stamina_recovery_rate)

	print("Food:", food, " | Water:", water, " | Stamina:", stamina)

	if food == 0 or water == 0:
		health_component.damage(health_damage_rate)

func add_food(amount: float):
	food = min(max_food, food + amount)

func add_water(amount: float):
	water = min(max_water, water + amount)
