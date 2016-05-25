
extends Node2D

var map
var selected_node
var menu
var hud
var current_unit
var moving = false

var _unit_start_pos
var _unit_end_pos
var _moving_normal
var _elapsed_time

var units = {}
var selected_unit

var cam

func _ready():
	randomize()
	# map initialization
	map = get_node("map")
	cam = get_node("main_cam")
	
	# menu
	menu = get_node("gui/menu")
	print("map[width: ",map.width, ", height: ",map.height,"]")
	
	load_game_play("res://game.json")
		
func mouse_clicked(pos, char):
	if char:
		print("clicked on ",char.get_name()," at pos ",pos)
		selected_unit = char
	else:
		map.reset_overlay()
		if selected_unit && selected_unit.can_move(pos):
			selected_unit.move_to(pos)
	
	

func get_menu_pos(mouse_pos):
	var posx = mouse_pos.x
	var posy = mouse_pos.y
	if get_viewport_rect().size.width<(menu.get_item_rect().size.width+mouse_pos.x):
		posx = get_viewport_rect().size.width-menu.get_item_rect().size.width
	if get_viewport_rect().size.height<(menu.get_item_rect().size.height+mouse_pos.y):
		posy = get_viewport_rect().size.height-menu.get_item_rect().size.height
		
	return Vector2(posx,posy)
	
func load_game_play(file_name):
	# load the skull sample from scenes
	var sksc = load("res://scenes/skulla.scn")
	# for now we will generate random unit
	var uname = ["utol","cila","hello"]
	for unit in uname:
		var _skull = sksc.instance()
		_skull.direction = randi()%4
		_skull.action = randi()%6
		_skull.speed = 2
		var m_pos = Vector2(randi()%map.width,randi()%map.height)
		while units.has(m_pos):
			m_pos = Vector2(randi()%map.width,randi()%map.height)
			
		var g_pos = get_map_pixel_pos(m_pos)
		_skull.map_pos = m_pos
		_skull.set_pos(g_pos)
		_skull.set_name(unit)
		_skull.set_z(1) # layer 1 is for sku
		print("adding ",unit," at pos: ",m_pos)
		map.yorder.add_child(_skull)
		units[m_pos] = _skull

# return the pixel position of the map hex position having y axis offset
func get_map_pixel_pos(map_pos):
	var gp = map.yorder.get_node(str("tile_",map_pos.x,"_",map_pos.y)).get_pos()
	var pos = Vector2(gp.x,gp.y)
	return pos
		
func get_map_pos(mouse_pos):
	# Calculate the hex area
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
	# update the selected node
	if (x >= 0 && x < map.width && y >=0 && y < map.height):
		var node = map.yorder.get_node(str("tile_",x,"_",y))
		if node != selected_node:
			if selected_node:
				selected_node.smask.enabled = false
			selected_node = node
		if !node.smask.enabled:
			node.smask.enabled = true
		else:
			node.smask.enabled = false
			
	else:
		if selected_node:
			selected_node.smask.enabled = false
		selected_node = null
	return Vector2(x,y)
