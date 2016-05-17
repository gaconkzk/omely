
extends Node2D

var Cube = preload("cube.gd")
var map_pos
var _temp_elapsed = 0
var _cframe = 0
var _skulla
var movable_pos

export(int, "up", "left", "down", "right") var direction
export(int, "spellcast", "thrust", "walk", "slash", "shoot", "hurl") var action
var mf = [7,8,9,6,13,6]
export(int) var move_range = 3

func _ready():
	set_process(true)
	_skulla = get_node("skulla")
	movable_pos = get_movement_range()
	
func set_map_pos(map_pos):
	self.map_pos = map_pos
func get_map_pos():
	return self.map_pos
	
func _process(delta):
	_temp_elapsed = _temp_elapsed + delta
	if (_temp_elapsed > 0.2):
		if (action!=5):
			_skulla.set_frame(13*action*4+direction*13+_cframe)
		else:
			_skulla.set_frame(13*action*4+_cframe)
		# we increase cframe to max_frame
		if _cframe < mf[action]-1:
			_cframe += 1
		# if we at max, reset it for looping
		else:
			_cframe = 0
		
		_temp_elapsed = 0

func get_movement_range():
	var c = oddr2cube(map_pos)
	var result = []
	for dx in range(-move_range,move_range):
		for dy in range(max(-move_range, -dx-move_range),min(move_range, -dx+move_range)):
			if (dx!=0 && dy!=0):
				var dz = -dx-dy
				var pos = cube2oddr(Cube.new(dx,dy,dz))
				print("pos x:",pos.x," y:",pos.y)
				result.append(pos)
	return result
	
static func cube2oddr(cube):
	var col = cube.x + (cube.z - (cube.z & 1)) / 2
	var row = cube.z
	
	return Vector2(col,row)
	
static func oddr2cube(pos):
	var Cube = preload("cube.gd")
	
	var x = pos.x - (pos.y - (int(pos.y) & 1)) / 2
	var z = pos.y
	var y = -x -z
	return Cube.new(x,y,z)