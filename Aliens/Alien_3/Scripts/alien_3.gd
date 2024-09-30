extends Node3D

@export var critical_impacts = 1
var mesh_instance
var material
@export var color = Color(0.821, 0.555, 0.66)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Alien_3/Fragments.connect("destroy", Desctroy)
	$Alien_3/Fragments.critical_impacts = critical_impacts
	mesh_instance = $Alien_3/Alien_3
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Desctroy ():
	queue_free()
