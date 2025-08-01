extends FunctionalUpgrade

@export var beam_attack: PackedScene

func apply_upgrade() -> void:
	super()
	var attack: Attack = beam_attack.instantiate()
	tower.attack_manager.add_child(attack)
