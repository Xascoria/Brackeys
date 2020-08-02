extends Node2D

#Store the reference to every single unit currently on the board
#Use [cord[y], cord[x]] to get a unit
var units_matrix = []

func _ready():
	pass
	
#Set a map matrix thats empty with size(int)
func set_map_size(size):
	units_matrix = []
	for i in range(size):
		units_matrix.append([])
		for j in range(size):
			units_matrix[i].append(null)

#Add a unit onto the map
func add_new_unit(ref_to_unit, coord):
	units_matrix[coord[1]][coord[0]] = ref_to_unit
	$PlayerYSort.add_child(ref_to_unit)

#Calculate the position of a certain tile with a coord
#Coord = [x,y]
func calculate_pos(coord):
	return $TileMap.map_to_world(Vector2(coord[0], coord[1])) + Vector2(0, 16) #16 = y/2
