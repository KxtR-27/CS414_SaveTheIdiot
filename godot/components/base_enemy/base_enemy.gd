class_name BaseEnemy
extends CharacterBody2D


enum State {
	WANDERING,
	TARGETING,
}


@export var target: CharacterBody2D:
	# elsewhere in the code and the engine, use `target = ...`
	# to **trigger** this setter.
	# in this file, you can use `self.target = ...`
	# to **bypass** this setter.
	set(changed):
		print("new target:", changed)
		target = changed

@export var speed: float = 10000.0
@export var stop_at_distance: float = 200

@onready var target_scan_area := $TargetScanArea as Area2D
@onready var target_polling_timer := $TargetPollingTimer as Timer


func _ready() -> void:
	# return if target already exists
	if target: return
	# otherwise, check for closest
	_poll_for_closest_target()
	# if we still didn't find one, poll automatically until we do
	if not target:
		target_polling_timer.start()


func _physics_process(delta: float) -> void:
	if not target: return
	
	var direction: Vector2 = global_position.direction_to(target.global_position)
	var distance: float = global_position.distance_to(target.global_position)
	
	if distance > stop_at_distance:
		self.velocity = speed * direction * delta
		move_and_slide()
	else:
		self.velocity = Vector2.ZERO


func _sort_by_closeness(a: CharacterBody2D, b: CharacterBody2D) -> bool:
	var a_dist_from_self: float = self.global_position.distance_to(a.global_position)
	var b_dist_from_self: float = self.global_position.distance_to(b.global_position)
	
	if a_dist_from_self < b_dist_from_self:
		return true
	return false


func _poll_for_closest_target() -> void:
	# run check for closest target
	print("polling for target...")
	var targets := get_tree().get_nodes_in_group("targets").slice(0) as Array[Node]
	if targets.is_empty(): return
	
	# sort by closeness
	targets.sort_custom(_sort_by_closeness)
	var closest_target := targets[0] as Node2D
	# stop polling and update target if found
	if closest_target:
		print("target found!", closest_target.name, closest_target)
		target_polling_timer.stop()
		target = closest_target


func _on_target_polling_timer_timeout() -> void:
	_poll_for_closest_target()
