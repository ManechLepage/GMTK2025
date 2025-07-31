class_name WaveManager
extends Node

var current_wave_index: int = 0

func play_next_wave() -> void:
	if get_child_count() == current_wave_index + 1:
		pass # finish level
	
	var wave: Wave = get_child(current_wave_index)
	await wave.start_wave()
