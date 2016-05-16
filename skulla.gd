
extends Node2D

var temp_elapsed = 0
var cframe = 0
var skulla

export(int, "up", "left", "down", "right") var direction
export(int, "spellcast", "thrust", "walk", "slash", "shoot", "hurl") var action
var mf = [7,8,9,6,13,6]

func _ready():
	set_process(true)
	skulla = get_node("skulla")
	print("action:", action, " direction:", direction, " max_frame:", mf[action])
	
func _process(delta):
	temp_elapsed = temp_elapsed + delta
	if (temp_elapsed > 0.2):
		print("current frame: ",cframe)
		if (action!=5):
			skulla.set_frame(13*action*4+direction*13+cframe)
		else:
			skulla.set_frame(13*action*4+cframe)
		# we increase cframe to max_frame
		if cframe < mf[action]-1:
			cframe += 1
		# if we at max, reset it for looping
		else:
			cframe = 0
		
		temp_elapsed = 0


