#Friendly Tank API
extends Node2D

var index
var unit_name
var health
var state = ""
var friendly = true
var order_given = []
const type = "tank"

const attack_pattern = [Vector2(3,0), Vector2(0,3), Vector2(-3,0), Vector2(0,-3)]
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
			$Sprite.position = Vector2(-0.118,-8.405)
			$Sprite.region_rect = Rect2(6.5,7,45.98,37)
			$"KinematicBody2D/left-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(0,-6.163)
			$Sprite.region_rect = Rect2(7,43,45.98,36)
			$"KinematicBody2D/left-lower".disabled = false
	elif direction == "right":
		if facing == "up":
			$Sprite.position = Vector2(-0.118,-8.405)
			$Sprite.region_rect = Rect2(51.5,7,45.98,37)
			$"KinematicBody2D/right-upper".disabled = false
		elif facing == "down":
			$Sprite.position = Vector2(0,-6.163)
			$Sprite.region_rect = Rect2(51,43,45.98,36)
			$"KinematicBody2D/left-lower".disabled = false
		
func get_unit_order():
	return order_given

#Return [action, location, friendly, type,self]
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
		$Sprite.visible = true
		$deadsprite.visible = false
	else:
		$Sprite.visible = false
		$deadsprite.visible = true

func start_blasting(direction, facing, duration):
	$ShootingTimer.wait_time = duration
	if facing == "down":
		$Sprite.visible = false
		$ShootingAnime.visible = true
		if direction == "right":
			$ShootingAnime.scale.x = -1
		else:
			$ShootingAnime.scale.x = 1
		$ShootingAnime.play()
		$ShootingTimer.start()

func _on_ShootingTimer_timeout():
	$ShootingAnime.stop()
	$ShootingAnime.visible = false
	$Sprite.visible = true
