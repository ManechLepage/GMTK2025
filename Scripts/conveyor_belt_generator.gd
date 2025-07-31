extends Line2D


func _ready() -> void:
	_update_conveyor()


func _process(_delta) -> void:
	var pin := $"../ExcludedPins/Sprite2D2"
	pin.global_position = get_global_mouse_position()


func _on_conveyor_updater_timeout() -> void:
	_update_conveyor()


func _update_conveyor() -> void:
	var included_pin_parent := $"../IncludedPins"
	var included_pin_positions: Array[Vector2] = []
	
	for pin in included_pin_parent.get_children():
		included_pin_positions.append(pin.global_position)
	
	var excluded_pin_parent := $"../ExcludedPins"
	var excluded_pin_positions: Array[Vector2] = []
	
	for pin in excluded_pin_parent.get_children():
		excluded_pin_positions.append(pin.global_position)
	
	var polygon = _find_polygon(included_pin_positions, excluded_pin_positions)
	points = polygon


func _find_polygon(included: Array[Vector2], excluded: Array[Vector2]) -> Array[Vector2]:
	var hull_polygon := _find_hull_polygon(included)
	# On recalcule la taille à chaque itération, et on corrige INF et la gestion de 'set'
	var hull_set := {}  # en fait, un dictionnaire de chaînes
	for p in hull_polygon:
		hull_set[p] = true

	var remaining := []
	for e in excluded:
		if not hull_set.has(e) and _point_in_polygon(e, hull_polygon):
			remaining.append(e)

	while remaining.size() > 0:
		# 1) recalcule L et hull_set en début d'itération
		var L := hull_polygon.size()
		hull_set.clear()
		for p in hull_polygon:
			hull_set[p] = true

		# 2) milieux
		var midpoints := []
		for i in range(L):
			var a := hull_polygon[i]
			var b := hull_polygon[(i + 1) % L]
			var mid := Vector2((a.x + b.x) * 0.5, (a.y + b.y) * 0.5)
			midpoints.append([i, mid])

		# 3) recherche du meilleur exclu
		var best_e = null
		var best_i := -1
		var best_d := INF
		for e in remaining:
			for pair in midpoints:
				var i = pair[0]
				var m = pair[1]
				var d = e.distance_to(m)
				if d < best_d:
					best_d = d
					best_e = e
					best_i = i

		# 4) insertion
		var new_hull: Array[Vector2] = []
		for idx in range(hull_polygon.size()):
			new_hull.append(hull_polygon[idx])
			if idx == best_i:
				new_hull.append(best_e)
		hull_polygon = new_hull

		# 5) recalcul des remaining
		hull_set.clear()
		for p in hull_polygon:
			hull_set[p] = true

		remaining.clear()
		for e in excluded:
			if not hull_set.has(e) and _point_in_polygon(e, hull_polygon):
				remaining.append(e)

	return hull_polygon



func _find_hull_polygon(points) -> Array[Vector2]:
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


func _point_in_polygon(point, polygon) -> bool:
	var inside := false
	var n := len(polygon)
	for i in n:
		var x1 = polygon[i].x
		var y1 = polygon[i].y
		var x2 = polygon[(i + 1) % n].x
		var y2 = polygon[(i + 1) % n].y
		
		var denom = y2 - y1
		if abs(denom) < 1e-12:
			denom = 1e-12
		
		if ((y1 > point.y) != (y2 > point.y)) and \
			(point.x < (x2 - x1) * (point.y - y1) / denom + x1):
			inside = not inside
	
	return inside


func _sort_points(points) -> Array[Vector2]:
	var sorted_points: Array[Vector2] = []
	
	sorted_points = points.duplicate() as Array[Vector2]
	sorted_points.sort_custom(func(a: Vector2, b: Vector2) -> bool:
		return (a.x < b.x) or (is_equal_approx(a.x, b.x) and a.y < b.y)
	)
	
	return sorted_points


func orient(origin, point_a, point_b) -> float:
	return (point_a.x - origin.x) * (point_b.y - origin.y) - (point_a.y - origin.y) * (point_b.x - origin.x)
