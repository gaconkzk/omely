extends Control

var version_detail = "Version 0.0.1-ALPHA"
var version = "0.0.1"

# TODO a selector - for selecting objects in game

var scale_root # we will load the current map into this node

var camera
var menu

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

var is_map_loaded = false
var is_intro = true
var is_paused = false

const SETTINGS_PATH = "user://settings.ome"

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

func load_menu():
	menu.show()
	is_intro = false
	self.add_child(menu)
	menu.manage_close_button()
	
func unload_map():
	if is_map_loaded == false:
		return

func toggle_menu(target = 'menu'):
    if is_map_loaded:
        if menu.is_hidden():
            is_paused = true
            # action_controller.stats_set_time()
            menu.show()
            if target == 'menu':
                self.menu.show_main_menu(true)
            if target == 'settings':
                self.menu.show_settings(true)
            # hud.hide()
            menu.close_button.grab_focus()
        else:
            is_paused = false
            # action_controller.stats_start_time()
            menu.hide()
            # hud.show()
            # if hud_controller.hud_message_card_visible:
            #    hud_controller.hud_message_card_button.grab_focus()
            # if action_controller.game_ended:
            #    hud_controller.hud_end_game_missions_button.grab_focus()

func _ready():
	self.scale_root = get_node("/root/game/viewport/pixel_scale")
	self.ai_timer = get_node("/root/game/AITimer")
	self.read_settings_from_file()
	self.bag.init_root(self)
	self.camera = self.bag.camera
	self.menu = self.bag.controllers.menu_controller
	
	menu.init_root(self)
	# menu.hide()
	self.load_menu() # no intro - show menu directly
	
	