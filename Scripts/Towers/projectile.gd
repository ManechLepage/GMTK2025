class_name Projectile
extends Line2D

var attack: Attack
var piece: PieceDisplay

enum AttackType {
	BEAM,
	RANGE,
	ZAP
}

@export var attack_type: AttackType
@onready var beam_particles: CPUParticles2D = $BeamParticles

func _process(delta: float) -> void:
	if attack_type == AttackType.BEAM:
		process_beam()

func process_beam() -> void:
	if piece:
		points[1] = to_local(piece.global_position)
		
		beam_particles.rotation = points[0].angle_to_point(points[1])
		
		beam_particles.position.x = (points[0].x + points[1].x) / 2
		beam_particles.position.y = (points[0].y + points[1].y) / 2
		
		beam_particles.emission_rect_extents.x = beam_particles.position.x * 2

func _ready() -> void:
	if attack_type == AttackType.BEAM:
		initialize_beam()
	elif attack_type == AttackType.RANGE:
		initialize_range()

func initialize_beam() -> void:
	beam_particles.emitting = true
	width = 0.0
	
	var tween = create_tween()
	tween.tween_property(self, "width", 5.0, 1 / (attack.attack_speed * attack.parent.attack_speed_multiplier * 3))
	
	await tween.finished
	if piece:
		destroy(piece)
	queue_free()

func initialize_range() -> void:
	points.clear()
	
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(2.8, 2.8), 1 / (attack.attack_speed * attack.parent.attack_speed_multiplier * 3)).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D, "modulate:a", 0.0,  1 / (attack.attack_speed * attack.parent.attack_speed_multiplier * 3)).set_ease(Tween.EASE_IN)
	
	await tween.finished
	queue_free()

func destroy(piece: PieceDisplay) -> void:
	piece.deal_damage(attack.damage * attack.parent.damage_multiplier, attack.effects)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Piece") and attack_type == AttackType.RANGE:
		destroy(area.get_parent())
