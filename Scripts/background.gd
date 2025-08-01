extends ColorRect

var offset: Vector2

@export var speed: float

func _process(delta: float) -> void:
	offset.x += speed * delta
	offset.y += speed * delta
	material.set_shader_parameter("offset", offset)
