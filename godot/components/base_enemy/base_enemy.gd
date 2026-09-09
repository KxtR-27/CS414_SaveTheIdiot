class_name BaseEnemy
extends CharacterBody2D


@export_group("")
@export var speed: float = 3000.0
@export var health: float = 100.0

@export_group("Components")
@export var health_component: HealthComponent
@export var damage_component: DamageComponent

@export_group("Targeting")
@export var target: CharacterBody2D
@export var stop_at_distance_to_target: float = 80
@export var switch_targets_when_new_target_scanned: bool = true


@onready var target_scan_area := $TargetScanArea as Area2D
@onready var target_polling_timer := $TargetPollingTimer as Timer


func _ready() -> void:
	add_to_group("enemies")
	# return if target already exists
	if target: return
	# otherwise, check for closest
	_poll_for_closest_target()
	# if we still didn't find one, poll automatically until we do
	if not target:
		target_polling_timer.start()


func _physics_process(delta: float) -> void:
	# don't move without a target
	if not target: return
	
	# calculate where to go to reach the target
	var direction: Vector2 = global_position.direction_to(target.global_position)
	var distance: float = global_position.distance_to(target.global_position)
	
	# move toward target unless too close (for testing)
	if distance > stop_at_distance_to_target:
		self.velocity = speed * direction * delta
		move_and_slide()
	else:
		self.velocity = Vector2.ZERO


## sorts targets by their closeness to this enemy
func _sort_by_closeness(a: Node2D, b: Node2D) -> bool:
	var a_dist_from_self: float = self.global_position.distance_to(a.global_position)
	var b_dist_from_self: float = self.global_position.distance_to(b.global_position)
	return a_dist_from_self < b_dist_from_self


## checks the [code]targets[/code] group, sorts by the closest target,
## and picks that target to move toward.
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


## poll for target at regular interval set by [code]target_polling_timer[/code]
func _on_target_polling_timer_timeout() -> void:
	_poll_for_closest_target()


## change targets when a valid target enters TargetScanArea 
func _on_target_scanned(body: Node2D) -> void:
	# if not switching targets, return early
	if not switch_targets_when_new_target_scanned: 
		print("scanned a new target, but scan-switching is disabled")
		return
	# if already targeting the body, return early
	elif body == target: 
		print("already targeting the scanned body")
		return
	# if the body isn't a valid target, return early
	elif not get_tree().get_nodes_in_group("targets").has(body):
		print("scanned body is not a target")
		return
	# otherwise, we are scanning, the body is new to us, and it's a valid target
	else:
		print("scanned new target:", body.name, body) 
		target = body


#func take_damage(amount : float) -> void:
	#self.health -= amount
	#
	##update health bar
	#var progress_bar : ProgressBar = $Health/ProgressBar
	#progress_bar.value = self.health
	#
	##queue_free() if enemy runs out of health
	#if self.health <= 0.0:
		#self.queue_free()


func _on_health_component_died() -> void:
	self.queue_free()
	pass # Replace with function body.
