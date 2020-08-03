extends Panel

func _ready():
	pass # Replace with function body.

func setup(unit_name, health:int, state):
	$InnerPanel/Name.text = "Name: " + unit_name
	$InnerPanel/Health.text = "\nHealth: " + str(health)
	$InnerPanel/State.text = "\n\nState: " + state
	
