#API of a unit button & state in the UI
extends Control

var index = 0
var unit_name = "Placeholder"
var enabled:bool = true

func _ready():
	pass # Replace with function body.

func setup(index, unit_name, enabled):
	self.change_state(false)
	
	self.index = index
	self.unit_name = unit_name
	
	$UnitButton.text = unit_name
	
	self.enabled = enabled
	if not enabled:
		$UnitButton.disabled = true

func change_state(order_given):
	#Change text to green
	if order_given:
		$Label.text = "GIVEN"
		$Label.set("custom_colors/font_color", Color("0d6a00"))
	#Text to red
	else:
		$Label.text = "NULL"
		$Label.set("custom_colors/font_color", Color("ff0000"))

signal button_pressed(index)

func _on_UnitButton_pressed():
	emit_signal("button_pressed", index)
