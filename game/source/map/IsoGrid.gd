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

static func map_to_world(cell: Vector2) -> Vector2:
	var x: int = int(cell.x) * int(CELL_SIZE.x)
	var y: int = int(cell.y) * int(CELL_SIZE.y)
	return Vector2(x, y)
