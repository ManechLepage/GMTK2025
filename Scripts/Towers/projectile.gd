class_name Projectile
extends Node2D

var attack: Attack

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Piece"):
		destroy(area.get_parent() as PieceDisplay)

func destroy(piece: PieceDisplay) -> void:
	piece.deal_damage(attack.damage, attack.effects)
	queue_free()
