extends Path2D

@onready var conveyor_belt: ConveyorBelt = $".."

const PIECE = preload("res://Scenes/Conveyor/piece.tscn")

func _process(delta: float) -> void:
	for follow: PieceDisplay in get_children():
		follow.progress -= follow.piece.speed * delta

func create_piece(piece: Piece) -> void:
	var piece_display: PieceDisplay = PIECE.instantiate()
	add_child(piece_display)
	piece_display.load_piece(piece.duplicate(true))
