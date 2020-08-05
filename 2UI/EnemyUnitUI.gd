extends Panel

var index = 5

func _ready():
	pass # Replace with function body.

#Need index to show what the unit is
func setup(index:int, unit_name, health:int, intent):
	self.index = index
	$InnerPanel/Name.text = "Name: " + unit_name
	$InnerPanel/Health.text = "\nHealth: " + str(health)
	$InnerPanel/Intent.text = "\n\nIntent: " + intent
