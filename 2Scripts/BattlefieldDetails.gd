tool
extends Node2D

var size = 6
const border_size = 5
const box_size = 50
onready var bf_label = load("res://2Resources/BFLabels.tscn")

var unit_details = [[false, Vector2(0,0), 3], [false, Vector2(2,0), 2], [false, Vector2(4,1), 2], 
	[true, Vector2(1,4), 3], [true, Vector2(4,4), 3]]
var buildings_details = [[2, [3,5]]]

func _ready():
	pass # Replace with function body.

func map_setup(map_size, unit_details, buildings_details):
	self.size = map_size
	self.unit_details = unit_details.duplicate(true)
	self.buildings_details = buildings_details.duplicate(true)

func _draw():
	for i in range(size+1):
		self.draw_rect(Rect2(Vector2(0,i*(border_size+box_size)), Vector2((size+1) * border_size + (size*box_size), border_size)), 
		Color.white, true)
		self.draw_rect(Rect2(Vector2(i*(border_size+box_size),0), Vector2(border_size, (size+1) * border_size + (size*box_size))), 
		Color.white, true)

	for i in unit_details:
		var pos = Vector2((i[1][0]*box_size) + ((i[1][0]+1)*border_size), (i[1][1]*box_size) + ((i[1][1]+1)*border_size) )
		self.draw_rect(Rect2(pos, Vector2(box_size, box_size)), Color.blue if i[0] else Color.red, true)
		
		var new_label = bf_label.instance()
		new_label.text = str(i[2])
		self.add_child(new_label)
		new_label.rect_position = pos + Vector2(1,0)
		
	for i in buildings_details:
		var pos = Vector2((i[1][0]*box_size) + ((i[1][0]+1)*border_size), (i[1][1]*box_size) + ((i[1][1]+1)*border_size) )
		self.draw_rect(Rect2(pos, Vector2(box_size, box_size)), Color.white, true)
		
		self.draw_line(pos, pos+Vector2(box_size,0), Color.black, 1, true)
		self.draw_line(pos, pos+Vector2(0,box_size), Color.black, 1, true)
		self.draw_line(pos+Vector2(0,box_size), pos+Vector2(box_size,box_size), Color.black, 1, true)
		self.draw_line(pos+Vector2(box_size,0), pos+Vector2(box_size,box_size), Color.black, 1, true)
		self.draw_line(pos, pos+Vector2(box_size,box_size), Color.black, 1, true)
		self.draw_line(pos+Vector2(box_size, 0), pos+Vector2(0 ,box_size), Color.black, 1, true)
