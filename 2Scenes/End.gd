extends Panel

func _ready():
	BgmPlayer.change_song(3)
	$Tween.interpolate_property($Label, "visible_characters", 0, len($Label.text), 7.0)
	$Tween.start()

func _on_Timer_timeout():
	$End.visible = true

func _on_End_pressed():
	get_tree().change_scene("res://2Scenes/Menu.tscn")
