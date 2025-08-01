class_name TowerMenu
extends Panel

@onready var blur: ColorRect = %Blur

@export var hidden_pos: Vector2
@export var shown_pos: Vector2

@onready var description: Panel = $Description
@onready var description_label: Label = $Description/Label
@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var grid_container: GridContainer = %GridContainer

var current_tower: Tower

func _ready() -> void:
	position = hidden_pos

func show_menu(_tower: Tower) -> void:
	current_tower = _tower
	var tween = create_tween()
	position = hidden_pos
	tween.tween_property(self, "position", shown_pos, 0.5).set_trans(Tween.TRANS_BACK)
	await tween.finished
	blur.visible = true
	
	for i in h_box_container.get_children():
		i.clear_previous()
	
	load_upgrades()
	display_tower_upgrades()

func load_upgrades() -> void:
	for i in range(current_tower.current_shop.size()):
		h_box_container.get_child(i).load_upgrade(current_tower.current_shop[i])
		h_box_container.get_child(i).animate_shop_upgrade()

func display_tower_upgrades() -> void:
	for i in grid_container.get_children():
		i.visible = false
	for i in range(current_tower.current_upgrades.size()):
		grid_container.get_child(i).visible = true
		grid_container.get_child(i).load_upgrade(current_tower.current_upgrades[i])

func hide_menu() -> void:
	var tween = create_tween()
	blur.visible = false
	position = shown_pos
	tween.tween_property(self, "position", hidden_pos, 0.5).set_trans(Tween.TRANS_BACK)
	await tween.finished

func show_description(upgrade: Upgrade) -> void:
	if upgrade:
		description.visible = true
		description_label.text = upgrade.description

func hide_description() -> void:
	description.visible = false

func choose_upgrade(upgrade: UpgradeDisplay) -> void:
	current_tower.current_upgrades.append(upgrade.upgrade)
	current_tower.update_stats()
	current_tower.apply_upgrade(upgrade.upgrade)
	
	display_tower_upgrades()
	
	if not upgrade.upgrade.stays_in_pool:
		current_tower.upgrade_pool.erase(upgrade.upgrade)
	
	for i in h_box_container.get_children():
		i.clear_previous()
	
	current_tower.load_new_shop()
	load_upgrades()
