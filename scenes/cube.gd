static func cube2oddr(cube):
	var col = cube.x + (cube.z - (int(cube.z) & 1)) / 2
	var row = cube.z
	
	return Vector2(col,row)
	
static func oddr2cube(pos):
	var x = pos.x - (pos.y - (int(pos.y) & 1)) / 2
	var z = pos.y
	var y = -x -z
	return Vector3(x,y,z)
	
static func offset_neighbor(hex, direction):
	var directions = [ \
		[ Vector2(1, 0), Vector2(0,-1), Vector2(-1,-1),
		Vector2(-1, 0), Vector2(-1,1), Vector2(0,1)],
		[ Vector2(1, 0), Vector2(1,-1), Vector2(0,-1),
		Vector2(-1, 0), Vector2(0,1), Vector2(1,1)]
	]
	
	var parity  = hex.y & 1
	var dir = directions[parity][direction]
	
	return Vector2(hex.x+dir.x, hex.y+dir.y)