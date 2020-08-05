#Friendly Soldier API
extends Node2D

var index
var unit_name
var health
var state = ""
var friendly = true
var order_given = []
const type = "soldier"

const attack_pattern = [Vector2(-1,0), Vector2(1,0), Vector2(0,1), Vector2(0,-1)]
const move_pattern = [Vector2(-1,0), Vector2(1,0), Vector2(0,1), Vector2(0,-1)]

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

#Return [action, location, friendly, type, self]
func get_order_details(_turn_count):
	var test = []
	if len(order_given) == 0:
		test = ["rest", Vector2(0,0)]
	else:
		test = order_given.duplicate()
	return test + [friendly, type, self]
