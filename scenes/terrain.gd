extends Area2D

const CubeUtils = preload("res://scenes/cube.gd")
export(Vector2) var map_pos
export(bool) var walkable = true
var omask
var smask
var map

signal mouse_clicked(pos)

func _ready():
	smask = get_node("hex_blank/select_mask")
	omask = get_node("hex_blank/over_mask")
	map = get_parent().get_parent()

func _input_event(viewport, event, shape_idx):
	# mouse over
	if (event.type == InputEvent.MOUSE_MOTION && !omask.enabled):
		event = make_input_local(event)
		omask.enabled = true
		print(get_pos())
		if map.get_parent().selected_unit!=null:
			var su = map.get_parent().selected_unit
			if CubeUtils.distance_oddr(su.map_pos,map_pos) <= su.move_range:
				var path = CubeUtils.a_path_finding(su.map_pos,map_pos,map)
				map.show_path(path)
	# click select tile
	if event.is_action_released("left_mouse"):
		var selected_char = null
		if !smask.enabled:
			# clear old selected
			if get_parent() && map:
				map.clear_selected()
				
				if map.get_parent():
					var units = map.get_parent().units
					if units.has(map_pos):
						selected_char = units[map_pos]
						map.select_range(selected_char)
			# now i'm selected
			set_name("_selected")
		smask.enabled = !smask.enabled
		
		# send signal out
		emit_signal("mouse_clicked", map_pos, selected_char)

# mouse out
func _mouse_exit():
	omask.enabled = false
	map.reset_overlay()