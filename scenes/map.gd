
extends Node2D

var map

func _ready():
	set_process_input(true)
	map = get_node("map")
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
	node.set_region(true)
	node.set_region_rect(Rect2(64,0,64,32))
	
	return Vector2(col,row)
