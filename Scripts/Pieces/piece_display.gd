class_name PieceDisplay
extends PathFollow2D

var piece: Piece

@onready var texture: Sprite2D = $Texture
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var burn_timer: Timer = $BurnTimer

@export var burn_color: Color
@export var freeze_color: Color

var did_damage: bool = false
var is_dead: bool = false

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
			if effect == Game.Effects.FREEZE:
				apply_freeze()
			if effect == Game.Effects.KNOCKBACK:
				apply_knockback()
	
	if piece.health <= 0:
		on_death()

func on_death() -> void:
	is_dead = true
	Game.kill_piece.play()
	var items: Array[Item] = piece.get_items_on_death()
	for item in items:
		Game.add_item(item)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.3).from(Vector2(1.0, 1.0)).set_trans(Tween.TRANS_BACK)	
	await tween.finished
	queue_free()

func apply_burn() -> void:
	burn_timer.start()

func apply_freeze() -> void:
	var tween = create_tween()
	tween.tween_property(texture, "modulate", freeze_color, 0.2)
	piece.speed *= 0.7
	
	await get_tree().create_timer(1.5).timeout
	
	var tween2 = create_tween()
	tween2.tween_property(texture, "modulate", Color.WHITE, 0.2)
	piece.speed *= 2

func apply_knockback() -> void:
	var tween = create_tween()
	tween.tween_property(self, "progress", 15.0, 0.4).as_relative()
	progress = max(1.0, progress)

func _on_burn_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(texture, "modulate", burn_color, 0.2)
	await tween.finished
	Game.burn.play()
	deal_damage(0.5)
	tween.tween_property(texture, "modulate", Color.WHITE, 0.2)

func _process(delta: float) -> void:
	if progress_ratio < 0.01:
		deal_player_damage()
		did_damage = true

func deal_player_damage() -> void:
	if not did_damage and not is_dead:
		Game.get_main().deal_player_damage()
		Game.get_main().camera_2d.apply_shake(1.0, 10.0)
		Game.hurt.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3).from(Vector2(1.0, 1.0)).set_trans(Tween.TRANS_BACK)
	await tween.finished
	queue_free()
