class_name CameraManager
extends Camera2D

var shake_fade: float
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake(strength: float, _shake_fade: float) -> void:
	shake_fade = _shake_fade
	shake_strength = strength

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
