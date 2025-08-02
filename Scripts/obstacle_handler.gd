extends Node2D

@onready var obstacle_parent = $"../Obstacles"
@onready var first_triangle = $"../ObstacleTriangles/First"
@onready var second_triangle = $"../ObstacleTriangles/Second"
var obstacle_scene: PackedScene = load("res://Scenes/obstacle.tscn")

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var screen_size: Vector2 = get_viewport_rect().size
	
	# First triangle
	var p1 = first_triangle.get_children()[0].global_position
	var p2 = first_triangle.get_children()[0].global_position
	var p3 = first_triangle.get_children()[0].global_position
	
	var obstacle1 = _random_point_in_triangle(rng, p1, p2, p3)
	var obstacle1_scale = rng.randf_range(0.75, 2)
	_spawn_obstacle(obstacle1, obstacle1_scale)
	
	# Second triangle
	p1 = second_triangle.get_children()[0].global_position
	p2 = second_triangle.get_children()[0].global_position
	p3 = second_triangle.get_children()[0].global_position
	
	var obstacle2 = _random_point_in_triangle(rng, p1, p2, p3)
	var obstacle2_scale = rng.randf_range(0.75, 2)
	_spawn_obstacle(obstacle2, obstacle2_scale)

func _spawn_obstacle(position, scale):
	var obstacle = obstacle_scene.instantiate()
	obstacle.scale = Vector2(scale, scale)
	obstacle.global_position = position
	obstacle_parent.add_child(obstacle)

func _random_point_in_triangle(rng, p1, p2, p3):
	var u = rng.randf_range(0, 1)
	var v = rng.randf_range(0, 1)
	
	if u + v > 1:
		u = 1 - u
		v = 1 - v
	
	return p1 + u * (p2 - p1) + v * (p3 - p1)
