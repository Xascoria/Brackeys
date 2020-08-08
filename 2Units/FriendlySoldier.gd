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
func flip_to_direction(direction, facing):
	for i in $KinematicBody2D.get_children():
		if i is CollisionPolygon2D:
			i.disabled = true
	
	if direction == "left":
		if facing == "up":
			$Sprite.position = Vector2(-3.252,-9.633)
			$Sprite.region_rect = Rect2(12,0,21.5,32.7)
			$"KinematicBody2D/left-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(-0.446,-9.142)
			$Sprite.region_rect = Rect2(12,32,21.5,30)
			$"KinematicBody2D/left-lower".disabled = false
	elif direction == "right":
		if facing == "up":
			$Sprite.position = Vector2(3.413,-9.984)
			$Sprite.region_rect = Rect2(33,0,21.5,32.7)
			$"KinematicBody2D/right-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(-0.446,-9.142)
			$Sprite.region_rect = Rect2(32.2,32,21.5,30)
			$"KinematicBody2D/right-lower".disabled = false

#Return [action, location, friendly, type, self]
func get_order_details(_turn_count):
	var test = []
	if len(order_given) == 0:
		test = ["rest", Vector2(0,0)]
	else:
		test = order_given.duplicate()
	return test + [friendly, type, self]
	

func on_hit(duration):
	$Tween.interpolate_property(self, "modulate:g", 1, 0, duration/3, 0, 2, 0)
	$Tween.interpolate_property(self, "modulate:b", 1, 0, duration/3, 0, 2, 0)
	
	$Tween.interpolate_property(self, "modulate:g", 0, 1, duration/3, 0, 2, duration*2/3)
	$Tween.interpolate_property(self, "modulate:b", 0, 1, duration/3, 0, 2, duration*2/3)
	$Tween.start()

func is_dead():
	$Sprite.visible = false
	$deadsprite.visible = true
	
var to_alive
func revive(duration):
	$Timer.wait_time = duration/3
	to_alive = true
	$Timer.start()
	
func kill_off(duration):
	$Timer.wait_time = duration/3
	to_alive = false
	$Timer.start()

func _on_Timer_timeout():
	if to_alive:
		$deadsprite.visible = false
		$AnimatedSprite.visible = true
		$AnimatedSprite.play("default", true)
	else:
		$Sprite.visible = false
		$AnimatedSprite.visible = true
		$AnimatedSprite.play("default", false)

func _on_AnimatedSprite_animation_finished():
	if to_alive:
		$Sprite.visible = true
		self.flip_to_direction("right", "down")
	else:
		$deadsprite.visible = true
	$AnimatedSprite.stop()
	$AnimatedSprite.visible = false
