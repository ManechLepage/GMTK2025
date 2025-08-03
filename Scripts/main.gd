class_name Main
extends Node2D

@onready var resources: Control = %Resources
@onready var tower_menu: TowerMenu = %TowerMenu
@onready var camera_2d: CameraManager = %Camera2D
@onready var health_bar: TextureProgressBar = $CanvasLayer/Control/HealthBar
@onready var conveyor_belt: ConveyorBelt = $ConveyorBelt
@onready var animation: ColorRect = $Animation
@onready var control: Control = $CanvasLayer/Control
@onready var control_2: Control = $CanvasLayer/Control2
@onready var blur: ColorRect = %Blur
@onready var wave_manager: WaveManager = $WaveManager
@onready var selection_handler: SelectionHandler = $SelectionHandler

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
	await start_animation()
	
	update_copper()
	update_core()
	update_gold()
	update_steel()
	update_wood()
	
	game_state = GameState.BUILDING

func start_animation() -> void:
	control.visible = false
	control_2.visible = false
	
	var tween = create_tween()
	tween.tween_method(tween_animation, 1.0, -1.0, 1.5).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	var tween_2 = create_tween()
	control.modulate.a = 0.0
	control.visible = true
	tween_2.tween_property(control, "modulate:a", 1.0, 1.0).from(0.0).set_ease(Tween.EASE_OUT)
	await tween_2.finished
	
	get_tree().paused = true

func tween_animation(value: float) -> void:
	animation.material.set_shader_parameter("height", value)

func can_buy(cost: Dictionary[Item, int]) -> bool:
	for item: Item in cost.keys():
		if not has(item, cost[item]):
			return false
	return true

func death_animation() -> void:
	selection_handler.death_animation()
	get_tree().paused = true


func finish_wave() -> void:
	game_state = GameState.BUILDING
	add_core(1)

func deal_player_damage() -> void:
	health -= 1
	health_bar.value = float(health)
	if health < 1:
		death_animation()

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
	Game.buy.play()
	apply_cost(upgrade.cost)

func apply_cost(cost: Dictionary[Item, int]) -> void:
	for item: Item in cost.keys():
		Game.add_item(item, -1 * cost[item])

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
