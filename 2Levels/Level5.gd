#Level 1
extends Node2D

onready var enemy_tank = preload("res://2Units/EnemyTank.tscn")
onready var enemy_soldier = preload("res://2Units/EnemySoldier.tscn")
onready var friendly_tank = preload("res://2Units/FriendlyTank.tscn")
onready var friendly_soldier = preload("res://2Units/FriendlySoldier.tscn")
onready var building1 = preload("res://2Buildings/Building1.tscn")
onready var building2 = preload("res://2Buildings/Building2.tscn")
onready var building3 = preload("res://2Buildings/Building3.tscn")
onready var building4 = preload("res://2Buildings/Building4.tscn")

var unit_list = []
var replay_turns = [[]]
var unit_selected = 0
var turn_count = 0
var max_turn = 5
var check_for_health = GlobalVars.difficulty_hard

#Format: Type, Name, Health, State, Enabled, Grid_Coord
var level_contents = [
	#Friendly
	[
		["soldier", "Rita", 2, "ALIVE", true, Vector2(2,5)], 
		["soldier", "Phil", 0, "ALIVE", true, Vector2(4,5)],
		["soldier", "Ned", 1, "DOESN", true, Vector2(5,4)]
	],
	#Enemies
	[
		["soldier", "PSC127", 1, [["attack", Vector2(0,1)],["attack", Vector2(0,1)],["move", Vector2(0,-1)],["move", Vector2(0,-1)],["move", Vector2(0,-1)], ["rest", Vector2(0,0)] ], 
		true, Vector2(4,4)],
		["soldier", "DC719", 2, [["attack", Vector2(1,0)],["attack", Vector2(-1,0)],["move", Vector2(0,-1)],["move", Vector2(0,-1)],["move", Vector2(0,-1)], ["rest", Vector2(0,0)] ],
		true, Vector2(3,5)]
	],
	#Dates
	["26 September 2020", "25 September 2020", "24 September 2020", "23 September 2020", "22 September 2020", "21 September 2020"],
	#Victory condition: [friendly, position, health]
	[[false, Vector2(4,1), 3], [false, Vector2(3,2), 3], 
	[true, Vector2(6,5), 1],[true, Vector2(5,7), 3], [true, Vector2(1,7), 3]],
	#Obstacles
	#[[4, [0,0]], [1, [3,4]]],
	[[3, [1,5]], [4, [6,3]]],
	#scale and details
	[0.77, "BATTLE REPORT ON SEPTEMBER 21\n\nOK, THINGS ARE ACTUALLY GOING MUCH WORSE THAN WE FIRST EXPECTED, SO ITS TIME TO PACK IT UP AND LIVE TO FIGHT ANOTHER DAY, MAYBE."]
]

func _ready():
	GlobalVars.level_unlocked[0] = true
	SfxPlayer.play_sfx(8)
	BgmPlayer.change_song(1)
	$Map.set_map_size(8)
	setup_level()
	
	$UI.update_date(level_contents[2][turn_count])
	$UI.setup_bf_details(8, level_contents[3], level_contents[4], level_contents[5][0], level_contents[5][1])
	$UI.show_tutorial(4)
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
			unit.flip_to_direction("right", "up")
			if level_contents[0][i][2] == 0:
				unit.is_dead()
			
		elif level_contents[0][i][0] == "soldier":
			unit = friendly_soldier.instance()
			unit.flip_to_direction("right", "up")
			if level_contents[0][i][2] == 0:
				unit.is_dead()
		unit.setup(i, level_contents[0][i][1], level_contents[0][i][2], level_contents[0][i][3])
		
	
		$Map.add_new_unit(unit, level_contents[0][i][5])
		unit_list.append(unit)
		
	#Hostile units
	for i in range(len(level_contents[1])):
		if level_contents[1][i][0] == "tank":
			unit = enemy_tank.instance()
			unit.flip_to_direction("left", "down")
		elif level_contents[1][i][0] == "soldier":
			unit = enemy_soldier.instance()
			unit.flip_to_direction("left", "down")
		unit.setup(i + len(level_contents[0]), level_contents[1][i][1], level_contents[1][i][2], 
		level_contents[1][i][3])
		#unit.flip_to_direction("left")
		$Map.add_new_unit(unit, level_contents[1][i][5])
		unit_list.append(unit)
		
	#Buildings
	for i in range(len(level_contents[4])):
		var building
		match(level_contents[4][i][0]):
			1:
				building = building1.instance()
			2:
				building = building2.instance()
			3:
				building = building3.instance()
			4:
				building = building4.instance()
		$Map.add_building(building, level_contents[4][i][1])
		
