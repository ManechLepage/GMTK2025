class_name Cog
extends Node2D

@export var speed: float

@onready var cog_1: Sprite2D = $Cog1
@onready var cog_2: Sprite2D = $Cog2
@onready var cog_3: Sprite2D = $Cog3

var freeze: bool = false

func _process(delta: float) -> void:
	if not freeze:
		cog_1.rotate(delta * speed * 0.5)
		cog_2.rotate(delta * speed * -1)
		cog_3.rotate(delta * speed * 1.5)
