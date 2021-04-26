extends TextureRect

const SPEED = 100
const DIRECTION = Vector2(0,1)

var position = Vector2()

func _physics_process(delta):
	position += SPEED * DIRECTION * delta
	get_material().set_shader_param("position", position)
