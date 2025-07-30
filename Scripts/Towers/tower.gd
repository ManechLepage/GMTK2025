class_name Tower
extends Node2D

@export var valid_upgrades: Array[Upgrade]
@export var attack_radius: float = 80.0
@onready var radius_area: CollisionShape2D = $AttackArea/RadiusArea
@onready var placements: Node2D = $Placements

var loop_interior: bool = true

var current_upgrades: Array[Upgrade]

func _ready() -> void:
	update_stats()

func _on_area_2d_mouse_entered() -> void:
	Game.get_input_handler().hovered_tower = self

func _on_area_2d_mouse_exited() -> void:
	Game.get_input_handler().hovered_tower = null

func update_stats() -> void:
	radius_area.shape.radius = attack_radius
