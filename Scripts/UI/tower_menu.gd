class_name TowerMenu
extends Panel

@onready var blur: ColorRect = %Blur

@export var hidden_pos: Vector2
@export var shown_pos: Vector2

func _ready() -> void:
	position = hidden_pos

func show_menu() -> void:
	var tween = create_tween()
	position = hidden_pos
	tween.tween_property(self, "position", shown_pos, 0.5).set_trans(Tween.TRANS_BACK)
	await tween.finished
	blur.visible = true

func hide_menu() -> void:
	var tween = create_tween()
	blur.visible = false
	position = shown_pos
	tween.tween_property(self, "position", hidden_pos, 0.5).set_trans(Tween.TRANS_BACK)
	await tween.finished
