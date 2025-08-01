class_name Projectile
extends Line2D

var attack: Attack
var piece: PieceDisplay

@onready var beam_particles: CPUParticles2D = $BeamParticles

func _process(delta: float) -> void:
	if piece:
		points[1] = to_local(piece.global_position)
		
		beam_particles.rotation = points[0].angle_to_point(points[1])
		
		beam_particles.position.x = (points[0].x + points[1].x) / 2
		beam_particles.position.y = (points[0].y + points[1].y) / 2
		
		beam_particles.emission_rect_extents.x = beam_particles.position.x * 2

func _ready() -> void:
	width = 0.0
	
	var tween = create_tween()
	tween.tween_property(self, "width", 5.0, 1 / (attack.attack_speed * attack.parent.attack_speed_multiplier * 3))
	
	await tween.finished
	if piece:
		destroy(piece)
	queue_free()

func destroy(piece: PieceDisplay) -> void:
	piece.deal_damage(attack.damage * attack.parent.damage_multiplier, attack.effects)
