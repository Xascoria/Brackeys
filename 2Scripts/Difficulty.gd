extends Panel

func _ready():
	pass # Replace with function body.

func _on_Easy_pressed():
	GlobalVars.difficulty_hard = false
	get_tree().change_scene("res://2Scenes/Intro.tscn")

func _on_Hard_pressed():
	GlobalVars.difficulty_hard = true
	get_tree().change_scene("res://2Scenes/Intro.tscn")
