extends Panel

var index = 5

func _ready():
	pass # Replace with function body.

#Need index to show what the unit is
func setup(index:int, unit_name, health:int, state):
	self.index = index
	$InnerPanel/Name.text = "Name: " + unit_name
	$InnerPanel/Health.text = "\nHealth: " + str(health)
	$InnerPanel/State.text = "\n\nState: " + ("ALIVE" if health > 0 else "DEAD")
	
	if health == 0:
		$InnerPanel/Attack.disabled = true
		$InnerPanel/SkipTurn.disabled = true
		$InnerPanel/Move.disabled = true
	else:
		$InnerPanel/Attack.disabled = false
		$InnerPanel/SkipTurn.disabled = false
		$InnerPanel/Move.disabled = false

signal attack(index)
signal move(index)
signal skipturn(index)
func _on_Attack_pressed():
	emit_signal("attack", index)
	get_parent().hide()

func _on_Move_pressed():
	emit_signal("move", index)
	get_parent().hide()
	
func _on_SkipTurn_pressed():
	emit_signal("skipturn", index)
	get_parent().hide()
