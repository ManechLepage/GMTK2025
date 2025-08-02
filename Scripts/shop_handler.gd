extends Node2D

var laser_bot: PackedScene = load("res://Scenes/Towers/TowerTypes/laser_bot.tscn")
var zapper_bot: PackedScene = load("res://Scenes/Towers/TowerTypes/zapper_bot.tscn")
var freeze_bot: PackedScene = load("res://Scenes/Towers/TowerTypes/freeze_bot.tscn")
var tower_parent

var selection_handler
var selected_tower: Tower = null
var conveyor

func _ready() -> void:
	selection_handler = $"../SelectionHandler"
	tower_parent = $"../Towers"
	conveyor = $"../ConveyorBelt"

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("PlaceTower") and not selected_tower:
		#var tower = base_tower.instantiate()
		#tower.position = get_global_mouse_position()
		#tower.placed = false
		#tower_parent.add_child(tower)
		#selected_tower = tower
		pass
	
	if Input.is_action_just_pressed("LeftClick") and selected_tower:
		selected_tower.placed = true
		# Find out if the tower is inside or outside the conveyor...
		var in_conveyor: bool = conveyor._position_in_conveyor(selected_tower.global_position)
		selected_tower.loop_interior = in_conveyor
		selection_handler._select_tower(selected_tower)
		selected_tower = null

func _process(_delta):
	if selected_tower:
		selected_tower.global_position = get_global_mouse_position()
