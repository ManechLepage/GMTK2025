class_name PieceDisplay
extends PathFollow2D

var piece: Piece
@onready var texture: Sprite2D = $Texture

func load_piece(_piece: Piece) -> void:
	piece = _piece
	texture.texture = piece.texture
