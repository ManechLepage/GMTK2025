class_name WaveManager
extends Node

var current_wave_index: int = 0
@onready var main: Main = $".."
@onready var wave_label: Label = %WaveLabel

func play_next_wave() -> void:
	main.game_state = main.GameState.ROUND
	if get_child_count() == current_wave_index + 1:
		pass # finish level
	
	var wave: Wave = get_child(current_wave_index)
	await wave.start_wave()
	
	main.finish_wave()
	current_wave_index += 1
	wave_label.text = "Wave: " + str(current_wave_index + 1)
