extends TextureRect
func _physics_process(delta):
	get_material().set_shader_param("position", Client.player.position)

