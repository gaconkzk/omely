# cube - vector3
# hex and axial - vector2

const ODDR_R_NEIGHBORS = [ \
	[ Vector2(1, 0), Vector2(0,-1), Vector2(-1,-1),
	Vector2(-1, 0), Vector2(-1,1), Vector2(0,1)],
	[ Vector2(1, 0), Vector2(1,-1), Vector2(0,-1),
	Vector2(-1, 0), Vector2(0,1), Vector2(1,1)]
]

static func cube2oddr(cube):
	var col = cube.x + (cube.z - (int(cube.z) & 1)) / 2
	var row = cube.z
	
	return Vector2(col,row)
	
static func oddr2cube(hex):
	var x = hex.x - (hex.y - (int(hex.y) & 1)) / 2
	var z = hex.y
	var y = -x -z
	return Vector3(x,y,z)

static func neighbor_oddr(hex, direction):
	var parity  = int(hex.y) & 1
	var dir = ODDR_R_NEIGHBORS[parity][direction]
	
	return Vector2(hex.x+dir.x, hex.y+dir.y)
	
static func distance_oddr(hex_1, hex_2):
	var x1 = hex_1.x - (hex_1.y - (int(hex_1.y) & 1)) / 2
	var x2 = hex_2.x - (hex_2.y - (int(hex_2.y) & 1)) / 2
	
	return (abs(x1 -x2) + abs(-x1 - hex_1.y + x2 + hex_2.y) + abs(hex_1.y - hex_2.y)) / 2
	
static func range_cube(cube,irange):
	var ret = []
	for x in range(-irange, irange+1):
		for y in range(max(-irange, -x -irange), min(irange, -x +irange)+1):
			var z = -x -y
			ret.append(Vector3(cube.x+x,cube.y+y,cube.z+z))
	return ret

static func range_oddr(hex, irange):
	var cubes = range_cube(oddr2cube(hex), irange)
	var hexs = []
	for cube in cubes:
		hexs.append(cube2oddr(cube))
	return hexs
# A* path finding
static func a_path_finding(start,goal,map):
	var frontier = PQueue.new()
	var priorities = []
	frontier.push(start,0)
	priorities.push_back(0)
	
	var came_from = {}
	var cost_so_far = {}
	came_from[start] = null
	cost_so_far[start] = 0
	
	var current
	while !frontier.empty():
		current = frontier.pop() # get front
		if current == goal:
			break
		priorities.pop_front()
		
		for direction in range(0,6):
			var next = neighbor_oddr(current,direction)
			if (next.x>=0&&next.x<=map.width&&next.y>=0&&next.y<=map.height):
				var new_cost = cost_so_far[current] + map.gcost(current,next)
				if !cost_so_far.has(next) or new_cost < cost_so_far[next]:
					cost_so_far[next] = new_cost
					var priority = new_cost + distance_oddr(goal,next)
					frontier.push(next,priority)
					priorities.push_back(priority)
					came_from[next] = current
	# now follow the arrow
	current = goal
	var path = [current]
	while current!=start:
		current = came_from[current]
		path.append(current)
	
	return path

static func get_highest_priority_idx(f,p,max_idx):
	var c_max = -1
	var idx = -1
	for i in range(0,p.size()):
		if p[i] > c_max:
			c_max = p[i]
			idx = i
	print(idx)
	return idx

# Very bad PQueue implementation
# For now I need resort the data when push
class PQueue:
	var data = []
	func empty():
		return data.empty()
	func push(val,priority):
		data.push_back([priority,val])
		data.sort_custom(self,"_soft")
	func pop():
		var ret = data[0][1]
		data.pop_front()
		return ret
	func _soft(o1,o2):
		return o1[0]<o2[0]