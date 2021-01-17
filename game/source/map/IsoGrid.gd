class_name IsoGrid

enum Directions { N, NE, E, SE, S, SW, W, NW }

const CELL_SIZE := Vector2(32, 16)

const NEIGHBOR_TABLE := [
	Vector2(-1, -1), # N
	Vector2(0, -1), # NE
	Vector2(1, -1), # E
	Vector2(1, 0), # SE
	Vector2(1, 1), # S
	Vector2(0, 1), # SW
	Vector2(-1, 1), # W
	Vector2(-1, 0), # NW
]

static func map_to_world(cell: Vector2, size: Vector2) -> Vector2:
	var x: int = int(cell.x) * int(CELL_SIZE.x * size.x)
	var y: int = int(cell.y) * int(CELL_SIZE.y * size.y)
	
	return Vector2(x, y)

static func world_to_map(position: Vector2, size: Vector2) -> Vector2:
# warning-ignore:integer_division
	var x: int = int(position.x) / int(CELL_SIZE.x * size.x)
# warning-ignore:integer_division
	var y: int = int(position.y) / int(CELL_SIZE.y * size.y)
	
	return Vector2(x, y)

static func get_neighbor(cell: Vector2, direction: int) -> Vector2:
	var neighbor: Vector2 = cell + NEIGHBOR_TABLE[direction]
	
	return neighbor

static func get_all_neighbors(cell: Vector2) -> PoolVector2Array:
	var neighbors: PoolVector2Array = []
	
	for direction in NEIGHBOR_TABLE:
		var neighbor_cell: Vector2 = cell + direction
		neighbors.append(neighbor_cell)
	
	return neighbors

static func get_area_around(cell: Vector2, scale: int) -> PoolVector2Array:
	var area_around: PoolVector2Array = []
	
	for neighbor_direction in NEIGHBOR_TABLE:
		var neighbor: Vector2 = cell
		var temp: Vector2 = neighbor
# warning-ignore:unused_variable
		for i in range(0, scale):
			temp = neighbor
			neighbor = temp + neighbor_direction
			area_around.append(neighbor)
	
	return area_around
