extends Panel

func _ready():
	BgmPlayer.change_song(3)
	if GlobalVars.level_unlocked[0]:
		$LevelSelection.disabled = false

func _on_Start_pressed():
	if not GlobalVars.level_unlocked[0]:
		get_tree().change_scene("res://2Scenes/Difficulty.tscn")
	
func _on_LevelSelection_pressed():
	pass # Replace with function body.

func _on_Credits_pressed():
	pass # Replace with function body.

func _on_Exit_pressed():
	self.get_tree().quit()






