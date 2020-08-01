extends Node2D

onready var prediction_sqrt = preload("res://Scenes/Predict.tscn")

#[Node, is_moving, grid_cord]
var turn_moves = []

func _ready():
	pass
	
func add_unit(unit, cord):
	$PlayerYSort.add_child(unit)
	unit.set_standing_position(calculate_pos(cord))
	
func reset_predictions():
	for i in $Predictions.get_children():
		i.queue_free()

	
func show_predictions(node, predict, friendly):
	for i in $Predictions.get_children():
		i.queue_free()
		
	if ongoing_turn:
		return
	
	var pre_sqrt 
	for i in predict[0]:
		if in_bound(i):
			pre_sqrt = prediction_sqrt.instance()
			pre_sqrt.setup_sprite(friendly, false, i, node)
			pre_sqrt.position = calculate_pos(i)
			pre_sqrt.connect("sqrt_clicked_on", self, "pre_sqrt_clicked")
			$Predictions.add_child(pre_sqrt)
	for i in predict[1]:
		if in_bound(i):
			pre_sqrt = prediction_sqrt.instance()
			pre_sqrt.setup_sprite(friendly, true, i, node)
			pre_sqrt.position = calculate_pos(i)
			pre_sqrt.connect("sqrt_clicked_on", self, "pre_sqrt_clicked")
			$Predictions.add_child(pre_sqrt)

func pre_sqrt_clicked(friendly, grid_cord, is_move, node):
	if friendly:
		if is_move:
			turn_moves.append([node, true, grid_cord])
			#node.grid_position = grid_cord
			#node.set_standing_position(calculate_pos(grid_cord))
		else:
			turn_moves.append([node, false, grid_cord])
		node.turn_used= true
	
		self.reset_predictions()

#Cord: [x, y]
func calculate_pos(cord):
	return $TileMap.map_to_world(Vector2(cord[0], cord[1])) + Vector2(0, 16)

func get_units():
	return $YSort.get_children()

func in_bound(cord):
	return cord[0] >= 0 and cord[0] < 6 and cord[1] >= 0 and cord[1] < 6

var enemies = []

var ongoing_turn = false
func start_turn():
	if ongoing_turn:
		return
	ongoing_turn = true
	for i in $PlayerYSort.get_children():
		if not i.is_friendly:
			enemies.append(i)
	$Timer.start()

signal turn_finished
signal msg(string)

func _on_Timer_timeout():
	if len(enemies) > 0:
		match(enemies[0].enemy_behaviour[enemies[0].turn_num]):
			1:
				var position = enemies[0].grid_position + Vector2(1,1)
				for i in $PlayerYSort.get_children():
					if i.grid_position == position:
						i.health += 1
				emit_signal("msg", "Enemy un-attacked friendly(1)")
			2:
				var position = enemies[0].grid_position - Vector2(1,0)
				for i in $PlayerYSort.get_children():
					if i.grid_position == position:
						i.health += 1
				emit_signal("msg", "Enemy un-attacked friendly(2)")
			3:
				var position = enemies[0].grid_position + Vector2(0,1)
				for i in $PlayerYSort.get_children():
					if i.grid_position == position:
						i.health += 1
				emit_signal("msg", "Enemy un-attacked friendly(3)")
			4:
				var position = enemies[0].grid_position + Vector2(0,-1)
				enemies[0].set_standing_position(calculate_pos(position))
				enemies[0].grid_position  = position
				emit_signal("msg", "Enemy moved backward")
				
		enemies[0].turn_num += 1
		enemies.pop_front()
	elif len(turn_moves) > 0:
		#[Node, is_moving, grid_cord]
		if turn_moves[0][1]:
			turn_moves[0][0].set_standing_position(calculate_pos(turn_moves[0][2]))
			turn_moves[0][0].grid_position = turn_moves[0][2]
			emit_signal("msg", "Friendly moved")
		else:
			for i in $PlayerYSort.get_children():
				if i.grid_position == turn_moves[0][2]:
					i.health += 1
			emit_signal("msg", "Friendly unattacked enemy")
		turn_moves[0][0].turn_used = false
		turn_moves.pop_front()
	else:
		$Timer.stop()
		ongoing_turn = false
		emit_signal("turn_finished")
