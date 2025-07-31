extends Path2D

const FOLLOW_CONVEYOR = preload("res://Scenes/Conveyor/follow_conveyor.tscn")

func _ready() -> void:
	var length = curve.get_baked_length()
	for i in range(58):
		var conveyor: PathFollow2D = FOLLOW_CONVEYOR.instantiate()
		conveyor.progress = i * 8
		add_child(conveyor)

func _process(delta: float) -> void:
	for follow: PathFollow2D in get_children():
		follow.progress -= 50.0 * delta
