
extends Node2D

var map
var selected_node
var menu
var hud
var current_unit
var moving = false

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
		get_map_pos(get_global_mouse_pos() - map.get_global_pos())
		# clear old selected
		map.reset_selected()
		if selected_node && selected_node.get_child_count()>0:
			# for i in range(selected_node.get_child_count()):
				current_unit = selected_node.get_child(0)
				print("clicked on ",current_unit.get_name())
				# display the menu
				# menu.set_pos(get_menu_pos(get_global_mouse_pos()))
				# menu.popup()
				# update selected nodes
				map.change_selected(current_unit.get_map_pos(),current_unit.get_movement_range())
		else:
			# menu.set_hidden(true)
			# move if selected?
			if selected_node && current_unit!=null:
				moving = true

func _process(delta):
	var direction = Vector2(-1,0)
	
	if (moving):
		current_unit.set_pos(current_unit.get_pos()+ direction * current_unit.speed * delta)
		
			
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
	var units = ["utol","cila","hello"]
	for unit in units:
		var _skull = sksc.instance()
		_skull.direction = randi()%4
		_skull.action = randi()%6
		_skull.speed = 25
		var skw = _skull.get_node("skulla").get_item_rect().size.width
		var del = skw-map.tile_height
		var m_pos = Vector2(randi()%map.width,randi()%map.height)
		
		while (map.yorder.get_node(str("tile_",m_pos.x,"_",m_pos.y)).get_child_count() != 0):
			m_pos = Vector2(randi()%map.width,randi()%map.height)
		
		var g_pos = get_map_pixel_pos(m_pos,del)
		_skull.set_map_pos(m_pos)
		_skull.set_pos(g_pos)
		_skull.set_name(unit)
		print("adding ",unit," at pos: ",m_pos)
		map.yorder.get_node(str("tile_",m_pos.x,"_",m_pos.y)).add_child(_skull)

func get_unit_at_pos(uname, m_pos):
	return map.get_node(str("tile_",m_pos.x,"_",m_pos.y)).get_node(uname)

func get_map_pixel_pos(map_pos,del):
	var pos = Vector2(0,-del-map.tile_height_offset)
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
				selected_node.set_frame(0)
			selected_node = node
		if 1!=node.get_frame():
			node.set_frame(1)
		else:
			node.set_frame(0)
			
	else:
		if selected_node:
			selected_node.set_frame(0)
		selected_node = null
	return Vector2(x,y)