#End states
func timeline_collasped(subtext):
	endstate_reached = true
	
	$TimelineInfo/Label.text = "TIMELINE COLLASPED"
	$TimelineInfo/sublabel.text = subtext
	$TimelineInfo/Tween.interpolate_property($TimelineInfo/ColorRect.get("material"), "shader_param/dispSize", 0.01, 2, 1.5)
	$TimelineInfo/Tween.start()
	$Map.visible = false
	$TimelineInfo.show()
	
	$UI.make_reset_visible()
	$UI.make_startturn_invisible()
	
### Dealing with victory	
	
func timeline_restored():
	endstate_reached = true
	$UI.make_startturn_invisible()
	
	$TimelineInfo/ColorRect.visible = false
	$TimelineInfo/Label.text = "TIMELINE RESTORED"
	$TimelineInfo/sublabel.text = "YOU HAVE SUCCESSFULLY REVERSED THE BATTLE"
	
	$TimelineInfo.modulate.a = 0
	$TimelineInfo/Tween.interpolate_property($TimelineInfo, "modulate:a", 0, 1, 1)
	$TimelineInfo/Tween.repeat = false
	$TimelineInfo/Tween.start()
	$TimelineInfo.show()
	$TimelineInfo/Timer.start()
	BgmPlayer.change_song(2)

var timer_once = false
func _on_Timer_timeout():
	if not timer_once:
		$TimelineInfo/Timer.wait_time = 4
		$TimelineInfo/Timer.start()
		$TimelineInfo/Label.text = "BATTLE REVISITED"
		$TimelineInfo/sublabel.text = ""
		timer_once = true
	else:
		$TimelineInfo.visible = false
		$Map.stop_grey_scale()
		reverse_battle()

func reverse_battle():
	SfxPlayer.play_sfx(6)
	replay_turns.pop_back()
	
	var output = []
	for i in range(len(replay_turns)):
		output.append([])
		for j in range(len(replay_turns[len(replay_turns)-1-i])):
			if replay_turns[len(replay_turns)-1-i][j][0] != "rest":
				output[len(output)-1].append(replay_turns[len(replay_turns)-1-i][j])
				
	
	$Map.yaah_its_rewind_time(output)

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
	SfxPlayer.play_sfx(3)
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
	SfxPlayer.play_sfx(5)
	if animation_playing or endstate_reached:
		return
	
	unit_selected = index
	var relative_pos = $Map.calculate_pos($Map.get_unit_coord(unit_list[index]))
	var true_pos = Vector2(relative_pos[0] * $Map.scale.x, relative_pos[1] * $Map.scale.y)
	
	var UI_pos = $Map.position + true_pos
	
	$UI.friendly_unit_details(index, unit_list[index].unit_name, unit_list[index].health, 
	unit_list[index].state, UI_pos)
	
func _on_UI_menu():
	get_tree().change_scene("res://2Scenes/Menu.tscn")

func _on_UI_restart():
	SfxPlayer.play_sfx(5)
	get_tree().reload_current_scene()
	
func _on_UI_reset():
	SfxPlayer.play_sfx(5)
	get_tree().reload_current_scene()
	
func _on_UI_order_given(type, index):
	SfxPlayer.play_sfx(7)
	if type == "attack":
		$Map.draw_predictions(unit_list[index], "attack")
	if type == "move":
		$Map.draw_predictions(unit_list[index], "move")
	if type == "skipturn":
		$UI.set_order_given(index, false)
		unit_list[index].order_given = []

func _on_UI_continue_lvl():
	SfxPlayer.play_sfx(4)
	get_tree().change_scene("res://2Levels/Level4.tscn")

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
	SfxPlayer.play_sfx(5)
	if animation_playing or endstate_reached:
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
	SfxPlayer.play_sfx(4)
	if animation_playing:
		return
		
	var unit_cord = $Map.get_unit_coord(unit_list[unit_selected])
	unit_list[unit_selected].order_given = [action, Vector2(coord[0], coord[1]) - unit_cord]
	$UI.set_order_given(unit_selected, true)
	
func _on_Map_rewind_complete():
	$UI.make_continue_visible()

func _on_Map_rewinded_day():
	
	level_contents[2].pop_back()
	$UI.update_date(level_contents[2][len(level_contents[2])-1])
	
func _on_Map_timeline_broke(subtext):
	timeline_collasped(subtext)
