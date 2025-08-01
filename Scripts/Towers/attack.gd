class_name Attack
extends Node2D

@onready var timer: Timer = $Timer

@export var projectile_scene: PackedScene
@export var damage: float
@export var bullet_speed: float = 5.0
@export var attack_speed: float = 1.0

@export var effects: Array[Game.Effects]

var parent: AttackManager

func _ready() -> void:
	update_attack_speed()
	parent = get_parent()

func update_attack_speed() -> void:
	timer.wait_time = 1.0 / attack_speed

func load_new_projectile(target_piece: PieceDisplay) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.attack = self
	
	projectile.piece = target_piece
	
	add_child(projectile)
	

func _on_timer_timeout() -> void:
	if parent.pieces_in_range.size() > 0:
		load_new_projectile(parent.pieces_in_range[0])
