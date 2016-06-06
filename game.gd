extends Control

var version_detail = "Version 0.0.1-ALPHA"
var version = "0.0.1"

# TODO a selector - for selecting objects in game

var scale_root # we will load the current map into this node

var camera

var ai_timer

var bag = preload("res://scripts/services/dependency_container.gd").new()

var settings = {
    'is_ok' : true,
    'sound_enabled' : true,
    'music_enabled' : true,
    'shake_enabled' : true,
    'cpu_0' : false,
    'cpu_1' : true,
    'turns_cap': 0,
    'camera_follow': true,
    'music_volume': 0.5,
    'sound_volume': 0.2,
    'camera_zoom': 2,
    'resolution': 0,
    'easy_mode' : false,
    'online_player_id' : null,
    'online_player_pin' : null
}

const SETTINGS_PATH = "user://settings.tof"

func read_settings_from_file():
	var data
	data = self.bag.file_handler.read(self.SETTINGS_PATH)
	if data.empty():
		self.bag.file_handler.write(self.SETTINGS_PATH, self.settings)
	else:
		for option in data:
			self.settings[option] = data[option]

func write_settings_to_file():
    self.bag.file_handler.write(self.SETTINGS_PATH, self.settings)

func _ready():
	self.scale_root = get_node("/root/game/viewport/pixel_scale")
	self.ai_timer = get_node("/root/game/AITimer")
	self.read_settings_from_file()
	self.bag.init_root(self)
	self.camera = self.bag.camera