class_name ConveyorBelt
extends Line2D

@onready var towers: Node2D = $"../Towers"

@export var all_points: Array[Vector2]
@onready var path_2d: Path2D = $Path2D

func _ready() -> void:
	pass

func get_all_points() -> Array[Vector2]:
	var current_points: Array[Vector2] = all_points.duplicate()
	for tower: Tower in towers.get_children():
		for placement: Node2D in tower.placements.get_children():
			current_points.append(placement.global_position)
	return current_points

func _process(delta: float) -> void:
	update_points()

func update_points() -> void:
	points = _find_polygon(get_all_points())
	path_2d.curve.clear_points()
	for point in points:
		path_2d.curve.add_point(point)

func _find_polygon(points: Array[Vector2]) -> Array[Vector2]:
	
	var polygon: Array[Vector2] = []
	var sorted_points := _sort_points(points)
	
	if len(sorted_points) <= 1:
		return sorted_points.duplicate()
	
	var lower: Array[Vector2] = []
	for p in sorted_points:
		while len(lower) >= 2 and orient(lower[-2], lower[-1], p) <= 0:
			lower.pop_at(-1)
		lower.append(p)
	
	sorted_points.reverse()
	
	var upper: Array[Vector2] = []
	for p in sorted_points:
		while len(upper) >= 2 and orient(upper[-2], upper[-1], p) <= 0:
			upper.pop_at(-1)
		upper.append(p)
	
	polygon = lower.slice(0, lower.size() - 1) + upper.slice(0, upper.size() - 1)
	
	return polygon


func _sort_points(points) -> Array[Vector2]:
	var sorted_points: Array[Vector2] = []
	
	sorted_points = points.duplicate() as Array[Vector2]
	sorted_points.sort_custom(func(a: Vector2, b: Vector2) -> bool:
		return (a.x < b.x) or (is_equal_approx(a.x, b.x) and a.y < b.y)
	)
	
	return sorted_points


func orient(origin, point_a, point_b) -> float:
	return (point_a.x - origin.x) * (point_b.y - origin.y) - (point_a.y - origin.y) * (point_b.x - origin.x)
