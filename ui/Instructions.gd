extends Control

func _on_Button_pressed():
	Client.start_new_game()
	queue_free()
