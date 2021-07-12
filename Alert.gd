extends Label

func alert(text: String):
	self.text = text
	$AudioStreamPlayer.play()
	$Timer.start()


func _on_Timer_timeout():
	text = ""
