class_name BaseEnemy
extends CharacterBody2D

# why do we need this feature? also it doesn't work.
#enum State {
	#LOCATING,
	#TARGETING
#}


# why do we need this feature? why export center if it's changed onready? also it doesn't work.
#@export var center: Vector2
@export var target: CharacterBody2D
@export var speed: float = 10000.0
@export var stop_at_distance: float = 200

# why do we need this feature? also it doesn't work
#@onready var state: State = State.LOCATING
#@onready var detection_area: Area2D = $Area


# are you trying to have the enemy move toward the camera while the camera tracks the player????? 
# I am very confused. This code does produce that output. 
# What was wrong with the way the code was before? Why do we need this feature?
#func _ready() -> void:
	#if (get_tree().root.get_camera_2d()):
		#center = get_tree().root.get_camera_2d().get_screen_center_position()
	#else:
		#center = get_tree().root.get_visible_rect().size / 2


# why do we need this feature? also, it doesn't work.
#func _physics_process(delta: float) -> void:
	#if (state == State.TARGETING):
		#move_towards_point(target.position, delta)
	#else:
		#move_towards_point(center, delta)
	#pass


func _physics_process(delta: float) -> void:
	if not target: return
	
	var direction: Vector2 = global_position.direction_to(target.global_position)
	var distance: float = global_position.distance_to(target.global_position)
	
	if distance > stop_at_distance:
		self.velocity = speed * direction * delta
		move_and_slide()
	else:
		self.velocity = Vector2.ZERO


# why do we need this feature? also, it doesn't work.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if (body.is_in_group("targets") && !target):
		#print('wow')
		#target = body
		#state = State.TARGETING
	pass
