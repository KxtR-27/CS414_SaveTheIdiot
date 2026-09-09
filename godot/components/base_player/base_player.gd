class_name BasePlayer
extends CharacterBody2D

@export_group("")
@export var speed: float = 10000

@export_group("Components")
@export var health_component : HealthComponent
@export var damage_component : DamageComponent


# when you add a new ability action to the InputMap,
# put a new value in this enum
enum Ability {
	ABILITY_1,
	ABILITY_2,
	ATTACK,
}

# when you add a new ability action to the InputMap, put it here.
# key: StringName of the action
# value: corresponding Ability enum value
const ABILITY_ACTION_MAP: Dictionary[String, Ability] = {
	"ability_1": Ability.ABILITY_1,
	"ability_2": Ability.ABILITY_2,
	"attack" : Ability.ATTACK,
}


# when you add a new ability, put it here
var ability_on_cooldown: Dictionary[Ability, bool] = {
	Ability.ABILITY_1: false, 
	Ability.ABILITY_2: false,
	Ability.ATTACK: false,
}

# when you add a new ability, make a timer and link it here
@onready var ability_timers: Dictionary[Ability, Timer] = {
	Ability.ABILITY_1: $Cooldowns/Ability1Cooldown,
	Ability.ABILITY_2: $Cooldowns/Ability2Cooldown,
	Ability.ATTACK: $Cooldowns/AttackCooldown,
}


func _ready() -> void:
	add_to_group("Player")


func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	self.velocity = move_dir * speed * delta
	self.move_and_slide()


func _input(event: InputEvent) -> void:
	# check pressed action to see if it's an ability
	var ability_action: String = _get_pressed_ability(event)
	if not ability_action: return

	# get the Ability enum value
	var ability: Ability = ABILITY_ACTION_MAP[ability_action]
	# return early if it's on cooldown
	if ability_on_cooldown[ability]: return
	# otherwise, start the cooldown
	_trigger_cooldown(ability)
	
	match (ability):
		Ability.ABILITY_1:
			pass # do the thing
		Ability.ABILITY_2:
			pass # do the thing
		Ability.ATTACK:
			#play attack animation
			var sprite : AnimatedSprite2D = $Sprite
			sprite.play("attack")
			
			#use animationplayer to turn hitbox on and off
			var sword_animator : AnimationPlayer = $SwordHitboxAnimator
			sword_animator.play("attack")
			


## loops through all actions in ABILITY_ACTION_MAP.
## returns the pressed action String if it exists. 
## otherwise, returns an empty string "", which is [b]falsy[/b].
func _get_pressed_ability(event: InputEvent) -> String:
	for action: String in ABILITY_ACTION_MAP.keys():
		if event.is_action_pressed(action):
			return action
	
	return ""


## sets an ability's cooldown to true and starts its cooldown timer
func _trigger_cooldown(ability: Ability) -> void:
	ability_on_cooldown[ability] = true
	ability_timers[ability].start()


func _on_ability_1_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_1] = false


func _on_ability_2_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_2] = false


func _on_attack_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ATTACK] = false


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var enemy : BaseEnemy = body
		damage_component.deal_damage(25, enemy)
	pass # Replace with function body.


func _on_health_component_died() -> void:
	self.queue_free()
	pass # Replace with function body.
