extends Control

@export var descriptions: Array[String] = []
@export var previews: Array[Texture2D] = []

@onready var description = $DescriptionBox/Description
@onready var preview = $Preview/Image

var tutorial_index := 0

func _ready() -> void:
	_update_tutorial_panel()

func _process(_delta) -> void:
	if Input.is_action_just_pressed("TutorialNext"):
		tutorial_index += 1
	if Input.is_action_just_pressed("TutorialBack"):
		tutorial_index -= 1
	
	tutorial_index = _cap_index(tutorial_index)
	
	_update_tutorial_panel()

func _update_tutorial_panel():
	if descriptions.size() > tutorial_index:
		description.text = descriptions[tutorial_index]
	if previews.size() > tutorial_index:
		preview.texture = previews[tutorial_index]

func _cap_index(tutorial_index):
	var max_index = max(descriptions.size(), previews.size()) - 1
	return max(min(tutorial_index, max_index), 0)
	
