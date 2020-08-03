#Script to run a level
extends Node2D

var test_instance
func _ready():
	BgmPlayer.change_song(load("res://Resources/TestMusic.wav"))
	
	$UI.set_units_num(4,["Y", "M", "C", "A"], [true, true, false, false])
	
	
	$Map.set_map_size(8)
	var testing = load("res://Scenes/UnitDemo.tscn")
	test_instance = testing.instance()
	test_instance.settings(true, 5, [1,1])
	
	$Map.add_new_unit(test_instance, [4,4])
	
	#Each unit should have an index to be used to communicate between Map, UI, and level


func _on_UI_startTurn():
	pass
	
	#Relay this info to the map so it can start playing the turn

func _on_Map_turn_finished():
	$UI.enable_start_turn()

func _on_UI_unit_selected(index):
	pass # Replace with function body.

func _on_Map_unit_clicked(index):
	var mouse_pos = get_viewport().get_mouse_position()
	$UI.friendly_unit_details("testing", 5, "bruh", mouse_pos)
	
	pass
