extends Node2D

var is_friendly = true
var health = 3
var grid_position = Vector2(0,0)

#1 - attack to right bottom, #2 - attack to left, #3 attack to down, #4 move backward

var turn_num = 0
var enemy_behaviour = [0,0,0]
var turn_used = false
var index = 0

signal clicked(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_standing_position(Vector2(16,16))
	
func settings(friendly, health, grid_pos):
	self.is_friendly = friendly
	if friendly:
		$Sprite.texture = load("res://Resources/PlayerUnit.png")
	else:
		$Sprite.texture = load("res://Resources/EnemyUnit.png")
	self.health = health
	self.grid_position = grid_pos
	
#Return [[attackable], [walkable]]
func get_predictions():
	var output = []
	if is_friendly:
		if turn_used:
			return [[],[]]
		
		var transformations = [Vector2(1,1), Vector2(-1,1),Vector2(-1,-1), Vector2(1,-1)] 
		var shoot_transform = [Vector2(1,0), Vector2(-1,0),Vector2(0,1), Vector2(0,-1)]
		output.append([])
		output.append([])
		for i in range(len(transformations)):
			output[0].append(grid_position + transformations[i])
			output[1].append(grid_position + shoot_transform[i])
		return output
	#else:
	match (enemy_behaviour[turn_num]):
		1:
			return [[grid_position + Vector2(1,1)], []]
		2:
			return [[grid_position - Vector2(1,0)], []]
		3:
			return [[grid_position + Vector2(0,1)], []]		
		4:
			return [[], [grid_position + Vector2(0,-1)]]
		_:
			return [[],[]]

func _on_Clickbox_pressed():
	print("box clicked")
	emit_signal("clicked", index)

func set_standing_position(new_position):
	self.position = new_position - $StandingPos.position
