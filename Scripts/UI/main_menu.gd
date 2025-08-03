class_name MainMenu
extends Node2D

@onready var title: Label = %Title
@onready var conveyor_belt: ConveyorAnimation = $ConveyorBelt
@onready var conveyor_belt_2: ConveyorAnimation = $ConveyorBelt2
@onready var play_button: TextureButton = %PlayButton
@onready var animation: ColorRect = $Animation

const MAIN = preload("res://Scenes/main.tscn")

func _ready() -> void:
	animate_title()

func animate_title() -> void:
	var tween = create_tween()
	tween.tween_property(title, "position", Vector2(0.0, -140.0), 2.0).as_relative().set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	conveyor_belt.start_animation()
	await conveyor_belt_2.start_animation()
	
	Game.music.play()
	
	conveyor_belt.start_spawning()
	
	play_button.modulate.a = 0.0
	play_button.visible = true
	var tween2 = create_tween()
	tween2.tween_property(play_button, "modulate:a", 1.0, 1.5).set_ease(Tween.EASE_OUT)
	await tween2.finished

func play_animation() -> void:
	conveyor_belt.timer.stop()
	for i in conveyor_belt.get_children():
		var tween = create_tween()
		tween.tween_property(i, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_BACK)
		await get_tree().create_timer(0.2).timeout
	
	conveyor_belt.animate_reverse()
	await conveyor_belt_2.animate_reverse()
	
	var tween_2 = create_tween()
	tween_2.tween_property(play_button, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT)
	
	var tween_3 = create_tween()
	tween_3.tween_property(title, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT)
	
	var tween_4 = create_tween()
	tween_4.tween_method(tween_animation, -1.0, 1.0, 1.5).set_ease(Tween.EASE_IN)
	await tween_4.finished
	
	get_tree().change_scene_to_packed(MAIN)

func tween_animation(value: float) -> void:
	animation.material.set_shader_parameter("height", value)

func _on_play_button_pressed() -> void:
	play_animation()
