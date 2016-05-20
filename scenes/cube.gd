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
	
static func a_path_finding(start,goal,width,height):
	var frontier = []
	frontier.append(start)
	
	var came_from = {}
	came_from[start] = null
	
	var current
	while !frontier.empty():
		current = frontier[0] # get front
		if current == goal:
			break
		frontier.pop_front() # remove it
		
		for direction in range(0,6):
			var next = neighbor_oddr(current,direction)
			if (next.x>=0&&next.x<=width&&next.y>=0&&next.y<=height):
				if !came_from.has(next):
					frontier.append(next)
					came_from[next] = current
					
	# now follow the arrow
	current = goal
	var path = [current]
	while current!=start:
		current = came_from[current]
		path.append(current)
	
	return path