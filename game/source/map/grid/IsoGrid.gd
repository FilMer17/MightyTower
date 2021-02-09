extends Node
class_name IsoGrid

enum Directions { N, NE, E, SE, S, SW, W, NW }

const CELL_SIZE := Vector2(32, 16)
const HALF_CELL := Vector2(16, 8)

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

func map_to_world(cell: Vector2) -> Vector2:
	var x: int = int((cell.x - cell.y) * HALF_CELL.x)
	var y: int = int((cell.x + cell.y) * HALF_CELL.y)
	
	return Vector2(x, y)

func world_to_map(position: Vector2) -> Vector2:
	var x: int = int(position.x / CELL_SIZE.x + position.y / CELL_SIZE.y)
	var y: int = int(position.y / CELL_SIZE.y - position.x / CELL_SIZE.x)
	
	return Vector2(x, y)
