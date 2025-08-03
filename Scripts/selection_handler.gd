class_name SelectionHandler
extends Node

var selected_tower: Tower
var hovered_tower: Tower

var tower_offset = null
var can_drag_tower: bool = false

var is_in_menu: bool

const MAIN_MENU = preload("res://Scenes/main_menu.tscn")

@onready var control_2: Control = $"../CanvasLayer/Control2"
@onready var blur: ColorRect = %Blur
@onready var control: Control = $"../CanvasLayer/Control"

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

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU)

func death_animation() -> void:
	get_tree().paused = true
	Game.lose.play()
	
	var tween_2 = create_tween()
	control.visible = true
	tween_2.tween_property(control, "modulate:a", 0.0, 1.0).from(1.0).set_ease(Tween.EASE_OUT)
	await tween_2.finished
	
	control_2.visible = true
	control_2.scale = Vector2.ZERO
	control_2.get_child(0).text = "You lost at wave " + str(wave_manager.current_wave_index) + "!"
	var tween = create_tween()
	tween.tween_property(control_2, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	blur.visible = true

func win_animation() -> void:
	get_tree().paused = true
	Game.win.play()
	
	var tween_2 = create_tween()
	control.visible = true
	tween_2.tween_property(control, "modulate:a", 0.0, 1.0).from(1.0).set_ease(Tween.EASE_OUT)
	await tween_2.finished
	
	control_2.visible = true
	control_2.scale = Vector2.ZERO
	control_2.get_child(0).text = "You win!"
	var tween = create_tween()
	tween.tween_property(control_2, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	blur.visible = true

func _on_button_pressed() -> void:
	_on_restart_button_pressed()
