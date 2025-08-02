extends FunctionalUpgrade

func apply_upgrade() -> void:
	super()
	
	tower.attack_manager.get_child(0).zap_quantity += 1
