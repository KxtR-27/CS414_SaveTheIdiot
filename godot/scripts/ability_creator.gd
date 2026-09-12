extends Node

func run_ability(ability : BaseAbility, caster : BaseCharacter) -> void:
	match ability.ability_type:
		"aura":
			#create new node for the aura spell and child it under self
			var aura_spell_node : PackedScene = load("res://components/spells/aura_spell/aura_spell.tscn")
			var new_aura_spell : BaseSpell = aura_spell_node.instantiate()
			add_child(new_aura_spell)
			
			#run the spell with current ability parameters and caster
			new_aura_spell.run(ability, caster)
		
		"test":
			print("test ability used")


func _on_base_player_ability_used(ability: BaseAbility, caster : BaseCharacter) -> void:
	run_ability(ability, caster)
