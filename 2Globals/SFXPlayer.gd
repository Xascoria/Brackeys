extends AudioStreamPlayer

const button1 = "res://2Music/button1.wav"
const button2 = "res://2Music/button2.wav"
const click1 = "res://2Music/click.wav"
const click2 = "res://2Music/click2.wav"
const movement1 = "res://2Music/movement.wav"
const movement2 = "res://2Music/movement2.wav"
const open_order_menu = "res://2Music/open_order_menu.wav"
const start_game = "res://2Music/start_game.wav"
const select_order = "res://2Music/select_order.wav"

func _ready():
	pass # Replace with function body.

func play_sfx(num):
	match(num):
		1:
			self.set_stream(load(button1))
		2:
			self.set_stream(load(button2))
		3:
			self.set_stream(load(click1))
		4:
			self.set_stream(load(click2))
		5:
			self.set_stream(load(movement1))
		6:
			self.set_stream(load(movement2))
		7:
			self.set_stream(load(open_order_menu))
		8:
			self.set_stream(load(start_game))
		9:
			self.set_stream(load(select_order))
			
			
	play()
