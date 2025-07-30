class_name Tower
extends Node2D

@export var valid_upgrades: Array[Upgrade]

var loop_interior: bool = true

var current_upgrades: Array[Upgrade]

func _on_area_2d_mouse_entered() -> void:
	Game.get_input_handler().hovered_tower = self

func _on_area_2d_mouse_exited() -> void:
	Game.get_input_handler().hovered_tower = null
