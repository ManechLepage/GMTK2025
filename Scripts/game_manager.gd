class_name GameManage
extends Node

@onready var laser_attack: AudioStreamPlayer = $LaserAttack
@onready var freeze_attack: AudioStreamPlayer = $FreezeAttack
@onready var zap_attack: AudioStreamPlayer = $ZapAttack
@onready var ice_beam_attack: AudioStreamPlayer = $IceBeamAttack
@onready var hurt: AudioStreamPlayer = $Hurt
@onready var buy: AudioStreamPlayer = $Buy
@onready var start_wave: AudioStreamPlayer = $StartWave
@onready var lose: AudioStreamPlayer = $Lose
@onready var kill_piece: AudioStreamPlayer = $KillPiece
@onready var burn: AudioStreamPlayer = $Burn
@onready var win: AudioStreamPlayer = $Win

var difficulty_time_multiplier: float = 1.0

enum Effects {
	FREEZE,
	BURN,
	KNOCKBACK
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

func add_item(item: Item, value: int = 1) -> void:
	if item.name == "Core":
		get_main().add_core(value)
	elif item.name == "Gold":
		get_main().add_gold(value)
	elif item.name == "Copper":
		get_main().add_copper(value)
	elif item.name == "Steel":
		get_main().add_steel(value)
	else:
		get_main().add_wood(value)
