class_name GameManage
extends Node

func get_input_handler() -> SelectionHandler:
	return get_tree().get_first_node_in_group("InputHandler")

signal add_tower(tower: Tower)
