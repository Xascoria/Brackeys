#API of the UI
extends Control

signal startTurn
signal restart

func _ready():
	pass 

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
	
