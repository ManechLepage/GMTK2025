class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("LeftClick"):
		if hovered_tower:
			selected_tower = hovered_tower
	else:
		selected_tower = null

func _process(delta: float) -> void:
	if selected_tower:
		selected_tower.position = selected_tower.get_global_mouse_position()
