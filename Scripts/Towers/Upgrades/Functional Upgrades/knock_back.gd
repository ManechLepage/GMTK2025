extends FunctionalUpgrade

func apply_upgrade() -> void:
	super()
	
	tower.attack_manager.global_effects.append(Game.Effects.KNOCKBACK)
	tower.attack_manager.update()
