extends Node2D

func dat():
	return get_node("../").data

func _draw():
	#if Client.player_input.selected_system == get_node("../").system_id:
	#	draw_circle(Vector2(0,0), 9, Color(0,1,0))
	
	draw_circle(Vector2(0,0), 7, Data.biomes[dat().biome].map_color)
	draw_circle(Vector2(0,0), 5, Color(0,0,0))
	
	if Client.current_system_id() == get_node("../").system_id:
		draw_circle(Vector2(0,0), 3, Color(0,1,0))
