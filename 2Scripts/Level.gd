#Script to run a level
extends Node2D

onready var enemy_tank = preload("res://2Units/EnemyTank.tscn")
onready var enemy_soldier = preload("res://2Units/EnemySoldier.tscn")
onready var friendly_tank = preload("res://2Units/FriendlyTank.tscn")
onready var friendly_soldier = preload("res://2Units/FriendlySoldier.tscn")

var unit_list = []
var replay_turns = [[]]
var unit_selected = 0
var turn_count = 0
var max_turn = 3
var check_for_health = false

#Format: Type, Name, Health, State, Enabled, Grid_Coord
var level_contents = [
	#Friendly
	[
		["tank", "Wells", 1, "ALIVE", true, Vector2(1,3)], 
		["soldier", "Connor", 1, "ALIVE", true, Vector2(4,3)]
	],
	#Enemies
	[
		["tank", "AX29", 2, [["attack", Vector2(1,1)], ["move", Vector2(0,-1)], ["move", Vector2(0,-1)], ["rest", Vector2(0,0)]]
		,true , Vector2(0,2)],
		["soldier", "GP33", 2, [["attack", Vector2(-1,0)], ["move", Vector2(0,-1)], ["move", Vector2(0,-1)], ["rest", Vector2(0,0)]]
		,true , Vector2(2,3)],
		["soldier", "FK182", 2, [["attack", Vector2(0,1)], ["attack", Vector2(0,1)], ["move", Vector2(0,-1)], ["rest", Vector2(0,0)]]
		,true , Vector2(4,2)]
	],
	#Dates
	["18 December 2020", "17 December 2020", "16 December 2020", "15 December 2020"],
	#Victory condition: [friendly, position, health]
	[[false, Vector2(0,0), 3], [false, Vector2(2,1), 2], [false, Vector2(4,1), 2], 
	[true, Vector2(1,4), 3], [true, Vector2(4,4), 3]]
]

func _ready():
	BgmPlayer.change_song(1)
	$Map.set_map_size(6)
	setup_level()
	
	$UI.update_date(level_contents[2][turn_count])
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
		unit_list.append(unit)
		
	#Hostile units
	for i in range(len(level_contents[1])):
		if level_contents[1][i][0] == "tank":
			unit = enemy_tank.instance()
		elif level_contents[1][i][0] == "soldier":
			unit = enemy_soldier.instance()
		unit.setup(i + len(level_contents[0]), level_contents[1][i][1], level_contents[1][i][2], 
		level_contents[1][i][3])
		unit.flip_to_direction("left")
		$Map.add_new_unit(unit, level_contents[1][i][5])
		unit_list.append(unit)

#End states
func timeline_collasped(subtext):
	endstate_reached = true
	
	$TimelineInfo/Label.text = "TIMELINE COLLASPED"
	$TimelineInfo/sublabel.text = subtext
	$TimelineInfo/Tween.interpolate_property($TimelineInfo/ColorRect.get("material"), "shader_param/dispSize", 0.01, 2, 1.5)
	$TimelineInfo/Tween.start()
	$TimelineInfo.show()
	
	$UI.make_reset_visible()
	
### Dealing with victory	
	
func timeline_restored():
	endstate_reached = true
	
	$TimelineInfo/ColorRect.visible = false
	$TimelineInfo/Label.text = "TIMELINE RESTORED"
	$TimelineInfo/sublabel.text = "YOU HAVE SUCCESSFULLY REVERSED THE BATTLE"
	
	$TimelineInfo.modulate.a = 0
	$TimelineInfo/Tween.interpolate_property($TimelineInfo, "modulate:a", 0, 1, 1)
	$TimelineInfo/Tween.repeat = false
	$TimelineInfo/Tween.start()
	$TimelineInfo.show()
	$TimelineInfo/Timer.start()

