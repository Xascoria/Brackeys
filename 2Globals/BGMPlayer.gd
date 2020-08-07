extends AudioStreamPlayer

var muted:bool = false

var current_song = 0
const BGM = [1,"res://2Music/battle_reversed.wav"]
const Rewind = "res://2Music/Battle.wav"
const Menu = "res://2Music/titles_main_menu.wav"

func _ready():
	pass #TODO: add start-up song

#Change to the song with a ref
func change_song(num):
	if num != current_song:
		match(num):
			1:
				AudioServer.set_bus_effect_enabled(1,0,true)
				current_song = BGM[0]
				self.set_stream(load(BGM[1]))
				volume_db = -12
			2:
				AudioServer.set_bus_effect_enabled(1,0,false)
				current_song = 2
				self.set_stream(load(Rewind))
				volume_db = -6
			3:
				AudioServer.set_bus_effect_enabled(1,0,false)
				current_song = 3
				self.set_stream(load(Menu))
				volume_db = -6
		if not muted:
			self.play()

#Mute/Unmute music
func mute_unmute():
	stream_paused = not muted
	muted = not muted
	
	if not muted and not playing:
		self.play()
