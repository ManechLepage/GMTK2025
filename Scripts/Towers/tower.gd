class_name Tower
extends Node2D

@export var attack_radius: float = 1.0
@onready var placements: Node2D = $Placements
@onready var area_of_attack: Sprite2D = $AreaOfAttack
@onready var area_of_attack_collision: Area2D = $AreaOfAttackCollision
@onready var attack_manager: AttackManager = $AttackManager
@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var texture: Sprite2D = $Texture

@export var loop_interior: bool = true
@export var placed: bool = true

var current_upgrades: Array[Upgrade]
var current_shop: Array[Upgrade]

@export var upgrade_pool: Array[Upgrade]


func _ready() -> void:
	update_stats()
	Game.add_tower.emit(self)
	load_new_shop()

func _on_area_2d_mouse_entered() -> void:
	Game.get_input_handler().hovered_tower = self

func _on_area_2d_mouse_exited() -> void:
	if Game.get_input_handler().hovered_tower == self:
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

func _on_area_of_attack_collision_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Piece"):
		attack_manager.pieces_in_range.append(area.get_parent())

func _on_area_of_attack_collision_area_exited(area: Area2D) -> void:
	attack_manager.pieces_in_range.erase(area.get_parent())

func load_new_shop() -> void:
	current_shop.clear()
	var temp_upgrade_pool: Array[Upgrade] = upgrade_pool.duplicate()
	for i in range(3):
		if temp_upgrade_pool.size() > 0:
			var upgrade: Upgrade = temp_upgrade_pool.pick_random()
			temp_upgrade_pool.erase(upgrade)
			current_shop.append(upgrade)

func apply_upgrade(upgrade: Upgrade) -> void:
	upgrade_manager.apply_upgrade(upgrade)
