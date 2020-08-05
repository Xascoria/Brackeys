#API of the UI
extends Control

signal startTurn
signal restart
signal menu

func _ready():
	#Check if music is muted
	if BgmPlayer.muted:
		$Popup/Content/Mute.text = "UNMUTE SOUND"
	else:
		$Popup/Content/Mute.text = "MUTE SOUND"

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
	emit_signal("menu")

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

#This affect the number of units shown on the sidebar
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
	
func friendly_unit_details(index, unit_name, health, state, show_position):
	$FriendlyUnit/UnitDetails.setup(index, unit_name, health, state)
	$FriendlyUnit.rect_position = show_position
	$FriendlyUnit.popup()

func enemy_unit_details(index, unit_name, health, intent, show_position):
	$EnemyUnit/UnitDetails.setup(index, unit_name, health, intent)
	$EnemyUnit.rect_position = show_position
	$EnemyUnit.popup()

func _on_UnitDetails_attack(index):
	emit_signal("order_given", "attack", index)

func _on_UnitDetails_move(index):		
	emit_signal("order_given", "move", index)
	
func _on_UnitDetails_skipturn(index):
	emit_signal("order_given", "skipturn", index)
	
signal order_given(type, index)
signal continue_lvl
signal reset 

func _on_Continue_pressed():
	emit_signal("continue_lvl")
	
func _on_Reset_pressed():
	emit_signal("reset")

func set_order_given(index, is_not_skip):
	for i in $UnitPanel/InnerPanel.get_children():
		if i is Control and not i is Label:
			if i.index == index:
				i.change_state(is_not_skip)

func reset_orders():
	for i in $UnitPanel/InnerPanel.get_children():
		if i is Control and not i is Label:
			i.change_state(false)


func make_continue_visible():
	$Continue.show()
	
func make_reset_visible():
	$Reset.show()


