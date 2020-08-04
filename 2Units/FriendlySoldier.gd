#Friendly Soldier API
extends Node2D

var index
var unit_name
var health
var state = ""

func _ready():
	pass

func setup(index, unit_name, health, state):
	self.index = index
	self.unit_name = unit_name
	self.health = health
	self.state = state

signal clicked(index)
func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("clicked", index)

#Flipping the sprite for animation
func flip_to_direction(direction):
	if direction == "left":
		self.scale = Vector2(1,1)
	elif direction == "right":
		self.scale = Vector2(-1,1)
