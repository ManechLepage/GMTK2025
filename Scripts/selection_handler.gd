class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower

var menu_select: Tower

@onready var wave_manager: WaveManager = $"../WaveManager"

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("LeftClick"):
		if hovered_tower:
			selected_tower = hovered_tower
			if menu_select:
				menu_select.unselect()
			menu_select = hovered_tower
			selected_tower.select()
	else:
		selected_tower = null
	if Input.is_action_just_pressed("PlayNextWave"):
		wave_manager.play_next_wave()

func _process(delta: float) -> void:
	if selected_tower:
		selected_tower.position = selected_tower.get_global_mouse_position()
