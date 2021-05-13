extends Control

func _on_NewGame_pressed():
	queue_free()
	get_tree().get_root().add_child(
		preload("res://ui/Instructions.tscn").instance()
	)
	
func _on_LoadGame_pressed():
	# TODO: Show Available Games
	pass

func _on_Quit_pressed():
	get_tree().quit()
