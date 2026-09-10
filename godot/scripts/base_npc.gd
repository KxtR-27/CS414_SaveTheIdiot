class_name BaseNPC
extends BaseCharacter

@export_enum("Follow", "Flee") var target_preference := "Follow"

@export_group("Following")
@export var target_to_follow: BaseCharacter
@export var closest_follow_distance: float = 80

@export_group("Fleeing")
@export var target_to_flee_from: BaseCharacter
@export var farthest_flee_distance: float = 300


func _physics_process(delta: float) -> void:
	# don't move without a target.
	# (if false, then there is at least one target)
	if not target_to_follow and not target_to_flee_from:
		self.velocity = Vector2.ZERO
		return
	
	# conditions:
	# 1. there must be a target to follow, and
	# 2. either...
	#    a. there's no target to flee from to consider, or
	#    b. (there is a target to flee from but) following is preferred
	var should_follow := target_to_follow and (not target_to_flee_from or target_preference == "Follow")
	
	var direction: Vector2
	var distance: float
	var not_stopping: bool
	
	if (should_follow):
		# notice that self is on the lefthand and target is on the righthand
		direction = self.global_position.direction_to(target_to_follow.global_position)
		distance = self.global_position.distance_to(target_to_follow.global_position)
		not_stopping = distance > closest_follow_distance
	else: # should flee
		# notice that target is on the lefthand and self is on the righthand
		direction = target_to_flee_from.global_position.direction_to(self.global_position)
		distance = target_to_flee_from.global_position.distance_to(self.global_position)
		not_stopping = distance < farthest_flee_distance
	
	if not_stopping:
		self.velocity = direction * speed * delta
		move_and_slide()
	else:
		self.velocity = Vector2.ZERO
