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

func get_main() -> Main:
	return get_tree().get_first_node_in_group("Main")

func get_tower_menu() -> TowerMenu:
	return get_tree().get_first_node_in_group("TowerMenu")

signal add_tower(tower: Tower)

func wait(time: float) -> void:
	await get_tree().create_timer(time * difficulty_time_multiplier).timeout

func add_item(item: Item) -> void:
	if item.name == "Core":
		get_main().add_core(1)
	elif item.name == "Gold":
		get_main().add_gold(1)
	elif item.name == "Copper":
		get_main().add_gold(1)
	elif item.name == "Steel":
		get_main().add_steel(1)
	else:
		get_main().add_wood(1)
