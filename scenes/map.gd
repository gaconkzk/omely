
extends Node2D

var map
var selected_rect
var selected_node

func _ready():
	set_process_input(true)
	map = get_node("map")
	selected_rect = Rect2(64,0,64,32)
	print("width: ",map.width)
	print("height: ",map.height)
	
func _input(event):
	if event.is_action_released("left_mouse"):
		print("clicked on: ", get_global_mouse_pos() - map.get_global_pos())
		print("clicked on: ", get_map_pos(get_global_mouse_pos() - map.get_global_pos()))
		
func get_map_pos(mouse_pos):
	var row = int(mouse_pos.y/map.tile_height)
	var col
	
	var row_is_odd = false
	if row % 2 == 1:
		row_is_odd = true
	
	if row_is_odd:
		col = int((mouse_pos.x-map.tile_width_offset)/map.tile_width)
	else:
		col = int(mouse_pos.x/map.tile_width)
	
	var rel_y = mouse_pos.y - (row * map.tile_height)
	var rel_x
	
	if row_is_odd:
		rel_x = (mouse_pos.x - (col * map.tile_width)) - map.tile_width_offset
	else:
		rel_x = mouse_pos.x - (col * map.tile_width)
		
	var m = map.tile_height_offset/map.tile_width_offset
	if (rel_y < (-m * rel_x) + map.tile_height_offset):
		row -= 1
		if row_is_odd:
			col -= 1
	else:
		if (rel_y < (m * rel_x) - map.tile_height_offset):
			row -= 1
			if row_is_odd:
				col += 1
	
	var node = map.get_node(str("tile_",col,"_",row))
	if node != selected_node:
		if selected_node:
			selected_node.set_region_rect(Rect2(0,0,64,32))
		selected_node = node
	if selected_rect!=node.get_region_rect():
		node.set_region_rect(selected_rect)
	else:
		node.set_region_rect(Rect2(0,0,64,32))
	
	return Vector2(col,row)
