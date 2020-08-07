extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($Label, "modulate:a", 0, 1, 4, 0, 2, 3)
	$Tween.start()


func _on_End_pressed():
	get_tree().change_scene("res://2Scenes/Menu.tscn")


func _on_Timer_timeout():
	$End.visible = true
