class_name UpgradeDisplay
extends Button

var upgrade: Upgrade

const ITEM_COST = preload("res://Scenes/Towers/UI/item_cost.tscn")

@onready var name_label: Label = $Name
@onready var cost: HBoxContainer = $Cost

@export var is_shop: bool = false

func clear_previous() -> void:
	name_label.text = ""
	for i in cost.get_children():
		i.queue_free()

func load_upgrade(_upgrade: Upgrade) -> void:
	clear_previous()
	upgrade = _upgrade
	name_label.text = upgrade.name
	
	for item: Item in upgrade.cost.keys():
		var item_cost: Control = ITEM_COST.instantiate()
		cost.add_child(item_cost)
		
		item_cost.get_child(0).text = str(upgrade.cost[item])
		item_cost.get_child(1).texture = item.texture

func animate_shop_upgrade() -> void:
	scale = Vector2(0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK)

func animate_shop_remove() -> void:
	scale = Vector2(1.0, 1.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.5).set_trans(Tween.TRANS_BACK)

func _on_mouse_entered() -> void:
	Game.get_tower_menu().show_description(upgrade)
	if is_shop:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0.2, 0.2), 0.3).set_trans(Tween.TRANS_BACK).as_relative()
		await tween.finished
		scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	Game.get_tower_menu().hide_description()
	if is_shop:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(-0.2, -0.2), 0.3).set_trans(Tween.TRANS_BACK).as_relative()
		await tween.finished
		scale = Vector2(1.0, 1.0)

func _on_pressed() -> void:
	if upgrade and is_shop:
		if Game.get_main().can_buy(upgrade.cost):
			Game.get_main().buy_upgrade(upgrade)
			Game.get_tower_menu().choose_upgrade(self)
