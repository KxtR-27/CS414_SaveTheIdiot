class_name BasePlayer
extends CharacterBody2D

var ability_cooldowns : Dictionary = {
	"ability_1" : false, 
	"ability_2" : false
}

func _ready() -> void:
	add_to_group("Player")


func _process(delta: float) -> void:
	# retrieve direction in which to apply movement
	var x_axis_input : float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_axis_input : float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# construct normalized vector2 that contains what direction the player wants to move in
	var move_dir : Vector2 = Vector2(x_axis_input,y_axis_input).normalized() * 50000.0 * delta
	self.velocity = move_dir
	
	self.move_and_slide()
	
	if (Input.is_action_just_pressed("ability_1") and 
		not ability_cooldowns["ability_1"]
	):
		ability_cooldowns["ability_1"] = true
		var timer : Timer = $Cooldowns/Ability1Cooldown
		timer.start()
		print("pressed ability_1")
	
	if (Input.is_action_just_pressed("ability_2") and 
		not ability_cooldowns["ability_2"]
	):
		ability_cooldowns["ability_2"] = true
		var timer : Timer = $Cooldowns/Ability2Cooldown
		timer.start()
		print("pressed ability_2")


func _on_ability_1_cooldown_timeout() -> void:
	ability_cooldowns["ability_1"] = false


func _on_ability_2_cooldown_timeout() -> void:
	ability_cooldowns["ability_2"] = false
