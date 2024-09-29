extends Node3D

@export var critical_impacts = 1
var mesh_instance
var material
@export var color = Color(0.8, 0.745, 0.443)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody3D/Fragments.connect("destroy", Desctroy)
	$RigidBody3D/Fragments.critical_impacts = critical_impacts
	mesh_instance = $RigidBody3D/Alien_1
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = color
	$RigidBody3D.add_constant_central_force(Vector3(4,2,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func Desctroy ():
	queue_free()
