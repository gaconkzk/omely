# this script for preloading, and initialize all necessary scripts
var root

var controllers = preload("res://scripts/controllers/controllers.gd").new()

var camera = preload("res://scripts/camera.gd").new()

var map_tiles = preload("res://scripts/maps/map_tiles.gd").new()
var processing = preload("res://scripts/processing.gd").new()
var file_handler = preload('res://scripts/services/file_handler.gd').new()

var saving = null
var workshop = null

func init_root(root_node):
	self.root = root_node
	
	if Globals.get('ome/enable_workshop'):
        # self.controllers.workshop_gui_controller = preload("res://scripts/controllers/workshop_gui_controller.gd").new()
        self.workshop = preload("res://gui/workshop/workshop.tscn").instance()
        # self.controllers.workshop_gui_controller.init_root(root_node)
        self.workshop.init_root(self.root)
	
	self.camera._init_bag(self)
	
	self.processing._init_bag(self)
	self.processing.ready = true
	self.processing.register(self.camera)