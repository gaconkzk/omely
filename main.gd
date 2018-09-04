extends Node2D

var selected_unit
var map

func _ready():
	randomize()
	
	map = get_node("map")
	
	print("{ width:", map.width, ", height: ", map.height, " }")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func mouse_clicked(pos, character):
	if character:
		print("clicked on ",character.get_name()," at pos ",pos)
		selected_unit = character
	else:
		map.reset_overlay()
		if selected_unit && selected_unit.can_move(pos):
			selected_unit.move_to(pos)