extends CharacterBody2D

@onready var curr_state : State = State.LOCATING
@onready var detection_area : Area2D = $Area2D
@export var center : Vector2
@export var target : CharacterBody2D
@export var speed : float = 0.1
enum State {
	LOCATING,
	TARGETING
}

func _ready() -> void:
	if (get_tree().root.get_camera_2d()):
		center = get_tree().root.get_camera_2d().get_screen_center_position()
	else:
		center = get_tree().root.get_visible_rect().size / 2

func _process(delta: float) -> void:
	if (curr_state == State.TARGETING):
		move_towards_point(target.position, delta)
	else:
		move_towards_point(center, delta)
	pass
	
func move_towards_point(point : Variant, delta: float) -> void:
	var dir_to_target : Vector2 = point - self.position
	self.position += dir_to_target * delta * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("targets") && !target):
		print('wow')
		target = body
		curr_state = State.TARGETING
	pass # Replace with function body.
