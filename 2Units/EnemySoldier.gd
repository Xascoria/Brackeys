#Enemy Soldier API
extends Node2D

var index
var unit_name
var health
var state = ""
var friendly = false
#Format = [action, location]
var order_list = []
const type = "soldier"

func _ready():
	pass

func setup(index, unit_name, health, order_list):
	self.index = index
	self.unit_name = unit_name
	self.health = health
	self.order_list = order_list

signal clicked(index)
func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("clicked", index)

#Flipping the sprite for animation
func flip_to_direction(direction):
	if direction == "left":
		self.scale = Vector2(-1,1)
	elif direction == "right":
		self.scale = Vector2(1,1)

func get_unit_order(turn_count):
	print(order_list)
	if order_list[turn_count][0] == "attack":
		return "This unit intended to attack a tile"
	elif order_list[turn_count][0] == "move":
		return "This unit intended to move to a tile"
	else:
		return "This unit has no more actions left"

#Return [action, location, friendly, type, self]
func get_order_details(turn_count):
	return order_list[turn_count].duplicate() + [friendly, type, self]
