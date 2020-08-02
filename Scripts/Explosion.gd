extends Node2D

onready var particles = $Particles2D

func _ready():
	particles.emitting = true


func _on_Timer_timeout():
	particles.process_material.set("radial_accel", -300)
