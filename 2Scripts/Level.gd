#Script to run a level
extends Node2D

func _ready():
	BgmPlayer.change_song(load("res://Resources/TestMusic.wav"))


func _on_UI_startTurn():
	pass
	
	#Relay this info to the map so it can start playing the turn

func _on_Map_turn_finished():
	$CanvasLayer/UI.enable_start_turn()

