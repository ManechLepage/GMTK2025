class_name Wave
extends Node

func start_wave() -> void:
	for wave_group: WaveGroup in get_children():
		await wave_group.start_wave_group()
