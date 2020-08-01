extends Node2D

var friendly
var is_move
var grid_cord
var node

func _ready():
	pass # Replace with function body.

func setup_sprite(friendly, is_move, grid_cord, node):
	self.friendly = friendly
	self.is_move = is_move
	self.grid_cord= grid_cord
	self.node = node
	
	var img 
	
	if friendly:
		if is_move:
			img = load("res://Resources/MoveTile.png")
		else:
			img = load("res://Resources/ShootTile.png")
	else:
		if is_move:
			img = load("res://Resources/MoveTileEnemy.png")
		else:
			img = load("res://Resources/ShoottileEnemy.png")
			
	var itex = ImageTexture.new()
	itex.create_from_image(img)
	$Sprite.set_texture(itex)
	
signal sqrt_clicked_on(friendly, grid_cord, is_move, node)

func _on_StaticBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("sqrt_clicked_on", friendly, grid_cord, is_move, node)

