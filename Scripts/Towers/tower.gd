class_name Tower
extends Node2D

@export var valid_upgrades: Array[Upgrade]
@export var attack_radius: float = 1.0
@onready var placements: Node2D = $Placements
@onready var area_of_attack: Sprite2D = $AreaOfAttack
@onready var area_of_attack_collision: Area2D = $AreaOfAttackCollision

var loop_interior: bool = true

var current_upgrades: Array[Upgrade]

func _ready() -> void:
	update_stats()
	Game.add_tower.emit(self)

func _on_area_2d_mouse_entered() -> void:
	Game.get_input_handler().hovered_tower = self

func _on_area_2d_mouse_exited() -> void:
	Game.get_input_handler().hovered_tower = null

func update_stats() -> void:
	area_of_attack.scale.x = attack_radius
	area_of_attack.scale.y = attack_radius
	area_of_attack_collision.scale.x = attack_radius
	area_of_attack_collision.scale.y = attack_radius

func select() -> void:
	area_of_attack.visible = true

func unselect() -> void:
	area_of_attack.visible = false
