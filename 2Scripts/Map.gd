extends Node2D

onready var clickbox = preload("res://2Scenes/TileClickbox.tscn")

#Store the reference to every single unit currently on the board
#Use [cord[y], cord[x]] to get a unit
var units_matrix = []
#Size of map, use to check for in bound
var map_size = 8
var explosion = load("res://2Scenes/Explosion.tscn")

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
			
	for i in $Egdes.get_used_cells():
		$Egdes.set_cellv(i, -1)
		
	for i in range(size):
		$Egdes.set_cellv(Vector2(i,size-1), 0)
		$Egdes.set_cellv(Vector2(size-1,i), 0)

#Add a unit onto the map
func add_new_unit(ref_to_unit, coord):
	
	#Do not add if its not in bound
	if not coord_in_bound(coord):
		return
	
	units_matrix[coord[1]][coord[0]] = ref_to_unit
	$UnitsYSort.add_child(ref_to_unit)
	
	ref_to_unit.position = calculate_pos(coord)
	ref_to_unit.connect("clicked", self, "unit_clicked")
	
var building_list = []
func add_building(ref_to_building, coord):
	if not coord_in_bound(coord):
		return
	
	units_matrix[coord[1]][coord[0]] = ref_to_building
	building_list.append(ref_to_building)
	$UnitsYSort.add_child(ref_to_building)
	ref_to_building.position = calculate_pos(coord)
	
signal unit_clicked(index)
func unit_clicked(index):
	emit_signal("unit_clicked", index)

#Draw the aim and move tile
#type: attack or move
func draw_predictions(ref_to_node, type):
	var node_pos
	for i in range(len(units_matrix)):
		for j in range(len(units_matrix[i])):
			if units_matrix[i][j]:
				if units_matrix[i][j] == ref_to_node:
					node_pos = Vector2(j,i)
					break
	
	if ref_to_node.friendly:
		if type == "attack":
			for i in ref_to_node.attack_pattern:
				self.add_tile_clickbox("fa", node_pos + i)
		if type == "move":
			for i in ref_to_node.move_pattern:
				self.add_tile_clickbox("fm", node_pos + i)
	else:
		if ref_to_node.order_list[self.get_parent().turn_count][0] == "attack":
			self.add_tile_clickbox("ea", node_pos + ref_to_node.order_list[self.get_parent().turn_count][1])
		if ref_to_node.order_list[self.get_parent().turn_count][0] == "move":
			self.add_tile_clickbox("em", node_pos + ref_to_node.order_list[self.get_parent().turn_count][1])

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
			$Predictions.set_cell(coord[0], coord[1], 4)
		#Friendly attack
		"fa":
			$Predictions.set_cell(coord[0], coord[1], 1)
		#Enemy move
		"em":
			$Predictions.set_cell(coord[0], coord[1], 2)
			return
		#Enemy attack
		"ea":
			$Predictions.set_cell(coord[0], coord[1], 3)
			return
	
	var new_clickbox = clickbox.instance()
	new_clickbox.position = calculate_pos(coord)
	new_clickbox.setup(coord, action)
	new_clickbox.connect("square_clicked", self, "tile_clicked_on")
	$PredictionsClickBox.add_child(new_clickbox)

#A tile is clicked on
#Process this info
signal tile_clicked_on(action, coord)
func tile_clicked_on(coord, action):
	var true_action 
	if action == "fa":
		true_action = "attack"
	else:
		true_action = "move"
	
	emit_signal("tile_clicked_on", true_action, coord)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		self.clear_clickboxes()

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
	
var turn_info = null
#Trigger animation to play
func start_animation(turn_info):
	clear_clickboxes()
	
	self.turn_info = turn_info.duplicate()
	$TurnTimer.start()

func _on_TurnTimer_timeout():
	if len(turn_info) > 0:
		var turn = turn_info.pop_front()
		execute_turn(turn)
	if len(turn_info) == 0:
		$TurnTimer.stop()
		turn_finished()
	
signal timeline_broke(subtext)
signal timeline_restored(subtex)
	
#Tell level to start next turn
signal turn_finished
func turn_finished():
	emit_signal("turn_finished")

