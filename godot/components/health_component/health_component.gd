class_name HealthComponent extends Control

signal health_changed(amount_changed: int)
signal died

@export var _max_health : int = 100
@onready var health_bar : ProgressBar = $HealthBar
var current_health : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = _max_health
	health_bar.max_value = float(_max_health)
	pass # Replace with function body.

func _on_health_changed(amount_changed: int, negative: bool) -> void:
	#can be used to heal or damage
	#negative numbers for damage dealt
	#positive numbers for healing
	if negative:
		current_health -= amount_changed
	else:
		current_health += amount_changed
	if current_health <= 0:
		died.emit()
	if current_health > _max_health:
		current_health = _max_health
	health_bar.value = current_health
	pass # Replace with function body.
