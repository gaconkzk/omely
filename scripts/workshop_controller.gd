
extends Control

var root
var bag
var is_working = false
var is_suspended = true

var selector = preload('res://gui/selector.tscn').instance()
var selector_position = Vector2(0,0)
var map_pos

var terrain
var units
var tileset

func _ready():
	init_gui()

func init_gui():
	pass

func init_root(root):
	self.root = root
	self.bag = root.bag
	self.tileset = self.root.bag.map_tiles
	
func _input(event):
	pass