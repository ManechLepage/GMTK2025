extends FunctionalUpgrade

func apply_upgrade() -> void:
	super()
	
	tower.attack_radius *= 1.3
	tower.attack_manager.update()
