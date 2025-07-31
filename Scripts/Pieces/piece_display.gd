class_name PieceDisplay
extends PathFollow2D

var piece: Piece
@onready var texture: Sprite2D = $Texture
@onready var health_bar: TextureProgressBar = $HealthBar

func load_piece(_piece: Piece) -> void:
	piece = _piece
	texture.texture = piece.texture
	health_bar.max_value = piece.health
	health_bar.value = piece.health

func deal_damage(value: float, effects: Array[Game.Effects]) -> void:
	piece.health -= value
	health_bar.value = piece.health
	
	if piece.health < 0:
		on_death()

func on_death() -> void:
	var items: Array[Item] = piece.get_items_on_death()
	queue_free()
