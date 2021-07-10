extends Node2D

func try_shooting():
	var children = get_children()
	if len(children):
		children[0].try_shooting()
