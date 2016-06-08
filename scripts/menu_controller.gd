var root

var quit_button

var root_tree

var background_gradient

func init_root(root_node):
	root = root_node
	self.root_tree = self.root.get_tree()
	
func _ready():
	self.background_gradient = self.get_node('vigette/center/bg_mask')
	
	quit_button = get_node("top/center/quit")
	
	quit_button.connect("pressed", self, "_quit_button_pressed")
	
func _quit_button_pressed():
    # self.root.sound_controller.play('menu')
    self.quit_game()

func quit_game():
    OS.get_main_loop().quit()