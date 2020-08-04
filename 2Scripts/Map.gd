extends Node2D

onready var clickbox = preload("res://2Scenes/TileClickbox.tscn")

#Store the reference to every single unit currently on the board
#Use [cord[y], cord[x]] to get a unit
var units_matrix = []
#Size of map, use to check for in bound
var map_size = 8

func _ready():
	#self.add_tile_clickbox([4,0])
	pass
	
#Set a map matrix thats empty with size(int)
func set_map_size(size):
	self.map_size = size
	
	units_matrix = []
	for i in range(size):
		units_matrix.append([])
		for _j in range(size):
			units_matrix[i].append(null)

#Add a unit onto the map
func add_new_unit(ref_to_unit, coord):
	
	#Do not add if its not in bound
	if not coord_in_bound(coord):
		return
	
	units_matrix[coord[1]][coord[0]] = ref_to_unit
	$UnitsYSort.add_child(ref_to_unit)
	
	ref_to_unit.position = calculate_pos(coord)
	ref_to_unit.connect("clicked", self, "unit_clicked")
	
signal unit_clicked(index)
func unit_clicked(index):
	emit_signal("unit_clicked", index)

#Make a tile clickable
#Use to choose attack/move tile
func add_tile_clickbox(action, coord):
	
	#Do not add if its not in bound
	if not coord_in_bound(coord):
		return
	
	#Use this part to set predictions square (tile id)
	match(action):
		#Friendly move
		"fm":
			pass
		#Friendly attack
		"fa":
			pass
	
	var new_clickbox = clickbox.instance()
	new_clickbox.position = calculate_pos(coord)
	new_clickbox.setup(coord)
	new_clickbox.connect("square_clicked", self, "tile_clicked_on")
	$PredictionsClickBox.add_child(new_clickbox)

#A tile is clicked on
#Process this info
signal tile_clicked_on
func tile_clicked_on(coord):
	print(coord)
	emit_signal("tile_clicked_on")

#Make all tiles unclickable
func clear_clickboxes():
	#Wipe all the predictions squares images
	for i in $Predictions.get_used_cells():
		$Predictions.set_cellv(i, -1)
	
	for i in $PredictionsClickBox.get_children():
		i.queue_free()

#Calculate the position of a certain tile with a coord
#Coord = [x,y]
func calculate_pos(coord):
	return $TileMap.map_to_world(Vector2(coord[0], coord[1])) + Vector2(0, 16) #16 = y/2

#Check if a given coordinate is in bound within this map
func coord_in_bound(coord):
	return coord[0] >= 0 and coord[0] < map_size and coord[1] >= 0 and coord[1] < map_size
	
#Tell level to start next turn
signal turn_finished
func turn_finished():
	emit_signal("turn_finished")
