extends Node3D

signal exploded
signal destroy
var impact_counter = 0
var critical_impacts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_fatal_collision (body: Node3D) -> void:
	impact_counter += 1
	if body.collision_layer == 2:
		Destroy()
	elif impact_counter > critical_impacts:
		Destroy()

func Destroy():
	emit_signal("exploded")
	emit_signal("destroy")
