class_name Attack
extends Node2D

@onready var timer: Timer = $Timer

@export var projectile_scene: PackedScene
@export var projectile_size: float
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

func load_new_projectile(target_position: Vector2) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	add_child(projectile)
	
	projectile.scale.x = projectile_size
	projectile.scale.y = projectile_size
	
	projectile.attack = self
	
	projectile.rotation = position.angle_to(target_position)

func _on_timer_timeout() -> void:
	if parent.pieces_in_range.size() > 0:
		load_new_projectile(parent.pieces_in_range[0].global_position)
