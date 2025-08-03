extends Control

@export var descriptions: Array[String] = []
@export var previews: Array[Texture2D] = []
@export var lore: Array[String] = []

@onready var description = $DescriptionBox/Description
@onready var preview = $Preview/Image
@onready var progress_text = $DescriptionBox/Progress

var tutorial_index := 0
var lore_index := 0

var in_lore := true

func _ready() -> void:
	_update_tutorial_panel()

func _process(_delta) -> void:
	if Input.is_action_just_pressed("TutorialNext"):
		if not in_lore:
			tutorial_index += 1
			if tutorial_index == _get_max_index() + 1:
				_remove_tutorial()
				return
		else:
			lore_index += 1
			if lore_index > lore.size() - 1:
				in_lore = false
	
	if Input.is_action_just_pressed("TutorialBack"):
		if not in_lore:
			tutorial_index -= 1
		else:
			lore_index -= 1
			lore_index = max(lore_index, 0)
	
	if not in_lore:
		tutorial_index = _cap_index(tutorial_index)
	
	_update_progress_text()
	_update_tutorial_panel()

func _remove_tutorial():
	Game.did_tutorial = true
	get_tree().paused = false
	Game.get_main().blur.visible = false
	queue_free()

func _update_tutorial_panel():
	if not in_lore:
		if descriptions.size() > tutorial_index:
			description.text = descriptions[tutorial_index]
		if previews.size() > tutorial_index:
			preview.texture = previews[tutorial_index]
	
	else:
		description.text = lore[lore_index]

func _get_max_index():
	return max(descriptions.size(), previews.size()) - 1

func _update_progress_text():
	if not in_lore:
		var max_index = _get_max_index()
		progress_text.text = str(tutorial_index + 1) + "/" + str(max_index + 1)
	else:
		progress_text.text = ""

func _cap_index(tutorial_index):
	var max_index = _get_max_index()
	return max(min(tutorial_index, max_index), 0)
