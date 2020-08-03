#Detects a click on a tile
extends Node2D

#Grid coordinates of the clickbox
var grid_coord 

func _ready():
	pass # Replace with function body.
	
func setup(coord):
	self.grid_coord = coord

signal square_clicked(grid_coord)
func _on_StaticBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("square_clicked", grid_coord)
