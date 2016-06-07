var root

var root_tree

var background_gradient

func init_root(root_node):
	root = root_node
	self.root_tree = self.root.get_tree()
	
func _ready():
	self.background_gradient = self.get_node('vigette/center/bg_mask')