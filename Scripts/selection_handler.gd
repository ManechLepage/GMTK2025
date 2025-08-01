class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower
var show_radius_tower: Tower

var menu_select: Tower

@onready var wave_manager: WaveManager = $"../WaveManager"

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		if hovered_tower:
			_select_tower(hovered_tower)
		elif show_radius_tower:
			show_radius_tower.unselect()
			show_radius_tower = null
	
	if Input.is_action_just_released("LeftClick"):
		selected_tower = null
	
	if Input.is_action_just_pressed("PlayNextWave"):
		wave_manager.play_next_wave()

func _select_tower(tower) -> void:
	selected_tower = tower
	if menu_select:
		menu_select.unselect()
	menu_select = tower
	selected_tower.select()
	show_radius_tower = selected_tower

func _process(delta: float) -> void:
	if selected_tower:
		selected_tower.position = selected_tower.get_global_mouse_position()
