extends AnimatedSprite

func _ready():
	pass # Replace with function body.

func play_reversed_exp():
	self.play("reversed")
	
func play_normal_exp():
	self.play("normal")


func _on_Explosion_animation_finished():
	self.queue_free()
