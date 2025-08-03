class_name ConveyorAnimation
extends Line2D

@export var reverse: bool
@export var pieces: Array[Piece]
@onready var timer: Timer = $"../Timer"

func start_animation() -> void:
	var final_position: Vector2 = Vector2(192.0, position.y)
	if reverse:
		final_position = Vector2(-192.0, position.y)
	
	add_point(points[0])
	var tween = create_tween()
	tween.tween_method(tween_position, position, final_position, 1.5).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func animate_reverse() -> void:
	var tween = create_tween()
	tween.tween_method(tween_position, points[1], position, 1.5).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func tween_position(interpolate_position: Vector2) -> void:
	points = [position, interpolate_position]

func start_spawning() -> void:
	timer.start()

func create_piece(piece: Piece) -> void:
	var piece_display: Sprite2D = Sprite2D.new()
	piece_display.texture = piece.texture
	piece_display.scale = Vector2(0.8, 0.8)
	add_child(piece_display)

func _on_timer_timeout() -> void:
	create_piece(pieces.pick_random())

func _process(delta: float) -> void:
	for child in get_children():
		if reverse:
			child.position.x -= 1.0
		else:
			child.position.x += 1.0
