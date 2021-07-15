extends Node2D

func on():
	for particle_emitter in get_children():
		particle_emitter.emitting = true
		particle_emitter.get_node("Light2D").show()

func off():
	for particle_emitter in get_children():
		particle_emitter.emitting = false
		particle_emitter.get_node("Light2D").hide()
