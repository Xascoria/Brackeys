extends Node2D

onready var unit = preload("res://Scenes/UnitDemo.tscn")
onready var details = preload("res://Scenes/DetailUI.tscn")

var turn_count = 0
var player_turn = true
var map = [
	#Friendly
	[Vector2(1,3), Vector2(4,3)],
	#Enemy
	[Vector2(0,2), Vector2(2,3), Vector2(4,2)]
]

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		for i in $UI/Control.get_children():
			i.queue_free()
		$MapDemo.reset_predictions()

func _ready():
	var new_unit
	for i in map[0]:
		new_unit = unit.instance()
		new_unit.settings(true, 1, i)
		new_unit.connect("clicked", self, "unit_click")
		$MapDemo.add_unit(new_unit, i)
		
	for i in range(len(map[1])):
		new_unit = unit.instance()
		new_unit.settings(false, 2, map[1][i])
		
		if i == 0:
			new_unit.enemy_behaviour = [1,4,4, 0]
		if i == 1:
			new_unit.enemy_behaviour = [2,4,4, 0]
		if i == 2:
			new_unit.enemy_behaviour = [3,3,4, 0]
		
		new_unit.connect("clicked", self, "unit_click")
		$MapDemo.add_unit(new_unit, map[1][i])

func unit_click(unit):
	for i in $UI/Control.get_children():
		i.queue_free()
	
	$MapDemo.show_predictions(unit, unit.get_predictions(), unit.is_friendly)
	var new_details = details.instance()
	new_details.set_text(unit)
	$UI/Control.add_child(new_details)
	new_details.set_global_position(unit.get_global_position() + Vector2(0, 120))

func _on_Start_pressed():
	
	if turn_count >= 3:
		return
		
	turn_count += 1
	
	$UI/Status.text = "Turn started"
	$MapDemo.start_turn()

func _on_Button2_pressed():
	get_tree().reload_current_scene()

func _on_MapDemo_turn_finished():
	$UI/Status.text = "Turn: " + str(2-turn_count)

func _on_MapDemo_msg(string):
	$UI/Status.text = string
