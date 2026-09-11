class_name BaseVIP
extends BaseNPC


func _on_target_scanned(character: BaseCharacter, flee: bool) -> void:
	if flee: target_to_flee_from = character
