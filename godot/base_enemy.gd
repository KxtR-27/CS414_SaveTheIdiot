extends CharacterBody2D

@export var target : CharacterBody2D

func _process(delta: float) -> void:
	if (target):
		move_towards_target(delta)
		pass
	pass
	
func move_towards_target(delta: float) -> void:
	var target_pos : Vector2 = target.position
	var dir_to_target : Vector2 = target_pos - self.position
	self.position += dir_to_target * delta
	
	
