extends AudioStreamPlayer

var muted:bool = false

var current_song = 0
const BGM = [1,"res://Resources/TestMusic.wav"]

func _ready():
	pass #TODO: add start-up song

#Change to the song with a ref
func change_song(num):
	if num != current_song:
		match(num):
			1:
				current_song = BGM[0]
				self.set_stream(load(BGM[1]))
		if not muted:
			self.play()

#Mute/Unmute music
func mute_unmute():
	stream_paused = not muted
	muted = not muted
	
	if not muted and not playing:
		self.play()
