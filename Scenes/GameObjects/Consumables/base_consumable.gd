extends Node

class_name BaseConsumable

@export var food_restore: float = 0.0
@export var water_restore: float = 0.0

func consume(vitals_component):
	if vitals_component:
		vitals_component.food = min(vitals_component.max_food, vitals_component.food + food_restore)
		vitals_component.water = min(vitals_component.max_water, vitals_component.water + water_restore)
		print("Consumed:", food_restore, "Food |", water_restore, "Water")
