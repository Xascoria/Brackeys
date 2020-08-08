extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ref_array = [$Panel/VBoxContainer/Level1, $Panel/VBoxContainer/Level2, $Panel/VBoxContainer/Level3, $Panel/VBoxContainer/Level4, $Panel/VBoxContainer/Level5]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Menu_pressed():
	get_tree().change_scene("res://2Scenes/Menu.tscn")


func _on_Level1_pressed():
	get_tree().change_scene("res://2Levels/Level1.tscn")

func _on_Level2_pressed():
	get_tree().change_scene("res://2Levels/Level2.tscn")

func _on_Level3_pressed():
	get_tree().change_scene("res://2Levels/Level3.tscn")

func _on_Level4_pressed():
	get_tree().change_scene("res://2Levels/Level5.tscn")

func _on_Level5_pressed():
	get_tree().change_scene("res://2Levels/Level4.tscn")
