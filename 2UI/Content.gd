#Just purely for drawing UI

tool
extends Panel

func _ready():
	pass # Replace with function body.

func _draw():
	#This draw the borders of the content panel of settings
	#top
	draw_rect(Rect2(Vector2(4,4), Vector2(rect_size.x -80,3)), Color8(57,89,131))
	#bottom
	draw_rect(Rect2(Vector2(4,rect_size.y-7), Vector2(rect_size.x -8,3)), Color8(57,89,131))
	
	#Smaller left
	draw_rect(Rect2(Vector2(rect_size.x - 80 + 4, 0), Vector2(3,7)), Color8(57,89,131))
	
	#Left
	draw_rect(Rect2(Vector2(4,4), Vector2(3,rect_size.y-8)), Color8(57,89,131))

	#Right
	draw_rect(Rect2(Vector2(rect_size.x-7,0), Vector2(3,rect_size.y-4)), Color8(57,89,131))
