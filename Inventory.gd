extends Node

var items = {}

func add(type: String, count: int):
	if type in items:
		items[type] += count
	else:
		items[type] = count
	print(items)
