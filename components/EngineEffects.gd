extends Node2D

func on():
	for particle_emitter in get_children():
		particle_emitter.emitting = true

func off():
	for particle_emitter in get_children():
		particle_emitter.emitting = false
