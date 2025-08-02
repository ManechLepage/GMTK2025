class_name Attack
extends Node2D

@onready var timer: Timer = $Timer

@export var projectile_scene: PackedScene
@export var damage: float
@export var bullet_speed: float = 5.0
@export var attack_speed: float = 1.0

@export var effects: Array[Game.Effects]

var parent: AttackManager
@export var target_index: int = 0

@export var attack_id: int = 0

var zap_quantity: int = 2

func _ready() -> void:
	parent = get_parent()
	update_attack_speed()

func update_attack_speed() -> void:
	timer.wait_time = 1.0 / (attack_speed * parent.attack_speed_multiplier)

func load_new_projectile(target_piece: PieceDisplay) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.attack = self
	
	projectile.piece = target_piece
	
	add_child(projectile)

func _on_timer_timeout() -> void:
	if parent.pieces_in_range.size() > target_index:
		load_new_projectile(parent.pieces_in_range[target_index])
