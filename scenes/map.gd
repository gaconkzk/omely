
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

var units = []


func _ready():
	set_process(true)
	set_process_input(true)
	randomize()
	# map initialization
	map = get_node("map")
	
	# menu
	menu = get_node("gui/menu")
	print("map[width: ",map.width, ", height: ",map.height,"]")
	
	load_game_play("res://game.json")
	
func _input(event):
	if event.is_action_released("left_mouse"):
		var map_pos = get_map_pos(get_global_mouse_pos() - map.get_global_pos())
		# clear old selected
		map.reset_selected()
		# if no unit moving, and we selected a tile
		# go process
		if !moving && selected_node && units.size()>0:
			var sl_unit = null
			# loop through units and find the one we select
			for unit in units:
				if unit.map_pos==map_pos:
					current_unit = unit
					sl_unit = unit
					print("clicked on ",current_unit.get_name())
					# display the menu
					# menu.set_pos(get_menu_pos(get_global_mouse_pos()))
					# menu.popup()
					# update selected nodes
					map.change_selected(current_unit)
					break
			if sl_unit == null && current_unit != null:
				# menu.set_hidden(true)
				# move if selected?
				if selected_node:
					print("now move move")
					moving = true
					_unit_start_pos = current_unit.get_pos()
					var skw = current_unit.get_item_rect().size.height
					var del = skw-map.tile_height
					_unit_end_pos = get_map_pixel_pos(map_pos, -del)
					current_unit.map_pos = map_pos
					_moving_normal = (_unit_end_pos - _unit_start_pos).normalized()
					_elapsed_time = _unit_end_pos.distance_to(_unit_start_pos)/current_unit.speed # total time for walk based on speed
					current_unit.action = 2 # walk
					current_unit.direction = calculate_direction(_unit_start_pos,_unit_end_pos)
					current_unit.loop = true

func calculate_direction(start,end):
	var dx = (end.x - start.x)/map.tile_width
	var dy = (end.y - start.y)/map.tile_row_height
	
	# get the main - up/down or left/right
	if abs(dx) > abs (dy):
		if dx > 0: return 3
		else: return 1
	else:
		if dy > 0: return 2
		else: return 0

func _process(delta):
	# todo: char moving should be put inside char script
	if (moving):
		_elapsed_time -= delta
		current_unit.translate(_moving_normal*current_unit.speed*delta)
		if (_elapsed_time<=0):
			moving = false
			current_unit.set_pos(_unit_end_pos)
			current_unit.loop = false
		
			
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
		_skull.speed = 40
		var skw = _skull.get_item_rect().size.height
		var del = skw-map.tile_height
		var m_pos = Vector2(randi()%map.width,randi()%map.height)
		while is_pos_used(m_pos):
			m_pos = Vector2(randi()%map.width,randi()%map.height)
			
		var g_pos = get_map_pixel_pos(m_pos,-del)
		_skull.map_pos = m_pos
		_skull.set_pos(g_pos)
		_skull.set_name(unit)
		_skull.set_z(1) # layer 1 is for sku
		print("adding ",unit," at pos: ",m_pos)
		map.yorder.add_child(_skull)
		units.append(_skull)

# return the pixel position of the map hex position having y axis offset
func get_map_pixel_pos(map_pos,yoffset):
	var gp = map.yorder.get_node(str("tile_",map_pos.x,"_",map_pos.y)).get_pos()
	var pos = Vector2(gp.x,gp.y+yoffset-map.tile_height_offset)
	return pos

func is_pos_used(map_pos):
	for unit in units:
		return unit.map_pos == map_pos
	return false
		
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
