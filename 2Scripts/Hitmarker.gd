extends Node2D


var drawing = true
var drawing_explosion = false

func _ready():
	pass # Replace with function body.

func draw_reversed_explosion(draw_position):
	$Shockwave.visible = false
	
	$Tween.interpolate_property($Explosion, "scale", Vector2(0.5,0.5), Vector2(0,0), 0.75, 0, 2, 0)
	$Tween.interpolate_property($Explosion, "modulate:a", 0, 1, 0.25, 0, 2, 0)
	$Explosion.position = draw_position
	$Tween.start()
	
	$selfKillTimer.wait_time = 1
	$selfKillTimer.start()
	
func draw_reversed_shockwave(draw_position):
	$Explosion.visible = false
	
	$Tween.interpolate_property($Shockwave, "scale", Vector2(0.5,0.5), Vector2(0,0), 0.75, 0, 2, 0)
	$Tween.interpolate_property($Shockwave, "modulate:a", 0, 1, 0.25, 0, 2, 0)
	$Shockwave.position = draw_position
	$Tween.start()
	
	$selfKillTimer.wait_time = 1
	$selfKillTimer.start()

func _on_selfKillTimer_timeout():
	self.queue_free()