#format = [action, location, friendly, type, self]
func execute_turn(this_turn_info):
	var node_pos
	for i in range(len(units_matrix)):
		for j in range(len(units_matrix[i])):
			if units_matrix[i][j]:
				if units_matrix[i][j] == this_turn_info[4]:
					node_pos = Vector2(j,i)
					break
	
	var target_pos
	#if not this_turn_info[4].friendly:
	target_pos = node_pos + this_turn_info[1]
	#else:
		#target_pos = this_turn_info[1]
	
	match(this_turn_info[0]):
		"attack":
			
			var current_pos = calculate_pos(node_pos)
			var target_pos2 = calculate_pos(node_pos - this_turn_info[1])
			var direction 
			var facing
			if current_pos[0] > target_pos2[0]:
				direction = "right"
			else:
				direction = "left"
			if current_pos[1] > target_pos2[1]:
				facing = "down"
			else:
				facing = "up"
			this_turn_info[4].flip_to_direction(direction, facing)
			
			var new_exp = explosion.instance()
			self.add_child_below_node($Tween, new_exp)
			new_exp.position = Vector2(calculate_pos(target_pos)+Vector2(0,-5))
			new_exp.play_reversed_exp()
			
			if this_turn_info[3] == "soldier":
				if units_matrix[target_pos[1]][target_pos[0]]:
					if not units_matrix[target_pos[1]][target_pos[0]] in building_list:
						print(this_turn_info[4].unit_name + " attacked " + units_matrix[target_pos[1]][target_pos[0]].unit_name)
						if units_matrix[target_pos[1]][target_pos[0]].health == 0:
							units_matrix[target_pos[1]][target_pos[0]].revive(0.7)
						
						units_matrix[target_pos[1]][target_pos[0]].health += 1
						units_matrix[target_pos[1]][target_pos[0]].on_hit(0.7)
				else:
					print(this_turn_info[4].unit_name + " attacked nothing")
				
			
		
			elif this_turn_info[3] == "tank":
				if shockwave_invalid(target_pos):
					$TimelineTimer.start()
				
				print(this_turn_info[4].unit_name + " launched a cannon shot")
				if units_matrix[target_pos[1]][target_pos[0]]:
					print(units_matrix[target_pos[1]][target_pos[0]].unit_name + " got hit directly and lost(?) 2 health")
					if units_matrix[target_pos[1]][target_pos[0]].health == 0:
						units_matrix[target_pos[1]][target_pos[0]].revive(0.7)
					
					units_matrix[target_pos[1]][target_pos[0]].health += 2
	
					units_matrix[target_pos[1]][target_pos[0]].on_hit(0.7)
				var trans_coord = [Vector2(2,0), Vector2(0,2), Vector2(-2,0), Vector2(0,-2)]
				var trans_coord2 = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
				var in_vector = Vector2(target_pos[0], target_pos[1])
				for i in range(len(trans_coord)):
					if coord_in_bound(in_vector + trans_coord[i]):
						if units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]]:
							if not units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]] in building_list:
								$Tween.interpolate_property(units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]], "position", units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].position, calculate_pos(target_pos + trans_coord2[i]), 1.2)
								if units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].health == 0:
									units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].health.revive(0.7)
			
								units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].health += 1
								units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].on_hit(0.7)
								print(units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]].unit_name + " gets pushed by a cannon shoot and lost 1 health")
								
								units_matrix[(in_vector + trans_coord2[i])[1]][(in_vector + trans_coord2[i])[0]] = units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]] 
								units_matrix[(in_vector + trans_coord[i])[1]][(in_vector + trans_coord[i])[0]]  = null
				
				$Tween.start()
				
				
		"move":

			var current_pos = calculate_pos(node_pos)
			var target_pos2 = calculate_pos(node_pos - this_turn_info[1])
			var direction 
			var facing
			if current_pos[0] > target_pos2[0]:
				direction = "left"
			else:
				direction = "right"
			if current_pos[1] > target_pos2[1]:
				facing = "up"
			else:
				facing = "down"
			this_turn_info[4].flip_to_direction(direction, facing)
			
			
			if units_matrix[target_pos[1]][target_pos[0]]:
				tl_type = 1
				$TimelineTimer.start()
			
			$Tween.interpolate_property(this_turn_info[4], "position", this_turn_info[4].position, calculate_pos(target_pos), 1.2)
			$Tween.start()
			units_matrix[node_pos[1]][node_pos[0]] = null
			units_matrix[target_pos[1]][target_pos[0]] = this_turn_info[4]
			print(this_turn_info[4].unit_name + " moved")
			
		"rest":
			print(this_turn_info[4].unit_name + " did nothing this turn")

var tl_type = 1
func _on_TimelineTimer_timeout():
	var output_msg
	match(tl_type):
		1:
			output_msg = "YOU MADE A LOGICALLY IMPOSSIBLE MOVE IN REVERSE TIME"
	emit_signal("timeline_broke", output_msg)

##Rewind stuff
signal rewind_complete
signal rewinded_day
var rewind_contents = []
var rewinding_day = []
func yaah_its_rewind_time(rewind_contents):
	self.rewind_contents = rewind_contents
	$RewindTimer.start()
	
