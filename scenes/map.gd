
extends Node2D

var map
var selected_rect
var selected_node

func _ready():
	set_process_input(true)
	randomize()
	map = get_node("map")
	selected_rect = Rect2(64,0,64,32)
	print("map[width: ",map.width, ", height: ",map.height,"]")
	load_game_play("res://game.json")
	
func _input(event):
	if event.is_action_released("left_mouse"):
		get_map_pos(get_global_mouse_pos() - map.get_global_pos())
		
func load_game_play(file_name):
	#
	var sksc = load("res://scenes/skulla.scn")
	# for now we will generate 
	var units = ["utol","cila","hello"]
	for unit in units:
		var _skull = sksc.instance()
		_skull.direction = 2
		_skull.action = 1
		var skw = _skull.get_node("skulla").get_item_rect().size.width
		var del = skw-map.tile_height
		var m_pos = Vector2(randi()%map.width,randi()%map.height)
		var g_pos = get_map_pixel_pos(m_pos,del)
		_skull.set_pos(g_pos)
		_skull.set_z(m_pos.y+1) # bigger should be draw above the lower
		_skull.set_name(unit)
		print("adding ",unit," at pos: ",m_pos)
		map.add_child(_skull)

func get_map_pixel_pos(map_pos,del):
	var pos = Vector2(map_pos.x*map.tile_width, map_pos.y*map.tile_height)
	if int(map_pos.y) % 2:
		pos.x+=map.tile_width_offset
	pos.y-=map_pos.y*map.tile_height_offset
		
	# the pos should have delta because height different
	pos.y-=del
	pos.y-=map.tile_height_offset
	
	return pos
		
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
