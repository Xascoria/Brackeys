#API of the UI
extends Control

signal startTurn
signal restart

func _ready():
	self.set_units_num(4,["Y", "M", "C", "A"], [true, true, false, false])

func _on_StartTurn_pressed():
	$StartTurn.disabled = true
	emit_signal("startTurn")

func _on_Settings_pressed():
	$Popup.popup()

func _on_BattleLog_pressed():
	pass # Replace with function body.

func _on_Mute_pressed():
	BgmPlayer.mute_unmute()
	if BgmPlayer.muted:
		$Popup/Content/Mute.text = "UNMUTE SOUND"
	else:
		$Popup/Content/Mute.text = "MUTE SOUND"

func _on_Restart_pressed():
	emit_signal("restart")

func _on_Menu_pressed():
	pass # Replace with function body.

###
### UI update methods
###

func enable_start_turn():
	$StartTurn.disabled = false

func update_date(new_date):
	$OuterPanel/InnerPanel/Date.text = new_date
	
var unit_button_node = preload("res://2UI/UnitNode.tscn")
#Store the unit_buttons refs
var unit_buttons = []

#This affect the units number on the sidebar
func set_units_num(num:int, names_array, enabled_array):
	#Set the panel sizes
	#This part uses 720 as hard code value
	$UnitPanel.rect_size = Vector2(244,52 + (num*36))
	$UnitPanel/InnerPanel.rect_size = Vector2(236,44 + (num*36))
	
	$UnitPanel.rect_position = Vector2(-8, 720 - 60 - (num*36))
	
	#Initialse unit buttons
	for i in range(num):
		var new_button = unit_button_node.instance()
		new_button.rect_position = Vector2(8, 40 + (i*36))
		new_button.setup(i, names_array[i], enabled_array[i])
		new_button.connect("button_pressed", self, "on_unit_button_pressed")
		unit_buttons.append(new_button)
		$UnitPanel/InnerPanel.add_child(new_button)
	
signal unit_selected(index)
func on_unit_button_pressed(index):
	emit_signal("unit_selected", index)
