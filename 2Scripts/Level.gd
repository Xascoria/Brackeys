#Script to run a level
extends Node2D

onready var enemy_tank = preload("res://2Units/EnemyTank.tscn")
onready var enemy_soldier = preload("res://2Units/EnemySoldier.tscn")
onready var friendly_tank = preload("res://2Units/FriendlyTank.tscn")
onready var friendly_soldier = preload("res://2Units/FriendlySoldier.tscn")

var friendly_unit = []
var enemy_unit = []

#Format: Type, Name, Health, State, Enabled, Grid_Coord
var level_contents = [
	#Friendly
	[
		["tank", "Wells", 1, "ALIVE", true, Vector2(1,3)], 
		["soldier", "Connor", 2, "ALIVE", true, Vector2(4,3)]
	],
	#Enemies
	[
		["tank", "AX29", 2, "ALIVE", true, Vector2(0,2)],
		["soldier", "GP33", 2, "ALIVE", true, Vector2(2,3)],
		["soldier", "FK182", 2, "ALIVE", true, Vector2(4,2)]
	]
]

func _ready():
	BgmPlayer.change_song(load("res://Resources/TestMusic.wav"))
	$Map.set_map_size(6)
	
	setup_level()
	
	#Each unit should have an index to be used to communicate between Map, UI, and level

#Function to setup the UI and units for a level
func setup_level():
	#Set UI units num and info
	var unit_names = []
	var unit_enabled = []
	for i in level_contents[0]:
		unit_names.append(i[1])
		unit_enabled.append(i[4])
	$UI.set_units_num( len(level_contents[0]) , unit_names, unit_enabled)
	
	#Friendly units
	var unit 
	for i in range(len(level_contents[0])):
		if level_contents[0][i][0] == "tank":
			unit = friendly_tank.instance()
		elif level_contents[0][i][0] == "soldier":
			unit = friendly_soldier.instance()
		unit.setup(i, level_contents[0][i][1], level_contents[0][i][2], level_contents[0][i][3])
		unit.flip_to_direction("right")
		$Map.add_new_unit(unit, level_contents[0][i][5])
		friendly_unit.append(unit)
		
	#Hostile units
	for i in range(len(level_contents[1])):
		if level_contents[1][i][0] == "tank":
			unit = enemy_tank.instance()
		elif level_contents[1][i][0] == "soldier":
			unit = enemy_soldier.instance()
		unit.setup(i + len(level_contents[0]), level_contents[1][i][1], level_contents[1][i][2], level_contents[1][i][3])
		unit.flip_to_direction("left")
		$Map.add_new_unit(unit, level_contents[1][i][5])
		friendly_unit.append(unit)

#Use a bool to deal with the animation
var animation_playing = false
## Dealing with UI

func _on_UI_startTurn():
	animation_playing = true
	pass
	
	#Relay this info to the map so it can start playing the turn
	

func _on_UI_unit_selected(index):
	var relative_pos = $Map.calculate_pos(level_contents[0][index][5])
	var true_pos = Vector2(relative_pos[0] * $Map.scale.x, relative_pos[1] * $Map.scale.y)
	
	var UI_pos = $Map.position + true_pos
	
	$UI.friendly_unit_details(index, friendly_unit[index].unit_name, friendly_unit[index].health, 
	friendly_unit[index].state, UI_pos)
	
func _on_UI_menu():
	pass # Replace with function body.

func _on_UI_restart():
	get_tree().reload_current_scene()

## Interactions with the map

func _on_Map_turn_finished():
	animation_playing = false
	$UI.enable_start_turn()

func _on_Map_unit_clicked(index):
	#Need to set for enemy too
	var ref_to_unit = friendly_unit[index]
	
	$UI.friendly_unit_details(index, ref_to_unit.unit_name, ref_to_unit.health, ref_to_unit.state, 
	get_viewport().get_mouse_position())
	