func rewind_turn(turn_content):
	var node_pos
	for i in range(len(units_matrix)):
		for j in range(len(units_matrix[i])):
			if units_matrix[i][j]:
				if units_matrix[i][j] == turn_content[4]:
					node_pos = Vector2(j,i)
					break

	var target_pos
					
	match(turn_content[0]):
		"attack":
			var current_pos = calculate_pos(node_pos)
			var target_pos2 = calculate_pos(node_pos - turn_content[1])
			var direction 
			var facing
			if current_pos[0] > target_pos2[0]:
				direction = "right"
			else:
				direction = "left"
			if current_pos[1] > target_pos2[1]:
				facing = "down"
			else:
				facing = "up"
			print(direction)
			print(facing)
			turn_content[4].flip_to_direction(direction, facing)
			
			target_pos = node_pos + turn_content[1]
			
			var new_exp = explosion.instance()
			self.add_child_below_node($Tween, new_exp)
			new_exp.position = Vector2(calculate_pos(target_pos)+Vector2(0,-5))
			new_exp.play_normal_exp()
			
			
			if turn_content[3] == "soldier":
				if units_matrix[target_pos[1]][target_pos[0]]:
					if not units_matrix[target_pos[1]][target_pos[0]] in building_list:
						print(turn_content[4].unit_name + " attacked " + units_matrix[target_pos[1]][target_pos[0]].unit_name)
						units_matrix[target_pos[1]][target_pos[0]].health -= 1
						
						if units_matrix[target_pos[1]][target_pos[0]].health == 0:
							units_matrix[target_pos[1]][target_pos[0]].kill_off(0.35)
						
						units_matrix[target_pos[1]][target_pos[0]].on_hit(0.35)
				else:
					print(turn_content[4].unit_name + " attacked nothing")
			elif turn_content[3] == "tank":
				if units_matrix[target_pos[1]][target_pos[0]]:
					if not units_matrix[target_pos[1]][target_pos[0]] in building_list:
						if units_matrix[target_pos[1]][target_pos[0]].health == 2:
							units_matrix[target_pos[1]][target_pos[0]].kill_off(0.35)
						
						units_matrix[target_pos[1]][target_pos[0]].health -= 2
						units_matrix[target_pos[1]][target_pos[0]].on_hit(0.35)
				var transformation  = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
				var transformation2 = [Vector2(2,0), Vector2(-2,0), Vector2(0,2), Vector2(0,-2)]
				var in_vector = Vector2(target_pos[0], target_pos[1])
				for i in range(len(transformation)):
					if units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]]:
						if not units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]] in building_list:
							units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]].health -= 1
							
							if units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]].health == 0:
								units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]].kill_off(0.35)
							units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]].on_hit(0.35)
							
							var ref_to_unit = units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]]
							$Tween.interpolate_property(ref_to_unit, "position", ref_to_unit.position, calculate_pos(in_vector + transformation2[i]),0.6) 
							
							units_matrix[(in_vector + transformation2[i])[1]][(in_vector + transformation2[i])[0]] = units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]]
							units_matrix[(in_vector + transformation[i])[1]][(in_vector + transformation[i])[0]] = null
							
				$Tween.start()
					
		"move":
			
			
			var current_pos = calculate_pos(node_pos)
			var target_pos2 = calculate_pos(node_pos - turn_content[1])
			var direction 
			var facing
			if current_pos[0] > target_pos2[0]:
				direction = "left"
			else:
				direction = "right"
			if current_pos[1] > target_pos2[1]:
				facing = "up"
			else:
				facing = "down"
			turn_content[4].flip_to_direction(direction, facing)
			
			target_pos = node_pos - turn_content[1]
			$Tween.interpolate_property(turn_content[4], "position", turn_content[4].position, calculate_pos(target_pos), 0.6)
			$Tween.start()
			units_matrix[node_pos[1]][node_pos[0]] = null
			units_matrix[target_pos[1]][target_pos[0]] = turn_content[4]
			print(turn_content[4].unit_name + " moved")

func _on_RewindTimer_timeout():
	if len(rewind_contents) == 0 and len(rewinding_day) == 0:
		emit_signal("rewind_complete")
		$RewindTimer.stop()
		return
	
	if len(rewinding_day) == 0:
		rewinding_day = rewind_contents.pop_front()
		emit_signal("rewinded_day")
	rewind_turn(rewinding_day.pop_back())

func get_unit_coord(ref_to_unit):
	for i in range(len(units_matrix)):
		for j in range(len(units_matrix[i])):
			if units_matrix[i][j]:
				if units_matrix[i][j] == ref_to_unit:
					return Vector2(j,i)

func stop_grey_scale():
	$Tween.interpolate_property($ColorRect, "modulate:a", 1, 0, 3)
	$Tween.start()

#If a shockwave is logically possible
func shockwave_invalid(coord):
	var in_vector = Vector2(coord[0], coord[1])
	var transformations = [Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(0,-1)]
	var second_trans = [Vector2(0,2), Vector2(2,0), Vector2(-2,0), Vector2(0,-2)]
	for i in transformations:
		if coord_in_bound(in_vector + i):
			if units_matrix[(in_vector+i)[1]][(in_vector+i)[0]]:
				return true
	
	print()
	
	for i in range(len(second_trans)):
		if coord_in_bound(in_vector + second_trans[i]):
			if units_matrix[(in_vector+transformations[i])[1]][(in_vector+transformations[i])[0]]:
				return true
	
	return false
	
