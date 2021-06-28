extends Control

func _on_NewGame_pressed():
	queue_free()
	get_tree().get_root().add_child(
		preload("res://ui/Instructions.tscn").instance()
	)
	
func _on_LoadGame_pressed():
	queue_free()
	get_tree().get_root().add_child(
		preload("res://ui/LoadGameMenu.tscn").instance()
	)

func _on_Quit_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	$Credits.show()
