#API of the UI
extends Control

func _ready():
	pass 

func _on_StartTurn_pressed():
	pass

func _on_Settings_pressed():
	$Popup.popup()

func _on_BattleLog_pressed():
	pass # Replace with function body.

func _on_Mute_pressed():
	pass # Replace with function body.

func _on_Restart_pressed():
	pass # Replace with function body.

func _on_Menu_pressed():
	pass # Replace with function body.

func update_date(new_date):
	$OuterPanel/InnerPanel/Date.text = new_date
