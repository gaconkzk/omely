extends Area2D

const CubeUtils = preload("res://cube.gd")
export(Vector2) var map_pos = Vector2(0,0)
export(bool) var walkable = true
var hex
var omask
var smask
var map

signal selected(is_selected, pos)

func _ready():
	hex = get_node("hex_blank")
	smask = get_node("hex_blank/select_mask")
	omask = get_node("hex_blank/over_mask")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
#	map = get_parent().get_parent()

func _input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		smask.enabled = !smask.enabled
		emit_signal("selected", smask.enabled, map_pos)

func on_mouse_entered():
	if !omask.enabled:
		omask.enabled = true

func on_mouse_exited():
	if omask.enabled:
		omask.enabled = false

func on_mouse_clicked():
	smask.enabled = !smask.enabled