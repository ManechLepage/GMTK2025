class_name GameManage
extends Node

var difficulty_time_multiplier: float = 1.0

enum Effects {
	FREEZE,
	BURN
}

func get_input_handler() -> SelectionHandler:
	return get_tree().get_first_node_in_group("InputHandler")

func get_conveyor_belt() -> ConveyorBelt:
	return get_tree().get_first_node_in_group("ConveyorBelt")

signal add_tower(tower: Tower)

func wait(time: float) -> void:
	await get_tree().create_timer(time * difficulty_time_multiplier).timeout
