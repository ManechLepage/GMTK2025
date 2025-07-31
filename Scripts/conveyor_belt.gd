class_name ConveyorBelt
extends Line2D

@onready var towers: Node2D = $"../Towers"

@export var all_points: Array[Vector2]
@export var speed: float = 50.0

@onready var arrows: Path2D = $Arrows
@onready var pieces: Path2D = $Pieces


func _ready() -> void:
	pass

func get_all_points() -> Array:
	var interior_points: Array[Vector2] = all_points.duplicate()
	var exterior_points: Array[Vector2] = []
	
	#var current_points: Array[Vector2] = all_points.duplicate()
	#for tower: Tower in towers.get_children():
		#for placement: Node2D in tower.placements.get_children():
			#current_points.append(placement.global_position)
	#return current_points
	
	for tower: Tower in towers.get_children():
		for placement: Node2D in tower.placements.get_children():
			if tower.loop_interior:
				interior_points.append(placement.global_position)
			else:
				exterior_points.append(placement.global_position)
	
	return [interior_points, exterior_points]

func _process(delta: float) -> void:
	update_points()

func update_points() -> void:
	var all_pts: Array = get_all_points()
	var included_points: Array[Vector2] = all_pts[0]
	var excluded_points: Array[Vector2] = all_pts[1]
	
	points = _find_polygon(included_points, excluded_points)
	pieces.curve.clear_points()
	arrows.curve.clear_points()
	for point in points:
		pieces.curve.add_point(point)
		arrows.curve.add_point(point)


func _find_polygon(included: Array[Vector2], excluded: Array[Vector2], max_iters=100) -> Array[Vector2]:
	var hull := _find_hull_polygon(included)
	var it := 0
	
	while it < max_iters:
		var changed := false
		
		# First, exclude points strictly inside
		var result: Array = _insert_worst(hull, excluded, true)
		hull = result[0]
		var inc = result[1]
		
		if inc != null:
			changed = true
			var new_excs: Array[Vector2] = []
			for p in excluded:
				if p != inc and _point_in_polygon(p, hull):
					new_excs.append(p)
			excluded = new_excs
		
		# Next, include points strictly outside
		result = _insert_worst(hull, included, false)
		hull = result[0]
		
		var inc2 = result[1]
		if inc2 != null:
			changed = true
		
		if not changed:
			break
	
	return hull


func _select_maximin(candidates: Array) -> Variant:
	if candidates.is_empty():
		return null
	if candidates.size() == 1:
		return candidates[0]

	var best = null
	var best_min_dist = -1.0

	for p in candidates:
		var min_dist = INF
		for q in candidates:
			if q == p:
				continue
			var d = sqrt(pow(p[0] - q[0], 2) + pow(p[1] - q[1], 2))
			if d < min_dist:
				min_dist = d
		if min_dist > best_min_dist:
			best_min_dist = min_dist
			best = p

	return best


func _insert_worst(hull, points, inside=true) -> Array:
	var hull_set := {}  # To avoid duplicates
	for p in hull:
		hull_set[p] = true
	
	var best_e
	var best_i
	var best_d
	var midpoints
	var L
	
	if inside:
		var candidates: Array[Vector2] = []
		for p in points:
			if not hull_set.has(p) and _point_in_polygon(p, hull):
				candidates.append(p)
		best_e = _select_maximin(candidates)
	else:
		var candidates: Array[Vector2] = []
		for p in points:
			if not hull_set.has(p) and not _point_in_polygon(p, hull):
				candidates.append(p)
		
		best_e = null
		best_i = -1
		best_d = INF
		
		if candidates.size() > 0:
			midpoints = []
			L = hull.size()
			for i in range(L):
				var a = hull[i]
				var b = hull[(i + 1) % L]
				var mid := Vector2((a.x + b.x) * 0.5, (a.y + b.y) * 0.5)
				midpoints.append([mid.x, mid.y, i])
			
			for p in candidates:
				for m in midpoints:
					var mx = m[0]
					var my = m[1]
					var i = m[2]
					var d = sqrt(pow(p.x - mx, 2) + pow(p.y - my, 2))
					if d < best_d:
						best_d = d
						best_e = p
						best_i = i
	
	if best_e == null:
		return [hull, null]
	
	if inside:
		midpoints = []
		L = hull.size()
		
		for i in range(L):
				var a = hull[i]
				var b = hull[(i + 1) % L]
				var mid := Vector2((a.x + b.x) * 0.5, (a.y + b.y) * 0.5)
				midpoints.append([i, mid])
		
		best_i = -1
		best_d = INF
		
		for pair in midpoints:
			var i = pair[0]
			var m = pair[1]
			var d = best_e.distance_to(m)
			if d < best_d:
				best_d = d
				best_i = i
	
	var new_hull: Array[Vector2] = []
	for idx in range(hull.size()):
		new_hull.append(hull[idx])
		if idx == best_i:
			new_hull.append(best_e)
	
	return [new_hull, best_e]


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
