
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
		get_map_pos(get_global_mouse_pos() - map.get_global_pos())
		
func get_map_pos(mouse_pos):
	var slope = map.tile_height_offset/float(map.tile_width_offset)
	var x = int(floor(mouse_pos.x/map.tile_width))
	var y = int(floor(mouse_pos.y/map.tile_row_height))
	var offset = Vector2(mouse_pos.x - x*map.tile_width, mouse_pos.y - y*map.tile_row_height)
	if y % 2 == 0:
		if (offset.y < (-slope * offset.x + map.tile_height_offset)):
			x -= 1
			y -= 1
		elif (offset.y < (slope * offset.x - map.tile_height_offset)):
			y -= 1
	else:
		if (offset.x >= map.tile_width_offset):
			if (offset.y < (-slope * offset.x + map.tile_height_offset * 2)):
				y -= 1
		else:
			if (offset.y < (slope * offset.x)):
				y -= 1
			else:
				x -= 1
	
	if (x >= 0 && x < map.width && y >=0 && y < map.height):
		var node = map.get_node(str("tile_",x,"_",y))
		if node != selected_node:
			if selected_node:
				selected_node.set_region_rect(Rect2(0,0,64,32))
			selected_node = node
		if selected_rect!=node.get_region_rect():
			node.set_region_rect(selected_rect)
		else:
			node.set_region_rect(Rect2(0,0,64,32))
	
	return Vector2(x,y)
