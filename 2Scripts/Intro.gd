extends Panel

func _ready():
	$Tween.interpolate_property($Label, "visible_characters", 0, len($Label.text), 9.0)
	$Tween.start()

func _on_Timer_timeout():
	$Surrender.visible = true
	$Continue.visible = true


func _on_Surrender_pressed():
	get_tree().change_scene("res://2Scenes/Coward.tscn")

func _on_Continue_pressed():
	get_tree().change_scene("res://2Scenes/Intro2.tscn")
