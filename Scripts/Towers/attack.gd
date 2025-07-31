class_name Attack
extends Node2D

@export var projectile_scene: PackedScene
@export var projectile_size: float
@export var damage: float

@export var effects: Array[Game.Effects]

func load_new_projectile() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	add_child(projectile)
	
	projectile.scale.x = projectile_size
	projectile.scale.y = projectile_size
	
	projectile.attack = self
