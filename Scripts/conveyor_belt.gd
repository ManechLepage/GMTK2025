class_name ConveyorBelt
extends Line2D

@export var all_points: PackedVector2Array

func _ready() -> void:
	Game.add_tower.connect(add_tower)

func add_tower(tower: Tower) -> void:
	for placement in tower.placements.get_children():
		all_points.append(placement.global_position)

func _process(delta: float) -> void:
	update_points()

func update_points() -> void:
	pass
