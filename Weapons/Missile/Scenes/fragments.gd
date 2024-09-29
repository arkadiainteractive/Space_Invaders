extends Node3D

signal missile_explosion
signal missile_destroyed
var impact_counter = 0
var critical_impacts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Destroy():
	emit_signal("missile_explosion")
	emit_signal("missile_destroyed")

func _on_area_3d_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	print ("EXPLOSION DEL MISIL")
	Destroy()
