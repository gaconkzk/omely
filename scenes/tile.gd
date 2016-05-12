
extends Node2D

var width=100
var height=30
var tile_width = 64
var tile_height = 32
var tile_width_offset = 32
var tile_height_offset = 8
var cam
var dragging = false

func _ready():
	# allow custom input
	set_process_input(true)
	# allow custom process
	set_process(true)
	
	# cam
	cam = get_node("main_cam")
	var scene = load("res://scenes/terrain.scn")
	var ter = scene.instance()
	# loop through width and height
	for i in range(width):
		for j in range(height):
			var s = ter.duplicate(true)
			s.set_name(str("tile_",i,"_",j))
			var pos = Vector2(i*tile_width, j*tile_height)
			
			if j % 2 == 0:
				pos.x+=tile_width_offset
			pos.y-=j*tile_height_offset
			
			s.set_pos(pos)
			add_child(s)

func _input(event):
	if (event.is_action_pressed("mouse_drag")):
		dragging = true
	if (event.is_action_released("mouse_drag")):
		dragging = false

func _process(delta):
	if dragging:
		print("dragging - yo!!! move the stupid camera")