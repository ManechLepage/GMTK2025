extends FunctionalUpgrade

func apply_upgrade() -> void:
	super()
	tower.attack_manager.attack_speed_multiplier += 0.3
