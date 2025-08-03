class_name WaveManager
extends Node

var current_wave_index: int = 0
@onready var main: Main
@onready var wave_label: Label = %WaveLabel
@onready var selection_handler: SelectionHandler = $"../SelectionHandler"

func _ready() -> void:
	main = Game.get_main()

func play_next_wave() -> void:
	Game.start_wave.play()
	main.game_state = main.GameState.ROUND
	if get_child_count() == current_wave_index:
		selection_handler.win_animation()
		return
	
	var wave: Wave = get_child(current_wave_index)
	await wave.start_wave()
	
	main.finish_wave()
	current_wave_index += 1
	wave_label.text = "Wave: " + str(current_wave_index + 1)
