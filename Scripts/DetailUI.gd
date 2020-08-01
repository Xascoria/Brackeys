extends Panel


func _ready():
	pass # Replace with function body.

func set_text(unit):
	var output = "Type: "
	if unit.is_friendly:
		output += "Friendly"
	else:
		output += "Enemy"
	output += "\nHealth: "
	output += str(unit.health)
	$Label.text = output
	
