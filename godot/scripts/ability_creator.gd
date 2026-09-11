extends Node

func run_ability(ability : BaseAbility) -> void:
	var default_spell : BaseSpell = BaseSpell.new()
	default_spell.run(ability)
