extends Area2D

export(Vector2) var map_pos
export(bool) var walkable = true
var omask
var smask

signal mouse_clicked(pos)

func _ready():
	smask = get_node("hex_blank/select_mask")
	omask = get_node("hex_blank/over_mask")

func _input_event(viewport, event, shape_idx):
	# mouse over
	if (event.type == InputEvent.MOUSE_MOTION):
		event = make_input_local(event)
		omask.enabled = true
	# click select tile
	if event.is_action_released("left_mouse"):
		var char
		if !smask.enabled:
			# clear old selected
			if get_parent() && get_parent().get_parent():
				get_parent().get_parent().clear_selected()
				
				if get_parent().get_parent().get_parent():
					var units = get_parent().get_parent().get_parent().units
					if units.has(map_pos):
						char = units[map_pos]
						get_parent().get_parent().select_range(char)
			# now i'm selected
			set_name("_selected")
		smask.enabled = !smask.enabled
		
		# send signal out
		emit_signal("mouse_clicked", map_pos, char)

# mouse out
func _mouse_exit():
	omask.enabled = false