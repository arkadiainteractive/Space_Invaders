extends Node3D

@export var critical_impacts = 1
var mesh_instance
var material
@export var color = Color(1, 0.412, 0.043)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody3D/Fragments.connect("destroy", Desctroy)
	$RigidBody3D/Fragments.critical_impacts = critical_impacts
	mesh_instance = $RigidBody3D/Alien_2
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Desctroy ():
	queue_free()
