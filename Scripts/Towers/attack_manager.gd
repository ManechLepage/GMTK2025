class_name AttackManager
extends Node2D

var pieces_in_range: Array[PieceDisplay]

@export var attack_speed_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0

func update() -> void:
	for attack: Attack in get_children():
		attack.update_attack_speed()
