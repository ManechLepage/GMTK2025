class_name FunctionalUpgrade
extends Node

var parent: UpgradeManager
var tower: Tower

@export var upgrade: Upgrade

func _ready() -> void:
	parent = get_parent()
	tower = parent.get_parent()

func apply_upgrade() -> void:
	#print("Applying upgrade...")
	pass
