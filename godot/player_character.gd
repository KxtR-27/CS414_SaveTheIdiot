extends CharacterBody2D

var ability_cooldowns : Dictionary = {
	"Q" : false, 
	"E" : false
}

func _ready() -> void:
	add_to_group("Player")


func _process(delta: float) -> void:
	# retrieve direction in which to apply movement
	var x_axis_input : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_axis_input : float = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# construct normalized vector2 that contains what direction the player wants to move in
	var move_dir : Vector2 = Vector2(x_axis_input,y_axis_input).normalized() * 50000.0 * delta
	self.velocity = move_dir
	
	self.move_and_slide()
	
	if (Input.is_action_just_pressed("ability1") and 
		not ability_cooldowns["Q"]
	):
		ability_cooldowns["Q"] = true
		var timer : Timer = $Ability1Cooldown
		timer.start()
		print("pressed Q")
	
	if (Input.is_action_just_pressed("ability2") and 
		not ability_cooldowns["E"]
	):
		ability_cooldowns["E"] = true
		var timer : Timer = $Ability2Cooldown
		timer.start()
		print("pressed E")


func _on_ability_1_cooldown_timeout() -> void:
	ability_cooldowns["Q"] = false


func _on_ability_2_cooldown_timeout() -> void:
	ability_cooldowns["E"] = false
