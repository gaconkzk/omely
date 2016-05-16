
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
	print("total frames: ",skulla.get_vframes()*skulla.get_hframes())
	
func _process(delta):
	temp_elapsed = temp_elapsed + delta
	if (temp_elapsed > 0.25):
		if cframe < mf[action]:
			cframe += 1
		else:
			cframe = 0
		if (action!=5):
			skulla.set_frame(direction*13*action*4+cframe)
		else:
			skulla.set_frame(13*action*4+cframe)
		
		temp_elapsed = 0


