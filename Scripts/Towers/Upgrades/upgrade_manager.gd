class_name UpgradeManager
extends Node

func apply_upgrade(upgrade: Upgrade) -> void:
	for functional_upgrade: FunctionalUpgrade in get_children():
		if functional_upgrade.upgrade.name == upgrade.name:
			functional_upgrade.apply_upgrade()
