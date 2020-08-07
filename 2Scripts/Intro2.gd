extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($Label, "visible_characters", 0, len($Label.text), 10.0)
	$Tween.start()

func _on_Timer_timeout():
	$Continue.visible = true

func _on_Continue_pressed():
	pass # Replace with function body.
