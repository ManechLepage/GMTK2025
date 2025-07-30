extends Line2D


func _ready() -> void:
	_update_conveyor()


func _process(_delta) -> void:
	var pin := $"../Pins/Sprite2D8"
	pin.position = get_global_mouse_position()


func _on_conveyor_updater_timeout() -> void:
	_update_conveyor()


func _update_conveyor() -> void:
	var pins_parent := $"../Pins"
	var pins_positions: Array[Vector2] = []
	
	for pin in pins_parent.get_children():
		pins_positions.append(pin.global_position)
	
	var polygon = _find_polygon(pins_positions)
	points = polygon


func _find_polygon(points) -> Array[Vector2]:
	#var polygon: Array[Vector2] = [
		#Vector2(-50, -50),
		#Vector2(10, 75),
		#Vector2(30, 45),
		#Vector2(-50, -50)
	#]
	
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
