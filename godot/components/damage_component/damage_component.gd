class_name DamageComponent extends Node

func deal_damage(amount: int, body: CharacterBody2D) -> void:
	if body.health_component:
		body.health_component.health_changed.emit(amount, true)
	pass # Replace with function body.
