class_name BasePlayer
extends CharacterBody2D


enum Ability {
	ABILITY_1,
	ABILITY_2,
}

const ABILITY_ACTION_MAP: Dictionary[String, Ability] = {
	"ability_1": Ability.ABILITY_1,
	"ability_2": Ability.ABILITY_2,
}


@export var speed: float = 10000

var ability_on_cooldown: Dictionary[Ability, bool] = {
	Ability.ABILITY_1: false, 
	Ability.ABILITY_2: false,
}

@onready var ability_timers: Dictionary[Ability, Timer] = {
	Ability.ABILITY_1: $Cooldowns/Ability1Cooldown,
	Ability.ABILITY_2: $Cooldowns/Ability2Cooldown,
}


func _ready() -> void:
	add_to_group("Player")


func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	self.velocity = move_dir * speed * delta
	self.move_and_slide()


func _input(event: InputEvent) -> void:
	var ability_action: String = _get_pressed_ability(event)
	if not ability_action: return

	var ability: Ability = ABILITY_ACTION_MAP[ability_action]
	if ability_on_cooldown[ability]: return
	_trigger_cooldown(ability)
	
	match (ability):
		Ability.ABILITY_1:
			pass # do the thing
		Ability.ABILITY_2:
			pass # do the thing


## loops through all actions in ABILITY_ACTION_MAP.
## returns the pressed action String if it exists. 
## otherwise, returns an empty string "", which is [b]falsy[/b].
func _get_pressed_ability(event: InputEvent) -> String:
	for action: String in ABILITY_ACTION_MAP.keys():
		if event.is_action_pressed(action):
			return action
	
	return ""


## sets an ability's cooldown to true and starts its timer
func _trigger_cooldown(ability: Ability) -> void:
	ability_on_cooldown[ability] = true
	ability_timers[ability].start()


func _on_ability_1_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_1] = false


func _on_ability_2_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_2] = false
