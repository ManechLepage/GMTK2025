class_name PieceDisplay
extends PathFollow2D

var piece: Piece

@onready var texture: Sprite2D = $Texture
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var burn_timer: Timer = $BurnTimer

@export var burn_color: Color

func load_piece(_piece: Piece) -> void:
	piece = _piece
	texture.texture = piece.texture
	health_bar.max_value = piece.health
	health_bar.value = piece.health
	animate_piece()

func animate_piece() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).from(Vector2(0.0, 0.0)).set_trans(Tween.TRANS_BACK)

func deal_damage(value: float, effects: Array[Game.Effects] = []) -> void:
	piece.health -= value
	health_bar.value = piece.health
	
	for effect: Game.Effects in effects:
		if not effect in piece.effects:
			piece.effects.append(effect)
			if effect == Game.Effects.BURN:
				apply_burn()
	
	if piece.health <= 0:
		on_death()

func on_death() -> void:
	var items: Array[Item] = piece.get_items_on_death()
	for item in items:
		Game.add_item(item)
	queue_free()

func apply_burn() -> void:
	burn_timer.start()

func _on_burn_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", burn_color, 0.2)
	await tween.finished
	deal_damage(0.5)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
