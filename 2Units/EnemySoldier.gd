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
func flip_to_direction(direction, facing):
	for i in $KinematicBody2D.get_children():
		if i is CollisionPolygon2D:
			i.disabled = true
	
	if direction == "left":
		if facing == "up":
			$Sprite.position = Vector2(-2.5,-14)
			$Sprite.region_rect = Rect2(0,0,20,40)
			$"KinematicBody2D/left-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(0,-11)
			$Sprite.region_rect = Rect2(20,20,20,55)
			$"KinematicBody2D/left-lower".disabled = false
	elif direction == "right":
		if facing == "up":
			$Sprite.position = Vector2(-2.5,-14)
			$Sprite.region_rect = Rect2(57,0,20,40)
			$"KinematicBody2D/right-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(1,-11)
			$Sprite.region_rect = Rect2(38,20,23,55)
			$"KinematicBody2D/right-lower".disabled = false

func get_unit_order(turn_count):
	if order_list[turn_count][0] == "attack":
		return "This unit intended to attack a tile"
	elif order_list[turn_count][0] == "move":
		return "This unit intended to move to a tile"
	else:
		return "This unit does no action this turn"

#Return [action, location, friendly, type, self]
func get_order_details(turn_count):
	return order_list[turn_count].duplicate() + [friendly, type, self]
	
func on_hit(duration):
	$Tween.interpolate_property(self, "modulate:g", 1, 0, duration/3, 0, 2, 0)
	$Tween.interpolate_property(self, "modulate:b", 1, 0, duration/3, 0, 2, 0)
	
	$Tween.interpolate_property(self, "modulate:g", 0, 1, duration/3, 0, 2, duration*2/3)
	$Tween.interpolate_property(self, "modulate:b", 0, 1, duration/3, 0, 2, duration*2/3)
	$Tween.start()
