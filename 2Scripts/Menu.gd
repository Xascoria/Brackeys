extends Panel

func _ready():
	BgmPlayer.change_song(3)

func _on_Start_pressed():
	if not GlobalVars.level_unlocked[0]:
		get_tree().change_scene("res://2Scenes/Difficulty.tscn")
	
func _on_LevelSelection_pressed():
	get_tree().change_scene("res://2Scenes/LevelSelection.tscn")

func _on_Credits_pressed():
	get_tree().change_scene("res://2Scenes/Credits.tscn")

func _on_Exit_pressed():
	self.get_tree().quit()