var timer_once = false
func _on_Timer_timeout():
	if not timer_once:
		$TimelineInfo/Timer.wait_time = 4
		$TimelineInfo/Timer.start()
		$TimelineInfo/Label.text = "BATTLE OF LONDON"
		$TimelineInfo/sublabel.text = level_contents[2][len(level_contents[2])-1] + " - " + level_contents[2][len(level_contents[0])-1]
		timer_once = true
	else:
		$TimelineInfo.visible = false
		reverse_battle()

func reverse_battle():
	replay_turns.pop_back()
	level_contents[2].pop_back()
	
	for i in replay_turns[2]:
		print(i)

###Dealing with victory

func victory_check():
	for i in level_contents[3]:
		if $Map.units_matrix[i[1][1]][i[1][0]]:
			if $Map.units_matrix[i[1][1]][i[1][0]].friendly != i[0]:
				return false
			if check_for_health and $Map.units_matrix[i[1][1]][i[1][0]].health != i[2]:
				return false
		else:
			return false
	return true

	
#Use a bool to deal with the animation
var animation_playing = false
var endstate_reached = false

## Dealing with UI

func _on_UI_startTurn():
	if endstate_reached:
		return
	
	animation_playing = true
	
	#Save the information
	for i in range(len(unit_list)):
		replay_turns[len(replay_turns)-1].append(unit_list[len(unit_list)-i-1].get_order_details(turn_count).duplicate())
		
	#Relay this info to the map so it can start playing the turn
	$Map.start_animation(replay_turns[len(replay_turns)-1])
	replay_turns.append([])
	

func _on_UI_unit_selected(index):
	if animation_playing or endstate_reached:
		return
	
	unit_selected = index
	var relative_pos = $Map.calculate_pos(level_contents[0][index][5])
	var true_pos = Vector2(relative_pos[0] * $Map.scale.x, relative_pos[1] * $Map.scale.y)
	
	var UI_pos = $Map.position + true_pos
	
	$UI.friendly_unit_details(index, unit_list[index].unit_name, unit_list[index].health, 
	unit_list[index].state, UI_pos)
	
func _on_UI_menu():
	pass # Replace with function body.

func _on_UI_restart():
	get_tree().reload_current_scene()
	
func _on_UI_reset():
	get_tree().reload_current_scene()
	
func _on_UI_order_given(type, index):
	
	if type == "attack":
		$Map.draw_predictions(unit_list[index], "attack")
	if type == "move":
		$Map.draw_predictions(unit_list[index], "move")
	if type == "skipturn":
		$UI.set_order_given(index, false)
		unit_list[index].order_given = []

func _on_UI_continue_lvl():
	pass # Replace with function body.

## Interactions with the map

func _on_Map_turn_finished():
	animation_playing = false
	turn_count += 1
	$UI.enable_start_turn()
	$UI.reset_orders()
	
	#Reset all orders of friendly
	for i in unit_list:
		if i.friendly:
			i.order_given = []
	
	$UI.update_date(level_contents[2][turn_count])
	if turn_count == max_turn:
		if victory_check():
			timeline_restored()
		else:
			timeline_collasped("YOU FAILED TO RECREATE THE BATTLE IN REVERSE TIME")

func _on_Map_unit_clicked(index):
	if animation_playing:
		return
	
	if index < len(level_contents[0]):
		unit_selected = index
	var ref_to_unit = unit_list[index]
	
	if index < len(level_contents[0]):
		$UI.friendly_unit_details(index, ref_to_unit.unit_name, ref_to_unit.health, ref_to_unit.state, 
		get_viewport().get_mouse_position())
	else:
		$Map.draw_predictions(unit_list[index], unit_list[index].order_list[turn_count][0])
		$UI.enemy_unit_details(index, ref_to_unit.unit_name, ref_to_unit.health, ref_to_unit.get_unit_order(turn_count), 
		get_viewport().get_mouse_position())
	
func _on_Map_tile_clicked_on(action, coord):
	if animation_playing:
		return
		
	unit_list[unit_selected].order_given = [action, Vector2(coord[0], coord[1])]
	$UI.set_order_given(unit_selected, true)
	


