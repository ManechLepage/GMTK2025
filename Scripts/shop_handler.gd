extends Node2D

@export var core: Item
@export var copper: Item
@export var gold: Item
@export var steel: Item
@export var wood: Item

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

func _place_tower(tower_scene):
	var tower = tower_scene.instantiate()
	tower.position = get_global_mouse_position()
	tower.placed = false
	tower_parent.add_child(tower)
	selected_tower = tower

func _on_laser_buy_request() -> void:
	var cost: Dictionary[Item, int] = {
		core: 1,
		steel: 2
	}
	if Game.get_main().can_buy(cost) and Game.get_main().game_state == Game.get_main().GameState.BUILDING:
		_place_tower(laser_bot)

func _on_zapper_buy_request() -> void:
	var cost: Dictionary[Item, int] = {
		core: 1,
		wood: 3
	}
	if Game.get_main().can_buy(cost) and Game.get_main().game_state == Game.get_main().GameState.BUILDING:
		_place_tower(zapper_bot)

func _on_freeze_buy_request() -> void:
	var cost: Dictionary[Item, int] = {
		core: 1,
		copper: 2
	}
	if Game.get_main().can_buy(cost) and Game.get_main().game_state == Game.get_main().GameState.BUILDING:
		_place_tower(zapper_bot)
