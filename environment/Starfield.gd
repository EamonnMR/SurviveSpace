extends TextureRect
func _physics_process(delta):
	get_material().set_shader_param("position", Client.player.position)

func set_background(tex: Texture):
	texture = tex

func _get_background(system_id):
	return Data.biomes[Procgen.systems[system_id].biome].background

func set_background_for_current_system():
	set_background(_get_background(Client.current_system))
