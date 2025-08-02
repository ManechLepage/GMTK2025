class_name Main
extends Node2D

@onready var resources: Control = %Resources
@onready var tower_menu: TowerMenu = %TowerMenu
@onready var camera_2d: CameraManager = %Camera2D
@onready var health_bar: TextureProgressBar = $CanvasLayer/Control/HealthBar

enum GameState {
	BUILDING,
	ROUND,
	PAUSED
}

var game_state: GameState

var core: int = 0
var gold: int = 0
var copper: int = 0
var steel: int = 0
var wood: int = 0

var health: int = 10

func _ready() -> void:
	update_copper()
	update_core()
	update_gold()
	update_steel()
	update_wood()
	
	game_state = GameState.BUILDING

func can_buy(cost: Dictionary[Item, int]) -> bool:
	for item: Item in cost.keys():
		if not has(item, cost[item]):
			return false
	return true

func finish_wave() -> void:
	game_state = GameState.BUILDING
	add_core(1)

func deal_player_damage() -> void:
	health -= 1
	health_bar.value = float(health)

func has(item: Item, value: int) -> bool:
	if item.name == "Core":
		return value <= core
	elif item.name == "Gold":
		return value <= gold
	elif item.name == "Copper":
		return value <= copper
	elif item.name == "Steel":
		return value <= steel
	return value <= wood

func buy_upgrade(upgrade: Upgrade) -> void:
	for item: Item in upgrade.cost.keys():
		Game.add_item(item, -1 * upgrade.cost[item])

func add_core(value: int) -> void:
	core += value
	update_core()

func add_gold(value: int) -> void:
	gold += value
	update_gold()

func add_copper(value: int) -> void:
	copper += value
	update_copper()

func add_steel(value: int) -> void:
	steel += value
	update_steel()

func add_wood(value: int) -> void:
	wood += value
	update_wood()

func update_core() -> void:
	resources.get_child(0).text = str(core)

func update_gold() -> void:
	resources.get_child(1).text = str(gold)

func update_copper() -> void:
	resources.get_child(2).text = str(copper)

func update_steel() -> void:
	resources.get_child(3).text = str(steel)

func update_wood() -> void:
	resources.get_child(4).text = str(wood)

func show_menu() -> void:
	tower_menu.show_menu(Game.get_input_handler().hovered_tower)
	get_tree().paused = true
