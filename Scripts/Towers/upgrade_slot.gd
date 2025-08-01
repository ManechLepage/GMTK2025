class_name UpgradeDisplay
extends Button

var upgrade: Upgrade

const ITEM_COST = preload("res://Scenes/Towers/UI/item_cost.tscn")

@onready var name_label: Label = $Name
@onready var cost: HBoxContainer = $Cost

func load_upgrade(_upgrade: Upgrade) -> void:
	upgrade = _upgrade
	
