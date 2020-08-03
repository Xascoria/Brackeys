extends AudioStreamPlayer

var muted:bool = false

func _ready():
	pass #TODO: add start-up song

#Change to the song with a ref
func change_song(ref_to_new_song):
	#Do nothing if the song is muted
	if muted:
		return
	
	self.set_stream(ref_to_new_song)
	self.play()

#Mute/Unmute music
func mute_unmute():
	stream_paused = not muted
	muted = not muted
