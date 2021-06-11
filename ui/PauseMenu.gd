extends Control

func _on_ResumeButton_pressed():
	get_tree().paused = false
	hide()

func _on_OptionsButton2_pressed():
	pass # Replace with function body.

func _on_SaveButton_pressed():
	Client.save_game()

func _on_QuitButton_pressed():
	get_tree().paused = false
	var main_menu = load("res://ui/MainMenu.tscn")
	get_tree().get_root().get_node("Game").queue_free()
	get_tree().get_root().add_child(main_menu.instance())
