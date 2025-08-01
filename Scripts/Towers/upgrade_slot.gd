class_name UpgradeDisplay
extends Button

var upgrade: Upgrade

const ITEM_COST = preload("res://Scenes/Towers/UI/item_cost.tscn")

@onready var name_label: Label = $Name
@onready var cost: HBoxContainer = $Cost

@export var default_upgrade: Upgrade

func _ready() -> void:
	load_upgrade(default_upgrade)

func load_upgrade(_upgrade: Upgrade) -> void:
	upgrade = _upgrade

func _on_mouse_entered() -> void:
	Game.get_tower_menu().show_description(upgrade)

func _on_mouse_exited() -> void:
	Game.get_tower_menu().hide_description()
