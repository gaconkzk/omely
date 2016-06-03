# this script for preloading, and initialize all necessary scripts
var root

var controllers = preload("res://scripts/controllers/controllers.gd").new()

var camera = preload("res://scripts/camera.gd").new()

var processing = preload("res://scripts/processing.gd").new()

func init_root(root_node):
	self.root = root_node
	
	self.camera._init_bag(self)
	
	self.processing._init_bag(self)
	self.processing.ready = true
	self.processing.register(self.camera)