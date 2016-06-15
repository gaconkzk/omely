var root
var control_nodes # all three big nodes of the menu

var close_button
var close_button_label
var quit_button

var workshop_button
var workshop

var root_tree

var background_gradient

func init_root(root_node):
	root = root_node
	self.root_tree = self.root.get_tree()
	
func _ready():
	self.control_nodes = [self.get_node("top"),self.get_node("middle"),self.get_node("bottom")]
	
	workshop_button = get_node("bottom/center/workshop")
	if !Globals.get('ome/enable_workshop'):
		workshop_button.hide()
	
	self.background_gradient = self.get_node('vigette/center/bg_mask')
	
	workshop_button.connect("pressed", self, "_workshop_button_pressed")
	
	close_button = get_node("top/center/close")
	quit_button = get_node("top/center/quit")
	
	close_button_label = close_button.get_node('Label')
	
	quit_button.connect("pressed", self, "_quit_button_pressed")
	
	self.load_workshop()

func _workshop_button_pressed():
    # self.root.sound_controller.play('menu')
    self.enter_workshop()

func _quit_button_pressed():
    # self.root.sound_controller.play('menu')
    self.quit_game()


# WORKSHOP TODO - create separate class for this
func load_workshop():
    self.workshop = self.root.bag.workshop

func enter_workshop():
	if Globals.get('ome/enable_workshop'):
		self.root.unload_map()
		self.workshop.is_working = true
		self.workshop.is_suspended = false
		self.show_workshop()

func show_workshop():
    if Globals.get('ome/enable_workshop'):
        self.hide()
        self.root.toggle_menu()
        self.workshop.show()
        # self.workshop.units.raise()
        # self.hide_background_map()
        # self.workshop.camera.make_current()
        # self.root.bag.controllers.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func hide_workshop():
    if Globals.get('ome/enable_workshop'):
        self.workshop.hide()
        self.workshop.camera.clear_current()
        self.root.bag.camera.camera.make_current()
        self.show()
        if not self.root.is_map_loaded:
            self.show_background_map()
        self.workshop_button.grab_focus()

func manage_close_button():
	if self.root.is_map_loaded:
		self.close_button.show()
		self.close_button_label.set_text('<GAME')
	elif self.root.bag.saving != null && self.root.bag.saving.is_save_available():
		self.close_button.show()
		self.close_button_label.set_text('<RESUME')
	else:
		self.close_button.hide()

func quit_game():
    OS.get_main_loop().quit()