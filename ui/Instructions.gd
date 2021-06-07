extends Control

func _on_Button_pressed():
	Client.start_new_game(int($NinePatchPanel/Seed.value),
	$NinePatchPanel/PlayerName.text)
	queue_free()


func _on_Seed_value_changed(value):
	$NinePatchPanel/SeedValue.text = str($NinePatchPanel/Seed.value)
