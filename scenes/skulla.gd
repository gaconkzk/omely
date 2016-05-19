extends Sprite
# import the cubeutils for hex calculation
# not sure this is the correct way to call 
# static func
const CubeUtils = preload("res://scenes/cube.gd")

export(Vector2) var map_pos = Vector2(0,0)

export(int, "up", "left", "down", "right") var direction = 2
export(int, "spellcast", "thrust", "walk", "slash", "shoot", "hurl") var action = 2
export(int) var speed
export(int) var move_range = 3
export(bool) var loop = true # reserve for enable/disable infinite loop throught frame

var _temp_elapsed = 0
var _cframe = 0
var mf = [7,8,9,6,13,6] # action max frame

func _ready():
	set_process(true)
	
func _process(delta):
	if loop:
		_temp_elapsed = _temp_elapsed + delta
		if (_temp_elapsed > 0.15):
			if (action!=5):
				set_frame(13*action*4+direction*13+_cframe)
			else:
				set_frame(13*action*4+_cframe)
			# we increase cframe to max_frame
			if _cframe < mf[action]-1:
				_cframe += 1
			# if we at max, reset it for looping
			else:
				_cframe = 0
		
			_temp_elapsed = 0
	else:
		_cframe = 0
	
func get_range():
	var c = CubeUtils.oddr2cube(map_pos)
	var result = []
	var n = move_range # real move range
	for dx in range(-n,n+1):
		for dy in range(max(-n, -dx-n),min(n, -dx+n)+1):
			var dz = -dx-dy
			var pos = CubeUtils.cube2oddr(Vector3(dx,dy,dz))
			result.append(pos)
	return result

# get path of nodes the unit 
# will cross when moving to dest_pos
func get_path(dest_pos):
	var result = []
	return result