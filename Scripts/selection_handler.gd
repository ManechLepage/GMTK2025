class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower
var show_radius_tower: Tower

var tower_offset = null
var can_drag_tower: bool = false

var menu_select: Tower

@onready var tower_menu: TowerMenu = %TowerMenu

@onready var main: Main = $".."
@onready var wave_manager: WaveManager = $"../WaveManager"

var did_move_mouse: bool = false
var last_mouse_pos = null

func _process(delta: float) -> void:
	var mouse_pos = main.get_global_mouse_position()
	if last_mouse_pos == null:
		last_mouse_pos = mouse_pos
	elif last_mouse_pos != mouse_pos:
		did_move_mouse = true
		last_mouse_pos = mouse_pos
	
	if selected_tower and can_drag_tower:
		if tower_offset != null:
			selected_tower.position = selected_tower.get_global_mouse_position() + tower_offset
		else:
			selected_tower.position = selected_tower.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		did_move_mouse = false
		if hovered_tower:
			if selected_tower != null and hovered_tower != selected_tower:
				selected_tower.unselect()
			
			selected_tower = hovered_tower
			selected_tower.select()
			show_radius_tower = selected_tower
			
			tower_offset = hovered_tower.global_position - main.get_global_mouse_position()
			
			can_drag_tower = true
			_select_tower(hovered_tower)

		else:
			if show_radius_tower:
				show_radius_tower.unselect()
				show_radius_tower = null
			if selected_tower != null:
				selected_tower.unselect()
				selected_tower = null
			tower_offset = null
	
	if Input.is_action_just_released("LeftClick"):
		if not did_move_mouse and selected_tower != null:
			main.show_menu()
		
		did_move_mouse = false
		last_mouse_pos = null
		tower_offset = null
		can_drag_tower = false
	
	if Input.is_action_just_pressed("PlayNextWave"):
		wave_manager.play_next_wave()
	
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = false
		tower_menu.hide_menu()

func _select_tower(tower) -> void:
	selected_tower = tower
	if menu_select:
		menu_select.unselect()
	menu_select = tower
	selected_tower.select()
	show_radius_tower = selected_tower
