
extends Node2D

var width=100
var height=30
var tile_width = 64
var tile_height = 32
var tile_width_offset = 32
var tile_height_offset = 8

func _ready():
	
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


