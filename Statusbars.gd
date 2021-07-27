extends VBoxContainer

func _physics_process(delta):
	$Health/Health.max_value = Client.player.get_node("Health").max_health
	$Health/Health.value = Client.player.get_node("Health").health
