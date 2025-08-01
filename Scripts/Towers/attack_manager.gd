class_name AttackManager
extends Node2D

var pieces_in_range: Array[PieceDisplay]

var global_effects: Array[Game.Effects]

@export var attack_speed_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0

func update() -> void:
	for attack: Attack in get_children():
		attack.update_attack_speed()
		
		for global_effect: Game.Effects in global_effects:
			if not global_effect in attack.effects:
				attack.effects.append(global_effect)
