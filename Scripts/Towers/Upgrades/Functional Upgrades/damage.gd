extends FunctionalUpgrade

func apply_upgrade() -> void:
	super()
	tower.attack_manager.damage_multiplier += 0.3
