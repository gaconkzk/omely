
extends Node2D

const CubeUtils = preload("res://cube.gd")

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
var overlay_nodes=[]
var _g_m_pos # hacking html5 can't recognize mouse

func _ready():
	# allow custom input
	set_process_input(true)
	# allow custom process
	set_process(true)
	
	# cam
	cam = get_parent().get_node("main_cam")
	yorder = get_node("yorder")
	# loop through width and height
	for i in range(width):
		for j in range(height):
			var s = load("res://tile.tscn").instance()
			s.set_name(str("tile_",i,"_",j))
			var map_pos = Vector2(i,j)
			var pos = Vector2(i*tile_width, j*tile_height)
			
			if j % 2 == 1:
				pos.x+=tile_width_offset
			pos.y-=j*tile_height_offset
			s.position = pos
			
			#signal handler
			s.connect("mouse_clicked",get_parent(),"mouse_clicked")
			yorder.add_child(s)

func _input(event):
	if (event.is_action_pressed("left_mouse")):
		reset_selected()
	if (event.is_action_pressed("right_mouse")):
		dragging = true
		initPosCam = cam.get_global_pos()
		initPosMouse = event.global_pos
		initPosNode = get_global_pos()
	if (event.is_action_released("right_mouse")):
		dragging = false
	
	if (dragging && event.type == InputEvent.MOUSE_MOTION && event.global_pos!=null):
		_g_m_pos = event.global_pos
	else:
		_g_m_pos = null

func _process(delta):
	if dragging && _g_m_pos!=null && initPosMouse!=null:
		# how far our mouse moved since drag
		var dist_x = initPosMouse.x - _g_m_pos.x
		var dist_y = initPosMouse.y - _g_m_pos.y
		# offset between the mouse movement and camera position
		var mx = initPosCam.x - (0 - dist_x)
		var my = initPosCam.y - (0 - dist_y)
		# update the cam pos
		cam.set_pos(Vector2(mx,my))
		
func reset_selected():
	for tile in selecting_nodes:
		tile.smask.enabled = false
	
	selecting_nodes = []
	
func reset_overlay():
	for tile in overlay_nodes:
		tile.omask.enabled = false
	overlay_nodes = []

#get all tiles in unit move range
func select_range(unit):
	var selected_pos = CubeUtils.range_oddr(unit.map_pos, unit.move_range)
	for tile in selected_pos:
		var col = tile.x
		var row = tile.y
		if (col>=0&&col<width&&row>=0&&row<height):
			var n = yorder.get_node(str("tile_",col,"_",row))
			if n!=null:
				n.smask.enabled = true
				selecting_nodes.append(n)
				
func show_path(path):
	reset_overlay()
	for tile in path:
		if (tile.x>=0&&tile.x<width&&tile.y>=0&&tile.y<height):
			var n_name = str("tile_",tile.x,"_",tile.y)
			if yorder.has_node(n_name):
				var n = yorder.get_node(n_name)
				n.omask.enabled = true
				overlay_nodes.append(n)
# the cost when go from pos1 to pos2
func gcost(pos1,pos2):
	return 1

func clear_selected():
	if has_node("yorder/_selected"):
		var old = get_node("yorder/_selected")
		old.smask.enabled = false
		old.set_name(str("tile_",old.map_pos.x,"_",old.map_pos.y))