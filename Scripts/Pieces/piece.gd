class_name Piece
extends Resource

@export var name: String
@export var texture: Texture2D

@export var drop: Dictionary[Item, Vector2i]
@export var health: int

func get_items_on_death() -> Array[Item]:
	var final_drop: Array[Item]
	for item: Item in drop.keys():
		for i in range(randi_range(drop[item].x, drop[item].y)):
			final_drop.append(item)
	return final_drop
