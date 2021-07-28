extends VBoxContainer

func _physics_process(delta):
	# TODO: Some kind of binding action to avoid so much updating
	$Health/Health.max_value = Client.player.get_node("Health").max_health
	$Health/Health.value = Client.player.get_node("Health").health
	$Air/Air.max_value = Client.player.max_air
	$Air/Air.value = Client.player.air
	if Client.player.get_node("Health").max_shields:
		$Shield.show()
		$Shield/Shield.max_value = Client.player.get_node("Health").max_shields
		$Shield/Shield.value = Client.player.get_node("Health").shields
	else:
		$Shield.hide()
	$Energy/Energy.max_value = Client.player.max_energy
	$Energy/Energy.value = Client.player.energy
