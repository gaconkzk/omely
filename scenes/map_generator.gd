
extends Node2D

export(int) var width = 20
export(int) var height = 10
var tile_width = 64
var tile_height = 32
var tile_width_offset = 32
var tile_height_offset = 8
var tile_row_height = 24
var cam
var dragging = false
var initPosMouse
var initPosCam
var initPosNode
var yorder
var selecting_nodes=[]

func _ready():
	# allow custom input
	set_process_input(true)
	# allow custom process
	set_process(true)
	
	# cam
	cam = get_parent().get_node("main_cam")
	var scene = load("res://scenes/terrain.scn")
	var ter = scene.instance()
	var tile = ter.get_node("hex_blank")
	yorder = get_node("yorder")
	# loop through width and height
	for i in range(width):
		for j in range(height):
			var s = tile.duplicate(true)
			s.set_name(str("tile_",i,"_",j))
			var pos = Vector2(i*tile_width, j*tile_height)
			
			if j % 2 == 1:
				pos.x+=tile_width_offset
			pos.y-=j*tile_height_offset
			
			s.set_pos(pos)
			yorder.add_child(s)

func _input(event):
	if (event.is_action_pressed("right_mouse")):
		dragging = true
		initPosCam = cam.get_global_pos()
		initPosMouse = get_global_mouse_pos()
		initPosNode = get_global_pos()
	if (event.is_action_released("right_mouse")):
		dragging = false

func _process(delta):
	if dragging:
		var mpos = get_global_mouse_pos()
		# how far our mouse moved since drag
		var dist_x = initPosMouse.x - mpos.x
		var dist_y = initPosMouse.y - mpos.y
		# offset between the mouse movement and camera position
		var mx = initPosCam.x - (0 - dist_x)
		var my = initPosCam.y - (0 - dist_y)
		# now we should move the map
		var nx = initPosNode.x - (0 + dist_x)
		var ny = initPosNode.y - (0 + dist_y)
		# update the map pos
		# set_pos(Vector2(nx,ny))
		cam.set_pos(Vector2(mx,my))
func reset_selected():
	for tile in selecting_nodes:
		tile.get_node("select_mask").enabled = false
	
	selecting_nodes = []

func change_selected(unit):
	var center = unit.map_pos
	var selected_pos = unit.get_range()
	for tile in selected_pos:
		if ((center.x+tile.x >= 0) && (center.y+tile.y >=0) && 
			(center.x+tile.x<width) && (center.y+tile.y)<height):
			# seem the algo is invalid when both center and tile is odd
			var e = (int(center.y)&1) * (int(tile.y)&1)
			var n = yorder.get_node(str("tile_",center.x+tile.x+e,"_",center.y+tile.y))
			if n:
				n.get_node("select_mask").enabled = true
				selecting_nodes.append(n)