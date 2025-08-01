class_name WaveGroup
extends Node

@export var delay: float

@export var piece: Piece
@export var quantity: int
@export var repetition_delay: float

func start_wave_group() -> void:
	for i in range(quantity):
		initiate_piece(piece)
		await Game.wait(repetition_delay)
	await Game.wait(delay)

func initiate_piece(piece: Piece) -> void:
	Game.get_conveyor_belt().pieces.create_piece(piece)
