extends FunctionalUpgrade

@export var ice_beam_attack: PackedScene

func apply_upgrade() -> void:
	super()
	var attack: Attack = ice_beam_attack.instantiate()
	var attack_count: int = -1
	for previous_attack: Attack in tower.attack_manager.get_children():
		if previous_attack.attack_id == 1:
			attack_count += 1
	
	tower.attack_manager.add_child(attack)
	attack.target_index = attack_count
