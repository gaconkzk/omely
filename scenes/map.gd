
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
	var col = int(mouse_pos.x/map.tile_width)
	var row = int(mouse_pos.y/(map.tile_height-map.tile_height_offset))
	
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
