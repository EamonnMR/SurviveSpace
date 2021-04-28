extends Area2D

var in_range = []
var top = null

	
func _distance_comparitor(lval, rval):
	# For sorting other nodes by how close they are
	var parent = get_node("../")
	var ldist = lval.position.distance_to(parent.position)
	var rdist = rval.position.distance_to(parent.position)
	return ldist < rdist

func _on_area_entered(area):
	if(area.has_method("selectable")):
		in_range.append(area)
		_update()

func _on_area_exited(area):
	_erase(area)
	_update()

func _on_body_entered(body):
	if(body.has_method("selectable")):
		in_range.append(body)
		_update()

func _on_body_exited(body):
	_erase(body)
	_update()

func _on_Timer_timeout():
	_update()

func _update():
	var old_top = top
	in_range.sort_custom(self, "distance_comparitor")
	for i in in_range:
		if is_instance_valid(i):
			top = i
			if top != old_top:
				_remove_marker(old_top)
				top.add_child(preload("res://ui/InteractionMarker.tscn").instance())

func _erase(entity):
	in_range.erase(entity)
	if entity == top:
		_remove_marker(entity)
		top = null

func _remove_marker(old_top):
	if is_instance_valid(old_top):
		old_top.remove_child(old_top.get_node("InteractionMarker"))
