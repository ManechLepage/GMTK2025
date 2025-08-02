class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower

var tower_offset = null
var can_drag_tower: bool = false

var is_in_menu: bool

@onready var tower_menu: TowerMenu = %TowerMenu

@onready var main: Main = $".."
@onready var wave_manager: WaveManager = $"../WaveManager"

@onready var wave_button_start: TextureButton = %WaveButtonStart
@onready var wave_button_pause: TextureButton = %WaveButtonPause

@onready var conveyor = $"../ConveyorBelt"


func _process(delta: float) -> void:
	if selected_tower and can_drag_tower:
		if Input.is_action_pressed("ShiftMoveTower"):
			selected_tower.placed = false
			var in_conveyor: bool = conveyor._position_in_conveyor(selected_tower.global_position)
			selected_tower.loop_interior = in_conveyor
		elif Input.is_action_just_released("ShiftMoveTower"):
			selected_tower.placed = true
		
		if tower_offset != null:
			selected_tower.position = selected_tower.get_global_mouse_position() + tower_offset
		else:
			selected_tower.position = selected_tower.get_global_mouse_position()
	
	if main.game_state == main.GameState.BUILDING:
		wave_button_start.visible = true
		wave_button_pause.visible = false
	elif main.game_state == main.GameState.ROUND:
		wave_button_start.visible = false
		wave_button_pause.visible = true
	else:
		wave_button_start.visible = true
		wave_button_pause.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		if is_in_menu:
			exit_menu()
		if hovered_tower and main.game_state == main.GameState.BUILDING:
			if selected_tower != null and hovered_tower != selected_tower:
				selected_tower.unselect()
			
			_select_tower(hovered_tower)
			can_drag_tower = true
	
	if Input.is_action_just_released("LeftClick"):
		if selected_tower:
			selected_tower.placed = true
		_unselect_tower()
		tower_offset = null
		can_drag_tower = false
	
	if Input.is_action_just_released("RightClick"):
		if hovered_tower:
			is_in_menu = true
			main.show_menu()
	
	if Input.is_action_just_pressed("PlayNextWave"):
		play_wave_request()
	
	if Input.is_action_just_pressed("Escape"):
		if is_in_menu:
			exit_menu()

func _select_tower(tower) -> void:
	selected_tower = tower
	tower_offset = selected_tower.global_position - main.get_global_mouse_position()
	selected_tower.select()

func _unselect_tower() -> void:
	if selected_tower:
		selected_tower.unselect()
	selected_tower = null

func play_wave_request() -> void:
	if main.game_state == main.GameState.BUILDING:
		wave_manager.play_next_wave()
	if main.game_state == main.GameState.PAUSED:
		main.game_state = main.GameState.ROUND
		get_tree().paused = false

func exit_menu() -> void:
	get_tree().paused = false
	tower_menu.hide_menu()
	is_in_menu = false

func _on_wave_button_pause_pressed() -> void:
	main.game_state = main.GameState.PAUSED
	get_tree().paused = true
