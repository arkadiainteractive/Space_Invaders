extends Node3D

@export var critical_impacts = 1
var mesh_instance
var material
@export var color = Color(0.821, 0.555, 0.66)

func _ready() -> void:
	$Fragments.connect("destroy", Desctroy)
	$Fragments.critical_impacts = critical_impacts
	mesh_instance = $Alien_3
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = color

func Desctroy ():
	queue_free()
