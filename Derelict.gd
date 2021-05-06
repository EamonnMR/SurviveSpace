extends KinematicBody2D

func _ready():
	Client.add_radar_pip(self)

func can_interact():
	return true
