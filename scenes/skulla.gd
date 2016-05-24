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

var _elapsed_time = 0
var _cur_map_pos = null
var _next_map_pos = null
var _cur_pos = null
var _next_pos = null
var _distance
var path = []
var _map

func _ready():
	set_process(true)
	_map = get_parent().get_parent()
	
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
	
	if _cur_map_pos!=null:
		if get_pos().distance_to(_next_pos)<=(_cur_pos.distance_to(_next_pos)*delta*speed):
			set_pos(_next_pos)
			if (path.size()>0):
				_cur_map_pos = _next_map_pos
				_next_map_pos = path[0]
				path.pop_front()
				_cur_pos = CubeUtils.map2pix(_cur_map_pos,_map)
				_next_pos = CubeUtils.map2pix(_next_map_pos,_map)
			else:
				_cur_pos = null
				_cur_map_pos = null
				map_pos = _next_map_pos
				
				_next_pos = null
				_next_map_pos = null
				_map.get_parent().units.erase(_cur_map_pos)
				_map.get_parent().units[map_pos] = self
		else:
			translate((_next_pos-_cur_pos)*delta*speed)
		
		

func can_move(pos):
	return CubeUtils.distance_oddr(map_pos, pos)<=move_range
	
func move_to(pos):
	print("move ",get_name()," from ",map_pos," to ", pos)
	path = CubeUtils.a_path_finding(map_pos,pos,_map)
	path.invert()
	action = 2
	_cur_map_pos = path[0]
	path.pop_front() # remove
	_next_map_pos = path[0]
	path.pop_front()
	
	_cur_pos = CubeUtils.map2pix(_cur_map_pos,_map)
	_next_pos = CubeUtils.map2pix(_next_map_pos,_map)
	
	print("curr pos",_cur_pos)
	print("next pox",_next_pos)
	

# get path of nodes the unit 
# will cross when moving to dest_pos
func get_path(dest_pos):
	var result = []
	return result